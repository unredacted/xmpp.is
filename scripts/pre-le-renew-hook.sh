#!/bin/bash
# This script runs after a dehydrated cert renewal, it sets a flag for le-renew-hook.sh to check for

GIT_DIR="/home/user/git"

  if find "${GIT_DIR}"/dehydrated/certs/all -cmin -5 | grep ".pem"

    echo "1" > /tmp/dehydrated-flag
  
  else
  
    echo "Couldn't find any .pem files created within 5 minutes. Exiting now!"
    exit
    
  fi
