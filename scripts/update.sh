#!/bin/bash
# Script that pulls the latest files from repos and applies changes

echo

# Git
cd /home/user/git/xmpp.is && git pull
cd /home/user/git/mod_email_pass_reset_english && git pull
cd /home/user/git/prosody_web_registration_theme && git pull

# Mercurial
cd /var/lib/prosody/modules && hg pull && hg update

echo

echo "Pushing new configs and files"

bash /home/user/git/xmpp.is/scripts/sync.sh

echo

echo "Inserting Prosody secrets........."

bash /root/scripts/prosody-secrets.sh

echo "Forcing permissions.........."

bash /home/user/git/xmpp.is/scripts/force-owner-and-group.sh

echo

echo "Latest configs pushed! Restart or reload services to apply changes"

echo
