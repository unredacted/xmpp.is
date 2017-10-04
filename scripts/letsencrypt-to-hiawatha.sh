#!/bin/bash

DIR1="xmpp.is"
DIR2="xmpp.co"
DIR3="xmpp.cx"
DIR4="xmpp.xyz"
LE_DIR="/etc/letsencrypt/live/"
HIAWATHA_CERTS="/etc/hiawatha/ssl/"
HIAWATHA="/etc/hiawatha/"

cat "${LE_DIR}${DIR1}"/privkey.pem "${LE_DIR}${DIR1}"/fullchain.pem > "${HIAWATHA_CERTS}${DIR1}".pem
cat "${LE_DIR}${DIR2}"/privkey.pem "${LE_DIR}${DIR2}"/fullchain.pem > "${HIAWATHA_CERTS}${DIR2}".pem
cat "${LE_DIR}${DIR3}"/privkey.pem "${LE_DIR}${DIR3}"/fullchain.pem > "${HIAWATHA_CERTS}${DIR3}".pem
cat "${LE_DIR}${DIR4}"/privkey.pem "${LE_DIR}${DIR4}"/fullchain.pem > "${HIAWATHA_CERTS}${DIR4}".pem

# Restart Hiawatha
service hiawatha restart
