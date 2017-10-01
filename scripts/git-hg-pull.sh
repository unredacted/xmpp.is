#!/bin/bash
# Script that pulls the latest files from repos

echo

# Git
cd /home/git/xmpp.is && git pull
cd /etc/prosody/modules/git-modules/mod_email_pass_reset && git pull
cd /etc/prosody/register-templates/Prosody-Web-Registration-Theme && git pull

# Mercurial
cd /etc/prosody/modules/prosody-modules && hg pull && hg update

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
