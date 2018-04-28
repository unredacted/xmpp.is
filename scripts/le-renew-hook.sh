#!/bin/bash
# This script is ran after dehydrated renews a certificate, links to other scripts that keep certs automagically up-to-date

GIT_DIR="/home/user/git"

if grep "1" /tmp/dehydrated-flag
  then

    bash "${GIT_DIR}"/xmpp.is/scripts/letsencrypt-to-hiawatha.sh
    bash "${GIT_DIR}"/xmpp.is/scripts/letsencrypt-to-prosody.sh
    bash "${GIT_DIR}"/xmpp.is/scripts/cert-fingerprint.sh

    echo "Script run complete! Set flag back to 0"
    echo "0" > /tmp/dehydrated-flag

  else
    echo "Looks like the flag is set to 0... Exiting now!"
    exit
  fi
