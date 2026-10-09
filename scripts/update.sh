#!/bin/bash
# Script that pulls the latest files from repos and applies changes

GIT_DIR="/home/user/git"
PROSODY_DATA_DIR="/var/lib/prosody"
ROOT_SCRIPTS_DIR="/root/scripts"

echo

# Git
# mod_web_password_reset and mod_web_account_delete are local copies rather than git
# checkouts (they have no upstream repo), so only pull the directories that are checkouts
for REPO in xmpp.is mod_register_web prosody_web_registration_theme mod_web_password_reset mod_web_account_delete; do
  if [ -d "${GIT_DIR}/${REPO}/.git" ]; then
    echo "Pulling ${REPO}"
    git -C "${GIT_DIR}/${REPO}" pull
  else
    echo "Skipping ${REPO}: not a git checkout"
  fi
done

# Mercurial
cd "${PROSODY_DATA_DIR}"/modules && hg pull && hg update

echo

echo "Pushing new configs and files"

bash "${GIT_DIR}"/xmpp.is/scripts/sync.sh

echo

echo "Inserting Prosody secrets"

bash "${ROOT_SCRIPTS_DIR}"/prosody-secrets.sh

#echo "Forcing permissions"

#bash "${GIT_DIR}"/xmpp.is/scripts/force-owner-and-group.sh

echo

echo "Latest configs pushed! Restart or reload services to apply changes"

echo
