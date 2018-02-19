#!/bin/bash
# This script ensures that files and directories are chowned properly

# Prosody
chown -R prosody:prosody /etc/prosody
chown -R prosody:prosody /var/lib/prosody

# Git
chown -R user:user /home/git/xmpp.is
