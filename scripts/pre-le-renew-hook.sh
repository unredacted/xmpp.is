#!/bin/bash
# This script runs after a dehydrated cert renewal, it sets a flag for le-renew-hook.sh to check for

GIT_DIR="/home/user/git"

if find "${GIT_DIR}"/dehydrated/certs/all -cmin -30 | grep ".pem"
  
  then

    echo "1" > /tmp/dehydrated-flag
  
  else
  
    echo "Couldn't find any .pem files created within 30 minutes. Exiting now!"
    exit
    
fi
