VirtualHost "y2qmqomqpszzryei.onion"
modules_enabled =  { "onions" };
reload_modules = { "tls", "onions" };

	enabled = true
  
	allow_registration = true;
  
        c2s_require_encryption = true
	s2s_secure_auth = false

	authentication = "internal_hashed"
        storage = "internal"

	ssl = {
	   certificate = "/etc/prosody/certs/y2qmqomqpszzryei.onion/cert.pem";
	   key = "/etc/prosody/certs/y2qmqomqpszzryei.onion/key.pem";
}
        
  onions_tor_all =  true 
  onions_only =  false
  
  onions_map = {
  ["jabber.calyxinstitute.org"] = "ijeeynrc6x2uy5ob.onion";
  ["jabber.ccc.de"] = "okj7xc6j2szr2y75.onion";
  ["jabber.ipredator.se"] = "3iffdebkzzkpgipa.onion";
  ["jabber.otr.im"] = "5rgdtlawqkcplz75.onion";
  ["jabber.systemli.org"] = "x5tno6mwkncu5m3h.onion";
  ["jabber.so36.net"] = "s4fgy24e2b5weqdb.onion";
  ["jabber.cryptoparty.is"] = "cryjabkbdljzohnp.onion";
  ["jabber.lqdn.fr"] = "jabber63t4r2qi57.onion";
  ["xmpp.riseup.net"] = "4cjw6cwpeaeppfqz.onion";
  ["xmpp.rows.io"] = "yz6yiv2hxyagvwy6.onion";
  ["autistici.org"] = "wi7qkxyrdpu5cmvr.onion";
  ["inventati.org"] = "wi7qkxyrdpu5cmvr.onion";
  ["daemons.cf"] = "daemon4jidu2oig6.onion";
  ["otromundo.cf"] = "arauemwe2utqqzye.onion";
  ["taolo.ga"] = "l3ybpw4vs6ie5rv2.onion";
  ["securejabber.me"] = "giyvshdnojeivkom.onion";
  ["cloak.dk"] = "m2dsl4banuimpm6c.onion";
  ["kode.im"] = "ihkw7qy3tok45dun.onion";
  ["im.koderoot.net"] = "ihkw7qy3tok45dun.onion";
  ["wtfismyip.com"] = "ofkztxcohimx34la.onion";
  ["dukgo.com"] = "wlcpmruglhxp6quz.onion";
  ["patchcord.be"] = "xsydhi3dnbjuatpz.onion";
}

--INSERT_SECRETS--
