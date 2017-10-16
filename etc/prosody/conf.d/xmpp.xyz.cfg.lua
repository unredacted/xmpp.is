VirtualHost "xmpp.xyz"
http_host = "http.xmpp.xyz"
modules_enabled = { "http", "register_web" };
reload_modules = { "tls", "http", "register_web", "http_upload" };

	enabled = true

        allow_registration = false;
	min_seconds_between_registrations = 300

	c2s_require_encryption = true
	s2s_secure_auth = false

	authentication = "internal_hashed"
        storage = "internal"

	ssl = {
	   certificate = "/etc/prosody/certs/xmpp.xyz/fullchain.pem";
	   key = "/etc/prosody/certs/xmpp.xyz/privkey.pem";
}

        https_ssl = {
           certificate = "/etc/prosody/certs/xmpp.xyz/fullchain.pem";
           key = "/etc/prosody/certs/xmpp.xyz/privkey.pem";
}

        http_ports = { 5280 }
        http_interfaces = { "*" }

        https_ports = { 5281 }
        https_interfaces = { "*" }

	register_web_template = "/etc/prosody/register-templates/prosody_web_registration_theme"

        Component "upload.xmpp.xyz" "http_upload"
        http_upload_file_size_limit = 10485760
        http_upload_expire_after = 60 * 60 * 24 * 7

        Component "muc.xmpp.is" "muc"
        name = "XMPP.is MUC"
        restrict_room_creation = "local"

-- Private stuff injected below after git pull --
