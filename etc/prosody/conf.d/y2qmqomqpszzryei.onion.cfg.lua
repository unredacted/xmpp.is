VirtualHost "y2qmqomqpszzryei.onion"
modules_enabled =  { "onions", "reload_modules" };
reload_modules = { "tls", "onions" };

	enabled = true
  
	allow_registration = true;
        welcome_message = "Welcome to $host, make sure you browse around the site for more details about us! https://xmpp.is/"
  
        c2s_require_encryption = true
	s2s_secure_auth = false

	ssl = {
	certificate = "/etc/prosody/certs/y2qmqomqpszzryei.onion/cert.pem";
	key = "/etc/prosody/certs/y2qmqomqpszzryei.onion/key.pem";
	};
        
  	onions_tor_all =  true 
  	onions_only =  false
  
  	-- Imported from https://github.com/nickcalyx/xmpp-onion-map --
  	onions_map = {
	["adb-centralen.se"] = "qai7jjjnhbrdiexf.onion";
	["anonymitaet-im-inter.net"] = "rwf5skuv5vqzcdit.onion";
	["autistici.org"] = "wi7qkxyrdpu5cmvr.onion";
	["jabber.calyxinstitute.org"] = "ijeeynrc6x2uy5ob.onion";
	["jabber.ccc.de"] = "okj7xc6j2szr2y75.onion";
	["cloak.dk"] = "m2dsl4banuimpm6c.onion";
	["jabber.cryptoparty.is"] = "cryjabkbdljzohnp.onion";
        ["daemons.cf"] = "daemon4jidu2oig6.onion";
	["dukgo.com"] = "wlcpmruglhxp6quz.onion";
	["evil.im"] = "evilxro6nvjuvxqo.onion";
	["xmpp.evil.im"] = "evilxro6nvjuvxqo.onion";
	["inventati.org"] = "wi7qkxyrdpu5cmvr.onion";
	["jabber.ipredator.se"] = "3iffdebkzzkpgipa.onion";
	["jabber-germany.de"] = "dbbrphko5tqcpar3.onion";
	["joelpurra.se"] = "37x6i3wgr2jyublb.onion";
	["kode.im"] = "ihkw7qy3tok45dun.onion";
	["im.koderoot.net"] = "ihkw7qy3tok45dun.onion";
	["jabber.lqdn.fr"] = "jabber63t4r2qi57.onion";
	["nordberg.se"] = "qai7jjjnhbrdiexf.onion";
	["jabber.otr.im"] = "5rgdtlawqkcplz75.onion";
        ["otromundo.cf"] = "arauemwe2utqqzye.onion";
	["patchcord.be"] = "xsydhi3dnbjuatpz.onion";
	["riseup.net"] = "4cjw6cwpeaeppfqz.onion";
        ["xmpp.riseup.net"] = "4cjw6cwpeaeppfqz.onion";
        ["rows.io"] = "yz6yiv2hxyagvwy6.onion";	
        ["xmpp.rows.io"] = "yz6yiv2hxyagvwy6.onion";
	["securejabber.me"] = "giyvshdnojeivkom.onion";
	["so36.net"] = "s4fgy24e2b5weqdb.onion";
	["jabber.so36.net"] = "s4fgy24e2b5weqdb.onion";
	["jabber.systemli.org"] = "x5tno6mwkncu5m3h.onion";
        ["taolo.ga"] = "l3ybpw4vs6ie5rv2.onion";
	["tchncs.de"] = "duvfmyqmdlyvc3mi.onion";
	["trashserver.net"] = "m4c722bvc2r7brnn.onion";
	["wtfismyip.com"] = "ofkztxcohimx34la.onion";
	["prosody.xmpp.is"] = "y2qmqomqpszzryei.onion";
	["xndr.de"] = "trcubpttd6zkc3tf.onion";
	["jabber.cat"] = "sybzodlxacch7st7.onion";
	};

--INSERT_SECRETS--
