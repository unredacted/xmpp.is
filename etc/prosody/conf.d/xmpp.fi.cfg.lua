VirtualHost "xmpp.fi"
http_host = "http.xmpp.fi"
http_external_url = "https://http.xmpp.fi/"
trusted_proxies = { "127.0.0.1" };
modules_enabled = { "onions", "http", "register_web", "reload_modules", "turncredentials" };
reload_modules = { "tls", "onions", "http", "register_web", "http_file_share", "turncredentials" };

enabled = true

allow_registration = false;
min_seconds_between_registrations = 300
welcome_message = "Welcome to $host, make sure you browse around the site for more details about us! https://xmpp.is/"

c2s_require_encryption = true
s2s_require_encryption = true
s2s_secure_auth = true

ssl = {
  certificate = "/etc/prosody/certs/xmpp.is.crt";
  key = "/etc/prosody/certs/xmpp.is.key";
}

register_web_template = "/etc/prosody/register-templates/prosody_web_registration_theme"

turncredentials_host = "turn.xmpp.fi"

--INSERT_SECRETS--

Component "http.xmpp.fi" "http_file_share"
http_file_share_expires_after = 60 * 60 * 24 * 7
http_file_share_size_limit = 100*1024*1024

Component "muc.xmpp.fi" "muc"
name = "XMPP.fi MUC"
restrict_room_creation = "local"
modules_enabled = { "vcard_muc", "muc_mam", "muc_limits", "muc_block_pm" };
muc_event_rate = 1
muc_burst_factor = 6
muc_max_nick_length = 20

Component "envoy.xmpp.fi" "proxy65"
