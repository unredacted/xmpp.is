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

-- mod_onions --

onions_tor_all =  true
onions_only =  false

-- Imported from https://github.com/qbi/xmpp-onion-map with extra modifications
onions_map = {
	["worlio.com"] = "gaavkkdj6tpc6d27iq4omdk5o3ludg53xi4rmgpzwa2aobusb7bzudad.onion";
	["muc.worlio.com"] = "muc.gaavkkdj6tpc6d27iq4omdk5o3ludg53xi4rmgpzwa2aobusb7bzudad.onion";
	["5222.de"] = "fzdx522fvinbaqgwxdet45wryluchpplrkkzkry33um5tufkjd3wdaqd.onion";
	["anrc.mooo.com"] = "6w5iasklrbr2kw53zqrsjktgjapvjebxodoki3gjnmvb4dvcbmz7n3qd.onion";
	["cock.li"] = { host = "xdkriz6cn2avvcr2vks5lvvtmfojz2ohjzj4fhyuka55mvljeso2ztqd.onion", port = "5222" };
	["creep.im"] = "creep7nonbdm4nad2qbmri7z32ajg2l4vcwvzpxnty6wupvc5vfreoad.onion";
	["diebesban.de"] = "bztoavotvspxwehf52gw7xrljvj7rjucpwdoixoaoxgpwqkoex27jnid.onion";
	["dismail.de"] = "4colmnerbjz3xtsjmqogehtpbt5upjzef57huilibbq3wfgpsylub7yd.onion";
	["e2e.ee"] = { host = "e2eee76htm7znipwviwbjzdy7spoeje2gzcn23jyl77pplvhfa7lfyqd.onion", port = "5222" };
	["jabber.cat"] = "x76it4hax7s6s6j64ta6iiolar6o6hwlwoeyoqmkjcdgjza6gqqj5gyd.onion";
	["jabber.de"] = "uoj2xiqxk25p36wbpufiyuhluvxakhpqum7frembhoiuq7a5735ay3qd.onion";
	["jabber.hot-chilli.net"] = "chillingguw3yu2rmrkqsog4554egiry6fmy264l5wblyadds3c2lnyd.onion";
	["jabber.nr18.space"] = "szd7r26dbcrrrn4jthercrdypxfdmzzrysusyjohn4mpv2zbwcgmeqqd.onion";
	["jabber.otr.im"] = "ynnuxkbbiy5gicdydekpihmpbqd4frruax2mqhpc35xqjxp5ayvrjuqd.onion";
	["jabber.so36.net"] = "yxkc2uu3rlwzzhxf2thtnzd7obsdd76vtv7n34zwald76g5ogbvjbbqd.onion";
	["jabber.systemli.org"] = "razpihro3mgydaiykvxwa44l57opvktqeqfrsg3vvwtmvr2srbkcihyd.onion";
	["jabber.systemausfall.org"] = "jaswtrycaot3jzkr7znje4ebazzvbxtzkyyox67frgvgemwfbzzi6uqd.onion";
	["jabjab.de"] = "jabjabdea2eewo3gzfurscj2sjqgddptwumlxi3wur57rzf5itje2rid";
	["systemausfall.org"] = "jaswtrycaot3jzkr7znje4ebazzvbxtzkyyox67frgvgemwfbzzi6uqd.onion";
	["krautspace.de"] = "jeirlvruhz22jqduzixi6li4xyoweytqglwjons4mbuif76fgslg5uad.onion";
	["mdosch.de"] = "bztoavotvspxwehf52gw7xrljvj7rjucpwdoixoaoxgpwqkoex27jnid.onion";
	["talk36.net"] = "yxkc2uu3rlwzzhxf2thtnzd7obsdd76vtv7n34zwald76g5ogbvjbbqd.onion";
	["wiuwiu.de"] = "qawb5xl3mxiixobjsw2d45dffngyyacp4yd3wjpmhdrazwvt4ytxvayd.onion";
	["xmpp.is"] = "6voaf7iamjpufgwoulypzwwecsm2nu7j5jpgadav2rfqixmpl4d65kid.onion";
	["xmpp.riseup.net"] = "jukrlvyhgguiedqswc5lehrag2fjunfktouuhi4wozxhb6heyzvshuyd.onion";
	["trashserver.net"] = "xiynxwxxpw7olq76uhrbvx2ts3i7jagqnqix7arfbknmleuoiwsmt5yd.onion";
	["conference.trashserver.net"] = "xiynxwxxpw7olq76uhrbvx2ts3i7jagqnqix7arfbknmleuoiwsmt5yd.onion";
	["muc.kalli.st"] = "kallist4mcluuxbjnr5p2asdlmdhaos3pcrvhk3fbzmiiiftwg6zncid.onion";
	["rooms.pea.moe"] = "5edc2lyzvsnyq4i6fvlifsqrmpoqk7uhxh2povbhjnpa3nhh7cm6dtid.onion";
	["everypizza.im"] = "uvq5q7i6thamv6bfcagjy42fjobxaqgregc2t7xhetxhan3svb3zyeqd.onion";
	["conference.everypizza.im"] = "conference.uvq5q7i6thamv6bfcagjy42fjobxaqgregc2t7xhetxhan3svb3zyeqd.onion";
}

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