#!/bin/bash
# Script that pulls the latest files from repos and applies changes

GIT_DIR="/home/user/git"
PROSODY_DATA_DIR="/var/lib/prosody"
ROOT_SCRIPTS_DIR="/root/scripts"

echo

# Git
cd "${GIT_DIR}"/xmpp.is && git pull
cd "${GIT_DIR}"/mod_email_pass_reset_english && git pull
cd "${GIT_DIR}"/prosody_web_registration_theme && git pull

# Mercurial
cd "${PROSODY_DATA_DIR}"/modules && hg pull && hg update

echo

echo "Pushing new configs and files"

bash "${GIT_DIR}"/xmpp.is/scripts/sync.sh

echo

echo "Inserting Prosody secrets"

bash "${ROOT_SCRIPTS_DIR}"/prosody-secrets.sh

echo "Forcing permissions"

bash "${GIT_DIR}"/xmpp.is/scripts/force-owner-and-group.sh

echo

echo "Latest configs pushed! Restart or reload services to apply changes"

echo
