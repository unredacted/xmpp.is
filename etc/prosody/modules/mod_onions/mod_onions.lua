-- Patched copy of mod_onions from prosody-modules (last changed upstream in rev 4945, 2022-05-20).
--
-- Prosody 13's mod_s2s keeps queued stanzas for not-yet-connected s2s sessions in a
-- util.queue (sendq:push(), sendq.count(), sendq:consume()), but upstream mod_onions still
-- creates a plain Lua array. mod_s2s then crashes with
--   mod_s2s.lua:204: attempt to call a nil value (method 'push')
--   mod_s2s.lua:376: attempt to call a nil value (field 'count')
-- and the queued stanzas to .onion servers are lost. This copy creates the sendq as a
-- util.queue and bounces it the same way mod_s2s does.
--
-- It also fixes the SOCKS5 phase, before mod_s2s takes over the connection: failures
-- (proxy errors, Tor closing the connection, no answer within s2s_timeout) now destroy the
-- session and bounce its queue instead of leaving it wedged in s2sout, the status checks
-- actually work, partial reads are no longer replayed, and finished connections are
-- removed from the session map.
--
-- It is loaded instead of the prosody-modules checkout because /etc/prosody/modules comes
-- first in plugin_paths. Drop it once upstream mod_onions is fixed.

local prosody = prosody;
local core_process_stanza = prosody.core_process_stanza;

local addclient = require "net.server".addclient;
local s2s_new_outgoing = require "core.s2smanager".new_outgoing;
local s2s_destroy_session = require "core.s2smanager".destroy_session;
local initialize_filters = require "util.filters".initialize;
local st = require "util.stanza";
local errors = require "util.error";
local new_queue = require "util.queue".new;

local portmanager = require "core.portmanager";

local softreq = require "util.dependencies".softreq;

local bit = assert(softreq "bit" or softreq "bit32" or softreq "util.bitcompat", "No bit module found. See https://prosody.im/doc/depends#bitop");

local band = bit.band;
local rshift = bit.rshift;
local lshift = bit.lshift;

local byte = string.byte;
local c = string.char;

module:depends("s2s");

local proxy_ip = module:get_option_string("onions_socks5_host", "127.0.0.1");
local proxy_port = module:get_option_number("onions_socks5_port", 9050);
local forbid_else = module:get_option_boolean("onions_only", false);
local torify_all = module:get_option_boolean("onions_tor_all", false);
local onions_map = module:get_option("onions_map", {});
local sendq_size = module:get_option_number("s2s_send_queue_size", 1024*32);
local connect_timeout = module:get_option_period("s2s_timeout", 90);

local sessions = module:shared("sessions");

-- The socks5listener handles connection while still connecting to the proxy,
-- then it hands them over to the normal listener (in mod_s2s)
local socks5listener = { default_port = proxy_port, default_mode = "*a", default_interface = "*" };

-- The connection through the proxy failed before mod_s2s took over: destroy the session,
-- which removes it from s2sout and bounces its queued stanzas, so the next stanza retries
local function socks5_failed(conn, session, reason)
	module:log("debug", "SOCKS5 connection to %s failed: %s", tostring(session.socks5_to), reason);
	sessions[conn] = nil;
	s2s_destroy_session(session, reason);
	conn:close();
end

