#!/bin/bash
# Script that copies over all new certificates to Prosody and sets correct permissions

LE_DIR="/home/user/git/dehydrated/certs/all/"
PROSODY_CERTS="/etc/prosody/certs/"
PROSODY="/etc/prosody/"

cp "${LE_DIR}.fullchain.pem" "${PROSODY_CERTS}"
cp "${LE_DIR}.privkey.pem" "${PROSODY_CERTS}"

chown -R prosody:prosody "${PROSODY}"
chmod -R 700 "${CERTS}"
prosodyctl reload

# Make sure mod_tls and mod_http get reloaded
{ echo "module:reload('tls')"; sleep 1; } | telnet localhost 5582
{ echo "module:reload('http')"; sleep 1; } | telnet localhost 5582
