daemonize = true;
use_libevent = true;
pidfile = "/var/run/prosody/prosody.pid"
plugin_paths = { "/var/lib/prosody/modules" }
c2s_ports = { "5222" }
legacy_ssl_ports = { "5223" }
default_storage = "internal"

	storage = {

	-- mod_mam --
	archive = "memory"

	}

	-- mod_reload_modules --
	
	reload_modules = {

	"tls";

	}

	modules_enabled = {

	-- Core Enabled Modules --

	"roster"; -- Allow users to have a roster. Recommended ;)
	"saslauth"; -- Authentication for clients and servers. Recommended if you want to log in.
	"tls"; -- Add support for secure TLS on c2s/s2s connections
	"dialback"; -- s2s dialback support
	"disco"; -- Service discovery
	"posix"; -- POSIX functionality, sends server to background, enables syslog, etc.
	"private"; -- Private XML storage (for room bookmarks, etc.)
	"vcard4"; -- Add support for the new vcard format
	"vcard_legacy"; -- Support old vcard format for legacy clients
	"version"; -- Replies to server version requests
	"uptime"; -- Report how long server has been running
	"time"; -- Let others know the time here on this server
	"ping"; -- Replies to XMPP pings with pongs
	"pep_simple"; -- Enables users to publish their mood, activity, playing music and more
	"register"; -- Allow users to register on this server using a client and change passwords
	"admin_adhoc"; -- Allows administration via an XMPP client that supports ad-hoc commands
	"announce"; -- Send announcement to all online users
	"bosh"; -- Enable BOSH clients, aka "Jabber over HTTP"
        "admin_telnet"; -- Opens telnet console interface on localhost port 5582
	"welcome"; -- Welcome users who register accounts
	"blocklist"; -- New module replacing mod_privacy
	"carbons"; -- Officially included in Prosody now
	"proxy65"; -- Proxy for clients behind NAT or firewalls

	--- Downloaded & Enabled Modules ---

	-- Misc --

	"reload_modules";		
	"default_vcard";
	"cloud_notify";
	"server_contact_info";

	-- Security --

	"omemo_all_access";
	"filter_chatstates";
	"block_registrations";
	"limits";
	"limit_auth";

	-- Optimzation --

	"smacks";
	"csi";
	"csi_battery_saver";
	"log_slow_events";
	"mam";
	};
	
	modules_disabled = {
	
	-- Disabled Modules --

	"groups"; -- Shared roster support
	"watchregistrations"; -- Alert admins of registrations
	"motd"; -- Send a message to users when they log in
	"legacyauth"; -- Legacy authentication. Only used by some old clients and bots.
	-- "http_files"; -- Serve static files from a directory over HTTP
	-- "offline"; -- Offline messages
	};

-- mod_welcome --

welcome_message = "Welcome to $host, make sure you browse around the site for more details about us! https://xmpp.is/"

	-- mod_server_contact_info --

	contact_info = {
	abuse = { "https://xmpp.is/contact/" };
	admin = { "https://xmpp.is/contact/" };
	feedback = { "https://xmpp.is/contact/" };
	support = { "https://xmpp.is/contact/" };
	};

	-- Log Config --

	log = {
	info = "/var/log/prosody/prosody.info";
	warn = "/var/log/prosody/prosody.warn";
	error = "/var/log/prosody/prosody.err";
	debug = "/dev/null";
	}

	-- mod_tls --

	ssl = {
	certificate = "/etc/prosody/certs/fullchain.pem";
	key = "/etc/prosody/certs/privkey.pem";
	}

	https_ssl = {
	certificate = "/etc/prosody/certs/fullchain.pem";
	key = "/etc/prosody/certs/privkey.pem";
	}

	-- mod_limits --

	limits = {

	c2s = {
	rate = "1kb/s";
	burst = "10s";
	};

	s2sin = {
	rate = "1kb/s";
	burst = "10s";
	};

	s2sout = {
	rate = "1kb/s";
	burst = "10s";
	};

	}

-- mod_http --

http_ports = { 5280 }
http_interfaces = { "*" }

https_ports = { 5281 }
https_interfaces = { "*" }

-- mod_log_slow_events --
log_slow_events_threshold = 1

-- mod_limit_auth --
limit_auth_period = 30
limit_auth_max = 5

-- mod_mam --
default_archive_policy = true
archive_expires_after = "1d"
max_archive_query_results = 20;
mam_smart_enable = true

-- mod_smacks --
smacks_hibernation_time = 300
smacks_enabled_s2s = false
smacks_max_unacked_stanzas = 0
smacks_max_ack_delay = 60
smacks_max_hibernated_sessions = 10
smacks_max_old_sessions = 10

-- mod_block_registrations --
block_registrations_users = { "administrator", "admin", "hostmaster", "postmaster", "webmaster", "root", "xmpp", "lunar" }
block_registrations_require = "^[a-zA-Z0-9_.-]+$" -- Allow only simple ASCII characters in usernames

Include "conf.d/*.cfg.lua"

--INSERT_SECRETS--
