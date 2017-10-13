#!/bin/bash
# Script that pulls the latest files from repos and applies changes

echo

# Git
cd /home/git/xmpp.is && git pull
cd /var/lib/prosody/modules/mod_email_pass_reset_english && git pull
cd /etc/prosody/register-templates/Prosody-Web-Registration-Theme && git pull

# Mercurial
cd /var/lib/prosody/modules && hg pull && hg update

echo

echo "Pushing new configs and files"

bash /home/git/xmpp.is/scripts/sync.sh

echo

echo "Forcing permissions"

bash /home/git/xmpp.is/scripts/force-owner-and-group.sh

echo

echo "Latest configs pushed! Restart or reload services to apply changes"