local function socks5_connect_sent(conn, data)

	local session = sessions[conn];

	if #data < 5 then
		session.socks5_buffer = data;
		return;
	end

	local request_status = byte(data, 2);

	if request_status ~= 0x00 then
		socks5_failed(conn, session, ("Tor could not connect to %s (SOCKS5 status 0x%02x)"):format(tostring(session.socks5_to), request_status));
		return;
	end

	module:log("debug", "Successfully connected to SOCKS5 proxy.");

	local response = byte(data, 4);

	if response == 0x01 then
		if #data < 10 then
			-- let's try again when we have enough
			session.socks5_buffer = data;
			return;
		end

		-- this means the server tells us to connect on an IPv4 address
		local ip = string.format("%d.%d.%d.%d", byte(data, 5,8));
		local port = band(byte(data, 9), lshift(byte(data, 10), 8));
		module:log("debug", "Should connect to: %s:%d", ip, port);

		if not (ip == "0.0.0.0" and port == 0) then
			socks5_failed(conn, session, "The SOCKS5 proxy tells us to connect to a different IP, don't know how");
			return;
		end

		-- Now the real s2s listener can take over the connection.
		local listener = portmanager.get_service("s2s").listener;

		module:log("debug", "SOCKS5 done, handing over listening to "..tostring(listener));

		session.socks5_handler = nil;
		session.socks5_buffer = nil;
		sessions[conn] = nil; -- mod_s2s tracks the connection from here on

		local w, log = conn.send, session.log;

		local filter = initialize_filters(session);

		session.version = 1;

		session.sends2s = function (t)
			log("debug", "sending (s2s over socks5): %s", (t.top_tag and t:top_tag()) or t:match("^[^>]*>?"));
			if t.name then
				t = filter("stanzas/out", t);
			end
			if t then
				t = filter("bytes/out", tostring(t));
				if t then
					return conn:write(tostring(t));
				end
			end
		end

		session.open_stream = function ()
			session.sends2s(st.stanza("stream:stream", {
				xmlns='jabber:server', ["xmlns:db"]='jabber:server:dialback',
				["xmlns:stream"]='http://etherx.jabber.org/streams',
				from=session.from_host, to=session.to_host, version='1.0', ["xml:lang"]='en'}):top_tag());
		end

		conn.setlistener(conn, listener);

		listener.register_outgoing(conn, session);

		listener.onconnect(conn);
	else
		socks5_failed(conn, session, ("Unsupported SOCKS5 address type 0x%02x"):format(response));
	end
end

