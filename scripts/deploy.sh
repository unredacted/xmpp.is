#!/bin/sh

# Deploys XMPP.is on a new server

echo "Adding the official Prosody repository"
echo deb http://packages.prosody.im/debian $(lsb_release -sc) main | tee -a /etc/apt/sources.list
wget https://prosody.im/files/prosody-debian-packages.key -O- | apt-key add -

echo

echo "Running apt update"
apt update

echo

echo "Installing Prosody and dependencies"
apt install prosody lua-zlib lua-bitop

echo

echo "Installing dependencies for config & module pulling"
apt install git mercurial

echo

echo "Setting up Prosody directories"
mkdir /etc/prosody/certs
mkdir /etc/prosody/modules

echo

echo "Pulling git repo"
cd /etc/prosody && git clone https://github.com/lunarthegrey/xmpp.is

echo

echo "Forcing permissions"
bash /etc/prosody/scripts/force-owner-and-group.sh

echo

echo "Restarting Prosody"
service prosody restart
