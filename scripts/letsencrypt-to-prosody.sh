#!/bin/bash
# Script that copies over all new certificates to Prosody and sets correct permissions

DIR1="xmpp.is"
DIR2="xmpp.co"
DIR3="xmpp.cx"
DIR4="xmpp.xyz"
DIR5="xmpp.fi"
LE_DIR="/etc/letsencrypt/live/"
CERTS="/etc/prosody/certs/"
PROSODY="/etc/prosody/"

cp -rfL "${LE_DIR}${DIR1}/" "${CERTS}"
cp -rfL "${LE_DIR}${DIR2}/" "${CERTS}"
cp -rfL "${LE_DIR}${DIR3}/" "${CERTS}"
cp -rfL "${LE_DIR}${DIR4}/" "${CERTS}"
cp -rfL "${LE_DIR}${DIR5}/" "${CERTS}"

chown -R prosody:prosody "${PROSODY}"
chmod -R 700 "${CERTS}"
prosodyctl reload

# Make sure mod_tls gets reloaded if not by 'prosodyctl reload'
{ echo "module:reload('tls')"; sleep 1; } | telnet localhost 5582
