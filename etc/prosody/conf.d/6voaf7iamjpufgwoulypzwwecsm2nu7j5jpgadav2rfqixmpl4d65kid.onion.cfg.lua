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

onions_tor_all =  true
onions_only =  false

-- Imported from https://github.com/nyxnor/xmpp-onion-map/blob/master/v3-onions-map.lua
onions_map = {
	["5222.de"] = "fzdx522fvinbaqgwxdet45wryluchpplrkkzkry33um5tufkjd3wdaqd.onion";
	["anrc.mooo.com"] = "6w5iasklrbr2kw53zqrsjktgjapvjebxodoki3gjnmvb4dvcbmz7n3qd.onion";
	["cock.li"] = { host = "xdkriz6cn2avvcr2vks5lvvtmfojz2ohjzj4fhyuka55mvljeso2ztqd.onion", port = "5222" };
	["creep.im"] = "creep7nonbdm4nad2qbmri7z32ajg2l4vcwvzpxnty6wupvc5vfreoad.onion";
	["dismail.de"] = "4colmnerbjz3xtsjmqogehtpbt5upjzef57huilibbq3wfgpsylub7yd.onion";
	["e2e.ee"] = { host = "e2eee76htm7znipwviwbjzdy7spoeje2gzcn23jyl77pplvhfa7lfyqd.onion", port = "5222" };
	["jabber.cat"] = "x76it4hax7s6s6j64ta6iiolar6o6hwlwoeyoqmkjcdgjza6gqqj5gyd.onion";
	["jabber.de"] = "uoj2xiqxk25p36wbpufiyuhluvxakhpqum7frembhoiuq7a5735ay3qd.onion";
	["jabber.hot-chilli.net"] = "chillingguw3yu2rmrkqsog4554egiry6fmy264l5wblyadds3c2lnyd.onion";
	["jabber.otr.im"] = "ynnuxkbbiy5gicdydekpihmpbqd4frruax2mqhpc35xqjxp5ayvrjuqd.onion";
	["jabber.so36.net"] = "yxkc2uu3rlwzzhxf2thtnzd7obsdd76vtv7n34zwald76g5ogbvjbbqd.onion";
	["jabber.systemli.org"] = "razpihro3mgydaiykvxwa44l57opvktqeqfrsg3vvwtmvr2srbkcihyd.onion";
	["jabber.systemausfall.org"] = "jaswtrycaot3jzkr7znje4ebazzvbxtzkyyox67frgvgemwfbzzi6uqd.onion";
	["jabjab.de"] = "jabjabdea2eewo3gzfurscj2sjqgddptwumlxi3wur57rzf5itje2rid";
	["systemausfall.org"] = "jaswtrycaot3jzkr7znje4ebazzvbxtzkyyox67frgvgemwfbzzi6uqd.onion";
	["krautspace.de"] = "jeirlvruhz22jqduzixi6li4xyoweytqglwjons4mbuif76fgslg5uad.onion";
	["jabber.nr18.space"] = "szd7r26dbcrrrn4jthercrdypxfdmzzrysusyjohn4mpv2zbwcgmeqqd.onion";
	["talk36.net"] = "yxkc2uu3rlwzzhxf2thtnzd7obsdd76vtv7n34zwald76g5ogbvjbbqd.onion";
	["wiuwiu.de"] = "qawb5xl3mxiixobjsw2d45dffngyyacp4yd3wjpmhdrazwvt4ytxvayd.onion";
	["xmpp.is"] = "6voaf7iamjpufgwoulypzwwecsm2nu7j5jpgadav2rfqixmpl4d65kid.onion";
	["xmpp.riseup.net"] = "jukrlvyhgguiedqswc5lehrag2fjunfktouuhi4wozxhb6heyzvshuyd.onion";
	["xmpp.trashserver.net"] = "xiynxwxxpw7olq76uhrbvx2ts3i7jagqnqix7arfbknmleuoiwsmt5yd.onion";
}

--INSERT_SECRETS--

Component "http.6voaf7iamjpufgwoulypzwwecsm2nu7j5jpgadav2rfqixmpl4d65kid.onion" "http_file_share"
http_file_share_expires_after = 60 * 60 * 24 * 7
http_file_share_size_limit = 100*1024*1024