VirtualHost "xmpp.is"
http_default_host = "xmpp.is"
modules_enabled = { "onions", "http", "register_web" };
reload_modules = { "tls", "onions", "http", "register_web", "http_upload" };
admins = { "admin_user_here" }

	enabled = true
        allow_registration = false;
	min_seconds_between_registrations = 300

	c2s_require_encryption = true
	s2s_secure_auth = false

	authentication = "internal_hashed"
        storage = "internal"

	ssl = {
	   certificate = "/etc/prosody/certs/xmpp.is.crt";
	   key = "/etc/prosody/certs/xmpp.is.key";
}

	http_ports = { 5280 }
	http_interfaces = { "*" }
 
	https_ports = { 5281 }
	https_interfaces = { "*" }

        captcha_options = {
        recaptcha_private_key = "private_key_here";
        recaptcha_public_key = "public_key_here";
}

        Component "upload.xmpp.is" "http_upload"
        http_upload_file_size_limit = 52428800
        http_upload_expire_after = 60 * 60 * 24 * 7

        Component "muc.xmpp.is" "muc"
        name = "XMPP.is MUC"
        restrict_room_creation = "local"
