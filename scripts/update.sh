#!/bin/bash
# Script that pulls the latest files from repos and applies changes

echo

# Git
cd /home/git/xmpp.is && git pull
cd /etc/prosody/modules/git-modules/mod_email_pass_reset_english && git pull
cd /etc/prosody/register-templates/Prosody-Web-Registration-Theme && git pull

# Mercurial
cd /etc/prosody/modules/prosody-modules && hg pull && hg update

echo

echo "Pushing new configs and files"

# Prosody config
rsync -av /home/git/xmpp.is/prosody/ /etc/prosody/

# Hiawatha config
rsync -av /home/git/xmpp.is/hiawatha/ /etc/hiawatha/

# Tor config
rsync -av /home/git/xmpp.is/tor/ /etc/tor/

# Webroot
rsync -av /home/git/xmpp.is/www/ /var/www/

# Cron
crontab /home/git/xmpp.is/system/crontab
cp /home/git/xmpp.is/system/cron/certbot /etc/cron.d/certbot

echo

echo "Latest configs pushed! Restart or reload services to apply changes"
