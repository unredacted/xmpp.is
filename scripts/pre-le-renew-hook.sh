#!/bin/bash
# This script runs after a dehydrated cert renewal, it sets a flag for le-renew-hook.sh to check for

GIT_DIR="/home/user/git"
DEHYDRATED_RENEW_FLAG="/home/user/flags/dehydrated-renew"

# Find .pem files that have been modified within 30 minutes, if yes, set flag
if find "${GIT_DIR}"/dehydrated/certs/all -mmin -30 | grep "fullchain.pem"; then
  echo "Setting flag to 1!"
  echo `date`
  echo "1" > "${DEHYDRATED_RENEW_FLAG}"
else
  echo "Couldn't find any .pem files created within 30 minutes. Exiting now!"
  exit  
fi