local function socks5_handshake_sent(conn, data)

	local session = sessions[conn];

	if #data < 2 then
		session.socks5_buffer = data;
		return;
	end

	-- version, method
	local request_status = byte(data, 2);

	module:log("debug", "SOCKS version: "..byte(data, 1));
	module:log("debug", "Response: "..request_status);

	if request_status ~= 0x00 then
		socks5_failed(conn, session, "The SOCKS5 proxy seems to require authentication");
		return;
	end

	module:log("debug", "Sending connect message.");

	-- version 5, connect, (reserved), type: domainname, (length, hostname), port
	conn:write(c(5) .. c(1) .. c(0) .. c(3) .. c(#session.socks5_to) .. session.socks5_to);
	conn:write(c(rshift(session.socks5_port, 8)) .. c(band(session.socks5_port, 0xff)));

	session.socks5_handler = socks5_connect_sent;
end

function socks5listener.onconnect(conn)
	module:log("debug", "Connected to SOCKS5 proxy, sending SOCKS5 handshake.");

	local session = sessions[conn];
	if not session then return; end

	-- Socks version 5, 1 method, no auth
	conn:write(c(5) .. c(1) .. c(0));

	session.socks5_handler = socks5_handshake_sent;
end

function socks5listener.register_outgoing(conn, session)
	session.direction = "outgoing";
	sessions[conn] = session;
end

function socks5listener.ondisconnect(conn, err)
	local session = sessions[conn];
	sessions[conn] = nil;
	if session then
		-- Tor closed the connection before mod_s2s took over
		s2s_destroy_session(session, "Connection through Tor failed: "..tostring(err or "closed"));
	end
end

function socks5listener.onincoming(conn, data)
	local session = sessions[conn];
	if not session then return; end

	-- Prepend a partial reply from a previous read; handlers store it again if still incomplete
	if session.socks5_buffer then
		data = session.socks5_buffer .. data;
		session.socks5_buffer = nil;
	end

	if session.socks5_handler then
		session.socks5_handler(conn, data);
	end
end

local function connect_socks5(host_session, connect_host, connect_port)

	module:log("debug", "Connecting to " .. connect_host .. ":" .. connect_port);

	-- this is not necessarily the same as .to_host (it can be that this is from the onions_map)
	host_session.socks5_to = connect_host;
	host_session.socks5_port = connect_port;

	local conn, err = addclient(proxy_ip, proxy_port, socks5listener, "*a");
	if not conn then
		s2s_destroy_session(host_session, "Could not connect to the Tor SOCKS5 proxy: "..tostring(err));
		return;
	end

	socks5listener.register_outgoing(conn, host_session);

	host_session.conn = conn;

	-- mod_s2s only starts its own connect timeout once it takes over the connection
	module:add_timer(connect_timeout, function ()
		if sessions[conn] == host_session then
			socks5_failed(conn, host_session, "Timed out connecting through Tor");
		end
	end);
end

local bouncy_stanzas = { message = true, presence = true, iq = true };
local function bounce_sendq(session, reason)
	local sendq = session.sendq;
	if not sendq then return; end
	session.log("info", "Sending error replies for "..sendq.count().." queued stanzas because of failed outgoing connection to "..tostring(session.to_host));
	local dummy = {
		type = "s2sin";
		send = function(s)
			(session.log or log)("error", "Replying to to an s2s error reply, please report this! Traceback: %s", debug.traceback());
		end;
		dummy = true;
		close = function ()
			(session.log or log)("error", "Attempting to close the dummy origin of s2s error replies, please report this! Traceback: %s", debug.traceback());
		end;
	};
	-- Same error conditions as mod_s2s's bounce_sendq
	local error_type = "cancel";
	local condition = "remote-server-not-found";
	local reason_text;
	if session.had_stream then -- set when a stream is opened by the remote
		error_type, condition = "wait", "remote-server-timeout";
	end
	if errors.is_error(reason) then
		error_type, condition, reason_text = reason.type, reason.condition, reason.text;
	elseif type(reason) == "string" then
		reason_text = reason;
	end
	for stanza in sendq:consume() do
		if not stanza.attr.xmlns and bouncy_stanzas[stanza.name] and stanza.attr.type ~= "error" and stanza.attr.type ~= "result" then
			local reply = st.error_reply(stanza, error_type, condition,
				reason_text and ("Server-to-server connection failed: "..reason_text) or nil);
			core_process_stanza(dummy, reply);
		end
	end
	session.sendq = nil;
end
-- Try to intercept anything to *.onion
local function route_to_onion(event)
	local stanza = event.stanza;
	local to_host = event.to_host;
	local onion_host = nil;
	local onion_port = nil;

	if not to_host:find("%.onion$") then
		if onions_map[to_host] then
			if type(onions_map[to_host]) == "string" then
				onion_host = onions_map[to_host];
			else
				onion_host = onions_map[to_host].host;
				onion_port = onions_map[to_host].port;
			end
		elseif forbid_else then
			module:log("debug", event.to_host .. " is not an onion. Blocking it.");
			return false;
		elseif not torify_all then
			return;
		end
	end

	module:log("debug", "Onion routing something to ".. to_host);

	if hosts[event.from_host].s2sout[to_host] then
		return;
	end

	local host_session = s2s_new_outgoing(event.from_host, to_host);

	host_session.bounce_sendq = bounce_sendq;
	host_session.sendq = new_queue(sendq_size);
	host_session.sendq:push(st.clone(stanza));

	hosts[event.from_host].s2sout[to_host] = host_session;

	connect_socks5(host_session, onion_host or to_host, onion_port or 5269);

	return true;
end

module:log("debug", "Onions ready and loaded");

module:hook("route/remote", route_to_onion, 200);

module:hook_global("s2s-check-certificate", function (event)
	local host = event.host;
	if host and host:find("%.onion$") then
		-- This cancels the event chain without reporting any cert
		-- validation results. The connection will typically proceed
		-- to auth using dialback.
		return true;
	end
end);

