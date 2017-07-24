#!/bin/bash
# This script is executed from the systemd Let's Encrypt renewal service to ensure the updated certs are in place and converted to Hiawatha format

# xmpp.is, xmpp.co, xmpp.cx, xmpp.xyz
cat /etc/letsencrypt/live/xmpp.is/privkey.pem /etc/letsencrypt/live/xmpp.is/fullchain.pem > /etc/hiawatha/ssl/xmpp.is.pem
cat /etc/letsencrypt/live/xmpp.co/privkey.pem /etc/letsencrypt/live/xmpp.co/fullchain.pem > /etc/hiawatha/ssl/xmpp.co.pem
cat /etc/letsencrypt/live/xmpp.cx/privkey.pem /etc/letsencrypt/live/xmpp.cx/fullchain.pem > /etc/hiawatha/ssl/xmpp.cx.pem
cat /etc/letsencrypt/live/xmpp.xyz/privkey.pem /etc/letsencrypt/live/xmpp.xyz/fullchain.pem > /etc/hiawatha/ssl/xmpp.xyz.pem

# webstats.xmpp.is
cat /etc/letsencrypt/live/webstats.xmpp.is/privkey.pem /etc/letsencrypt/live/webstats.xmpp.is/fullchain.pem > /etc/hiawatha/ssl/webstats.xmpp.is.pem

# Restart Hiawatha
service hiawatha restart
