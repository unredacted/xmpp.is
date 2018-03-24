#!/bin/bash
# Script that syncs all updated files to their corresponding directories

GIT_DIR="/home/user/git"
PROSODY_DATA_DIR="/var/lib/prosody"
ROOT_SCRIPTS_DIR="/root/scripts"

# Prosody config
echo
echo "Syncing Prosody configs"
rsync -av "${GIT_DIR}"/xmpp.is/etc/prosody/ /etc/prosody/

# Hiawatha config
echo
echo "Syncing Hiawatha configs"
rsync -av "${GIT_DIR}"/xmpp.is/etc/hiawatha/ /etc/hiawatha/

# Dehydrated config
echo
echo "Syncing Dehydrated configs"
rsync -av "${GIT_DIR}"/xmpp.is/home/user/git/dehydrated/ "${GIT_DIR}"/dehydrated/

# Tor config
echo
echo "Syncing Tor configs"
rsync -av "${GIT_DIR}"/xmpp.is/etc/tor/ /etc/tor/

# Apt config
echo
echo "Syncing Apt configs"
rsync -av "${GIT_DIR}"/xmpp.is/etc/apt/ /etc/apt/

# Webroot
echo
echo "Syncing /var/www/"
rsync -av "${GIT_DIR}"/xmpp.is/var/www/ /var/www/

# Mercurial
echo
echo "Syncing /etc/mercurial"
rsync -av "${GIT_DIR}"/xmpp.is/etc/mercurial/ /etc/mercurial/

# Prosody Modules

# prosody_web_registration_theme
echo
echo "Syncing prosody_web_registration_theme"
rsync -av "${GIT_DIR}"/prosody_web_registration_theme /etc/prosody/register-templates/

# mod_email_pass_reset_english
echo
echo "Syncing mod_email_pass_reset_english"
rsync -av "${GIT_DIR}"/mod_email_pass_reset_english "${PROSODY_DATA_DIR}"/
cp "${PROSODY_DATA_DIR}"/modules/mod_email_pass_reset_english/vcard.lib.lua "${PROSODY_DATA_DIR}"/modules/vcard.lib.lua

# Cron
echo
echo "Syncing crontabs"
crontab -u root "${GIT_DIR}"/xmpp.is/var/spool/cron/crontabs/root
crontab -u user "${GIT_DIR}"/xmpp.is/var/spool/cron/crontabs/user
