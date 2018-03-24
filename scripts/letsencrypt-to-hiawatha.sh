#!/bin/bash
# Script that copies all new certificates over and puts them in Hiawatha format

LE_DIR="/home/user/git/dehydrated/certs/all"
HIAWATHA_CERTS="/etc/hiawatha/ssl"

cat "${LE_DIR}"/privkey.pem "${LE_DIR}"/fullchain.pem > "${HIAWATHA_CERTS}"/hiawatha.pem

# Restart Hiawatha
service hiawatha restart
