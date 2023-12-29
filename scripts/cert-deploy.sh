#!/bin/sh
/usr/bin/prosodyctl --root cert import xmpp.is /etc/letsencrypt/live
/bin/systemctl reload nginx