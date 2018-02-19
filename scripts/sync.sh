#!/bin/bash
# Script that syncs all updated files to their corresponding directories

# Prosody config
echo
echo "Syncing Prosody configs."
rsync -av /home/user/git/xmpp.is/etc/prosody/ /etc/prosody/

# Hiawatha config
echo
echo "Syncing Hiawatha configs.."
rsync -av /home/user/git/xmpp.is/etc/hiawatha/ /etc/hiawatha/

# Tor config
echo
echo "Syncing Tor configs..."
rsync -av /home/user/git/xmpp.is/etc/tor/ /etc/tor/

# Webroot
echo
echo "Syncing /var/www/...."
rsync -av /home/user/git/xmpp.is/var/www/ /var/www/

# Mercurial
echo
echo "Syncing /etc/mercurial....."
rsync -av /home/user/git/xmpp.is/etc/mercurial/ /etc/mercurial/

# Prosody Modules

# prosody_web_registration_theme
echo
echo "Syncing prosody_web_registration_theme......"
rsync -av /home/user/git/prosody_web_registration_theme /etc/prosody/register-templates/

# mod_email_pass_reset_english
echo
echo "Syncing mod_email_pass_reset_english......."
rsync -av /home/user/git/mod_email_pass_reset_english /var/lib/prosody/modules/
cp /var/lib/prosody/modules/mod_email_pass_reset_english/vcard.lib.lua /var/lib/prosody/modules/vcard.lib.lua

# Cron
echo
echo "Syncing crontabs........"
crontab /home/user/git/xmpp.is/var/spool/cron/crontabs/root
cp /home/user/git/xmpp.is/etc/cron.d/certbot /etc/cron.d/certbot
