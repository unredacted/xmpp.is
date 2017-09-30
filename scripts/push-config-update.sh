#!/bin/sh

# Script that pushes a config update

echo

echo "Pulling latest repo"
cd /home/git/xmpp.is && git pull

echo

echo "rsyncing configs"

# Prosody config
rsync -av /home/git/xmpp.is/prosody/ /etc/prosody/

# Hiawatha config
rsync -av /home/git/xmpp.is/hiawatha/ /etc/hiawatha/

# Tor config
rsync -av /home/git/xmpp.is/tor/ /etc/tor/

echo

echo "Latest configs pushed! Restart or reload services to apply changes"
