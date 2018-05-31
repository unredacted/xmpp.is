#!/bin/bash
# Deploys XMPP.is on a new server

GIT_DIR="/home/user/git"
PROSODY_DATA_DIR="/var/lib/prosody"

read -p "Have you copied over dehydrated.default.sh and other secrets? (Y/N) " REPLY
if [ "${REPLY,,}" == "y" ]; then
  echo "Continuing!"
else
  echo "Exiting now!"
exit
fi

echo "================================"

echo "Installing miscellaneous packages that I like or need :^)"
apt install -y htop dstat nload iftop iotop nmap haveged rsync dirmngr apt-utils apt-transport-https dialog ca-certificates wget curl nano lsb-release mtr-tiny ntp zip

echo "================================"

echo "Installing tools for remote backups"
apt install -y borgbackup nfs-common

echo "================================"

echo "Stopping and disabling rpcbind"
systemctl stop rpcbind
systemctl disable rpcbind

echo "================================"

echo "Adding Prosody Repository Key"
wget https://prosody.im/files/prosody-debian-packages.key -O- | apt-key add -

echo "================================"

echo "Adding Tor Repository Key"
gpg --keyserver pgp.mit.edu --recv A3C4F0F979CAA22CDBA8F512EE8CBC9E886DDD89
gpg --export A3C4F0F979CAA22CDBA8F512EE8CBC9E886DDD89 | apt-key add -

echo "================================"

echo "Adding Hiawatha Repository Key"
apt-key adv --recv-keys --keyserver pgp.mit.edu 79AF54A9

echo "================================"

echo "Adding GoAccess Repository Key"
wget -O - https://deb.goaccess.io/gnugpg.key | apt-key add -

echo "================================"

echo "Running apt update"
apt update

echo "================================"

echo "Installing Prosody"
apt install -y prosody lua-zlib lua-bitop lua-event lua-socket lua-sec

echo "================================"

echo "Installing Tor"
apt install -y tor deb.torproject.org-keyring

echo "================================"

echo "Installing Hiawatha"
apt install -y hiawatha

echo "================================"

echo "Installing GoAccess"
apt install -y goaccess

echo "================================"

echo "Installing dependencies for config & module pulling"
apt install -y git mercurial

echo "================================"

echo "Making directories"
mkdir -p /etc/prosody/certs
mkdir -p /etc/hiawatha/ssl

echo "================================"

echo "Adding users"
useradd -m -s /bin/bash user

echo "================================"

echo "Pulling configs and modules"

echo "================================"

# Prosody configs & scripts
git clone https://github.com/crypto-world/xmpp.is "${GIT_DIR}"/xmpp.is

# Official Prosody modules
hg clone https://hg.prosody.im/prosody-modules/ "${PROSODY_DATA_DIR}"/modules

# Email password reset module
git clone https://github.com/crypto-world/mod_email_pass_reset_english "${GIT_DIR}"/mod_email_pass_reset_english

# Prosody web registration theme
git clone https://github.com/crypto-world/prosody_web_registration_theme "${GIT_DIR}"/prosody_web_registration_theme

echo "================================"

read -p "Would you like to issue certificates with dehydrated? (Y/N) " REPLY
if [ "${REPLY,,}" == "y" ]; then
  echo "Issuing initial SSL/TLS certificates"
  bash "${GIT_DIR}"/dehydrated/dehydrated --register --accept-terms --hook /home/user/git/dehydrated/dehydrated.default.sh
  bash "${GIT_DIR}"/dehydrated/dehydrated --cron --alias all --hook "${GIT_DIR}"/dehydrated/dehydrated.default.sh; bash "${GIT_DIR}"/xmpp.is/scripts/pre-le-renew-hook.sh
  bash "${GIT_DIR}"/xmpp.is/scripts/letsencrypt-renew-hook.sh
else
  echo "Continuing!"
fi

echo "================================"

echo "Applying open file limits"
echo "prosody hard nofile 999999" | tee -a /etc/security/limits.conf
echo "prosody soft nofile 999999" | tee -a /etc/security/limits.conf
echo "DefaultLimitNOFILE=999999" | tee -a /etc/systemd/system.conf
echo "fs.file-max = 999999" | tee -a /etc/sysctl.conf
echo "MAXFDS=999999" | tee -a /etc/default/prosody

echo "================================"

echo "Setting up TCP BBR"
echo "net.core.default_qdisc=fq" | tee -a /etc/sysctl.conf
echo "net.ipv4.tcp_congestion_control=bbr" | tee -a /etc/sysctl.conf

echo "================================"

echo "Executing final steps"
bash "${GIT_DIR}"/xmpp.is/scripts/le-renew-hook.sh
bash "${GIT_DIR}"/xmpp.is/scripts/cert-fingerprint.sh
bash "${GIT_DIR}"/xmpp.is/scripts/sync.sh
bash "${GIT_DIR}"/xmpp.is/scripts/force-owner-and-group.sh

echo "================================"

echo "Restarting services"
service prosody restart
service hiawatha start
service tor restart

echo "================================"

echo "Deploy finished, server must be rebooted now"
