#!/bin/bash
# This script is executed during the systemd Let's Encrypt renewal service to ensure the updates certs are in place

# xmpp.is
cat /etc/letsencrypt/live/xmpp.is/privkey.pem /etc/letsencrypt/live/xmpp.is/fullchain.pem > /etc/hiawatha/ssl/xmpp.is.pem

# webstats.xmpp.is
cat /etc/letsencrypt/live/webstats.xmpp.is/privkey.pem /etc/letsencrypt/live/webstats.xmpp.is/fullchain.pem > /etc/hiawatha/ssl/webstats.xmpp.is.pem

# xmpp.co
cat /etc/letsencrypt/live/xmpp.co/privkey.pem /etc/letsencrypt/live/xmpp.co/fullchain.pem > /etc/hiawatha/ssl/xmpp.co.pem

# xmpp.cx
cat /etc/letsencrypt/live/xmpp.cx/privkey.pem /etc/letsencrypt/live/xmpp.cx/fullchain.pem > /etc/hiawatha/ssl/xmpp.cx.pem

# xmpp.xyz
cat /etc/letsencrypt/live/xmpp.xyz/privkey.pem /etc/letsencrypt/live/xmpp.xyz/fullchain.pem > /etc/hiawatha/ssl/xmpp.xyz.pem
