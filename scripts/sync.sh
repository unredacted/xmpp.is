#!/bin/bash
# Script that syncs all updated files to their corresponding directories

GIT_DIR="/home/user/git"
PROSODY_DATA_DIR="/var/lib/prosody"
ROOT_SCRIPTS_DIR="/root/scripts"

# Run chown-root.sh to force root ownership
bash "${GIT_DIR}"/xmpp.is/scripts/chown-root.sh

# Sync some scripts to /etc/letsencrypt/renewal-hooks
echo
echo "Syncing some scripts to /etc/letsencrypt/renewal-hooks/post"
rsync -av "${GIT_DIR}"/xmpp.is/scripts/cert-fingerprint.sh /etc/letsencrypt/renewal-hooks/post/

# Prosody config
echo
echo "Syncing Prosody configs"
rsync -av "${GIT_DIR}"/xmpp.is/etc/prosody/ /etc/prosody/

# Core Prosody files
#echo
#echo "Syncing core Prosody files"
#rsync -av "${GIT_DIR}"/xmpp.is/usr/lib/prosody/ /usr/lib/prosody/

# Tor config
echo
echo "Syncing Tor configs"
rsync -av "${GIT_DIR}"/xmpp.is/etc/tor/ /etc/tor/

# Apt config
echo
echo "Syncing Apt configs"
rsync -av "${GIT_DIR}"/xmpp.is/etc/apt/ /etc/apt/

# Logrotate
echo
echo "Syncing logrotate configs"
rsync -av "${GIT_DIR}"/xmpp.is/etc/logrotate.d/ /etc/logrotate.d/

# OpenSSL
echo
echo "Syncing OpenSSL configs"
rsync -av "${GIT_DIR}"/xmpp.is/etc/ssl/ /etc/ssl/

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

# mod_register_web
echo
echo "Syncing mod_register_web"
rsync -av "${GIT_DIR}"/mod_register_web/ /var/lib/prosody/modules/mod_register_web/

# mod_web_password_reset
echo
echo "Syncing mod_web_password_reset"
rsync -av "${GIT_DIR}"/mod_web_password_reset/ /var/lib/prosody/modules/mod_web_password_reset/

# Cron
echo
echo "Syncing crontabs"
crontab -u root "${GIT_DIR}"/xmpp.is/var/spool/cron/crontabs/root
crontab -u user "${GIT_DIR}"/xmpp.is/var/spool/cron/crontabs/user
