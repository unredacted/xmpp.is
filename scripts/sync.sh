#!/bin/bash

# Prosody config
rsync -av /home/git/xmpp.is/etc/prosody/ /etc/prosody/

# Hiawatha config
rsync -av /home/git/xmpp.is/etc/hiawatha/ /etc/hiawatha/

# Tor config
rsync -av /home/git/xmpp.is/etc/tor/ /etc/tor/

# Webroot
rsync -av /home/git/xmpp.is/var/www/ /var/www/

# Mercurial
rsync -av /home/git/xmpp.is/etc/mercurial/ /etc/mercurial/

# Prosody Modules

# prosody_web_registration_theme
rsync -av /home/git/prosody_web_registration_theme /etc/prosody/register-templates/

# mod_email_pass_reset_english
rsync -av /home/git/mod_email_pass_reset_english /var/lib/prosody/modules/

# Cron
crontab /home/git/xmpp.is/var/spool/cron/crontabs/root
cp /home/git/xmpp.is/etc/cron.d/certbot /etc/cron.d/certbot
