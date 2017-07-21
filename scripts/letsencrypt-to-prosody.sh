#!/bin/bash

DIR=( "xmpp.is" "xmpp.co" "xmpp.cx" "xmpp.xyz" )
CERTS="/etc/prosody/certs/"
PROSODY="/etc/prosody/"

   find "/etc/letsencrypt/live/${DIR}" -name "*.pem" | while read -r file

do

   cp "${file}" "/etc/prosody/certs/${DIR}/"

done

   chown -R prosody:prosody "${PROSODY}"
   chmod -R 700 "${CERTS}"
   prosodyctl reload
