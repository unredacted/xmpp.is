#!/bin/sh
export BORG_PASSPHRASE='passwordhere'
REPOSITORY=/backup/borg/xmpp.is

# Backup Process
/usr/local/bin/borg create -v --stats --compression lzma        \
    $REPOSITORY::'{hostname}-{now:%Y-%m-%d}'                    \
    /etc/prosody                                                \
    /etc/hiawatha                                               \
    /var/lib/prosody                                            \
    /var/www                                                    \
    --exclude /var/lib/prosody/http_upload                      \
    --exclude /var/lib/prosody/greysec%2enet/offline            \
    --exclude /var/lib/prosody/xmpp%2eis/offline                \
    --exclude /var/lib/prosody/y2qmqomqpszzryei%2eonion/offline

# Prune Backups
/usr/local/bin/borg prune -v --list $REPOSITORY --prefix '{hostname}-' \
    --keep-daily=7 --keep-weekly=4 --keep-monthly=12
