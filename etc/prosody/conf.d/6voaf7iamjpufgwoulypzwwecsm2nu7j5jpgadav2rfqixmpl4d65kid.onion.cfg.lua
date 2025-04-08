VirtualHost "6voaf7iamjpufgwoulypzwwecsm2nu7j5jpgadav2rfqixmpl4d65kid.onion"
http_host = "http.6voaf7iamjpufgwoulypzwwecsm2nu7j5jpgadav2rfqixmpl4d65kid.onion"
http_external_url = "http://http.6voaf7iamjpufgwoulypzwwecsm2nu7j5jpgadav2rfqixmpl4d65kid.onion/"
trusted_proxies = { "127.0.0.1" };
modules_enabled = { "onions", "http", "reload_modules" };
reload_modules = { "tls", "onions", "http", "http_file_share" };

enabled = true

allow_registration = true;
welcome_message = "Welcome to $host, make sure you browse around the site for more details about us! https://xmpp.is/"

c2s_require_encryption = true
s2s_secure_auth = false

ssl = {
  certificate = "/etc/prosody/certs/6voaf7iamjpufgwoulypzwwecsm2nu7j5jpgadav2rfqixmpl4d65kid.onion/cert.pem";
  key = "/etc/prosody/certs/6voaf7iamjpufgwoulypzwwecsm2nu7j5jpgadav2rfqixmpl4d65kid.onion/key.pem";
};

--INSERT_SECRETS--

Component "muc.6voaf7iamjpufgwoulypzwwecsm2nu7j5jpgadav2rfqixmpl4d65kid.onion" "muc"
name = "XMPP.is Tor HSv3 MUC"
restrict_room_creation = "local"
modules_enabled = { "onions", "vcard_muc", "muc_mam", "muc_limits", "muc_block_pm", "muc_moderation", "muc_restrict_media" };
muc_event_rate = 1
muc_burst_factor = 6
muc_max_nick_length = 20

Component "envoy.6voaf7iamjpufgwoulypzwwecsm2nu7j5jpgadav2rfqixmpl4d65kid.onion" "proxy65"

Component "http.6voaf7iamjpufgwoulypzwwecsm2nu7j5jpgadav2rfqixmpl4d65kid.onion" "http_file_share"
http_file_share_expires_after = 60 * 60 * 24 * 7
http_file_share_size_limit = 100*1024*1024