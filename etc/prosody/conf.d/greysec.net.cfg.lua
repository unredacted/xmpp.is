VirtualHost "greysec.net"
admins = { "lunar@greysec.net", "insider@greysec.net" }

	enabled = true
        allow_registration = false;

	c2s_require_encryption = true
	s2s_secure_auth = false

	authentication = "internal_hashed"
        storage = "internal"

	ssl = {
		certificate = "/etc/prosody/certs/greysec.net/greysec.net.crt";
		key = "/etc/prosody/certs/greysec.net/greysec.net.key";
}
