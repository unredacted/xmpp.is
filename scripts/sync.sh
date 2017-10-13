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

# Cron
crontab /home/git/xmpp.is/var/spool/cron/crontabs/root
cp /home/git/xmpp.is/etc/cron.d/certbot /etc/cron.d/certbot
