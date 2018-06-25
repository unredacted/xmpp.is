#!/bin/bash
# This script is ran after dehydrated renews a certificate, links to other scripts that keep certs automagically up-to-date

GIT_DIR="/home/user/git"
DEHYDRATED_RENEW_FLAG="/tmp/flags/dehydrated-renew"
echo `date`

if grep "1" "${DEHYDRATED_RENEW_FLAG}"

  then

    bash "${GIT_DIR}"/xmpp.is/scripts/letsencrypt-to-hiawatha.sh
    bash "${GIT_DIR}"/xmpp.is/scripts/letsencrypt-to-prosody.sh
    bash "${GIT_DIR}"/xmpp.is/scripts/cert-fingerprint.sh

    echo "Script run complete! Set flag back to 0."
    echo "0" > "${DEHYDRATED_RENEW_FLAG}"

  else
  
    echo "Looks like the flag is set to 0... Exiting now!"
    exit
    
  fi
