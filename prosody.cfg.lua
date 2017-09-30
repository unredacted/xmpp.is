daemonize = true;

use_libevent = true;

reload_modules = { "tls", "blocking", "s2s_log_certs", "limit_auth", "smacks", "carbons", "csi", "filter_chatstates", "limits" }

modules_enabled = {

	-- Enabled --

		"roster"; -- Allow users to have a roster. Recommended ;)
		"saslauth"; -- Authentication for clients and servers. Recommended if you want to log in.
		"tls"; -- Add support for secure TLS on c2s/s2s connections
		"dialback"; -- s2s dialback support
		"disco"; -- Service discovery
		"posix"; -- POSIX functionality, sends server to background, enables syslog, etc.
		"private"; -- Private XML storage (for room bookmarks, etc.)
		"vcard"; -- Allow users to set vCards
    "privacy"; -- Enable mod_privacy
		"compression"; -- Stream compression (requires the lua-zlib package installed)
		"version"; -- Replies to server version requests
		"uptime"; -- Report how long server has been running
		"time"; -- Let others know the time here on this server
		"ping"; -- Replies to XMPP pings with pongs
		"pep"; -- Enables users to publish their mood, activity, playing music and more
		"register"; -- Allow users to register on this server using a client and change passwords
		"admin_adhoc"; -- Allows administration via an XMPP client that supports ad-hoc commands
		"announce"; -- Send announcement to all online users
		"bosh"; -- Enable BOSH clients, aka "Jabber over HTTP"
    "admin_telnet"; -- Opens telnet console interface on localhost port 5582

	-- Downloaded Enabled Modules --

		"blocking";
		"s2s_log_certs";
		"reload_modules";		
		"limit_auth";
		"smacks";
		"carbons";
		"csi";
		"filter_chatstates";
		"limits";
		-- "email_pass_reset";

	-- Disabled --

		--"groups"; -- Shared roster support
		--"welcome"; -- Welcome users who register accounts
		--"watchregistrations"; -- Alert admins of registrations
		--"motd"; -- Send a message to users when they log in
		--"legacyauth"; -- Legacy authentication. Only used by some old clients and bots.
		--"http_files"; -- Serve static files from a directory over HTTP

};

pidfile = "/var/run/prosody/prosody.pid"

plugin_paths = { "/usr/lib/prosody/downloaded-modules" }

log = {
	info = "/dev/null";
	error = "/var/log/prosody/prosody.err";
}

        ssl = {
           certificate = "/etc/prosody/certs/xmpp.is/fullchain.pem";
           key = "/etc/prosody/certs/xmpp.is/privkey.pem";
}

        https_ssl = {
           certificate = "/etc/prosody/certs/xmpp.is/fullchain.pem";
           key = "/etc/prosody/certs/xmpp.is/privkey.pem";
}

s2s_log_certs_persist = true

limits = {
  c2s = {
    rate = "10kb/s";
    burst = "5s";
  };
  s2sin = {
    rate = "10kb/s";
    burst = "5s";
  };
  s2sout = {
    rate = "10kb/s";
    burst = "5s";
  };
}

-- mod_limit_auth --
limit_auth_period = 30
limit_auth_max = 5

-- mod_smacks --
smacks_hibernation_time = 300
smacks_enabled_s2s = false
smacks_max_unacked_stanzas = 0
smacks_max_ack_delay = 60

Include "conf.d/*.cfg.lua"

-- Private stuff injected below after git pull --
