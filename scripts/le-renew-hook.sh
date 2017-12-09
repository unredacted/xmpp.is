#!/bin/bash
# This script is ran after certbot renews a certificate, links to other scripts that keep certs automagically up-to-date

bash /home/git/xmpp.is/scripts/letsencrypt-to-hiawatha.sh
bash /home/git/xmpp.is/scripts/letsencrypt-to-prosody.sh
bash /home/git/xmpp.is/scripts/cert-fingerprint.sh
