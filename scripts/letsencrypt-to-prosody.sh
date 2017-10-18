#!/bin/bash

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
