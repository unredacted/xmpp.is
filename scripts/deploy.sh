#!/bin/bash
# Deploys XMPP.is on a new server

echo

echo "Installing packages I like or need :)"
apt install -y htop dstat nload iftop nmap iotop haveged rsync dirmngr apt-transport-https

echo

echo "Adding the official Prosody repository"
echo deb http://packages.prosody.im/debian $(lsb_release -sc) main | tee -a /etc/apt/sources.list
wget https://prosody.im/files/prosody-debian-packages.key -O- | apt-key add -

echo

echo "Adding the official Tor repository"
echo deb https://deb.torproject.org/torproject.org $(lsb_release -sc) main | tee -a /etc/apt/sources.list
gpg --keyserver keys.gnupg.net --recv A3C4F0F979CAA22CDBA8F512EE8CBC9E886DDD89
gpg --export A3C4F0F979CAA22CDBA8F512EE8CBC9E886DDD89 | apt-key add -

echo

echo "Adding Hiawatha repository"
echo deb https://mirror.tuxhelp.org/debian/ squeeze main | tee -a /etc/apt/sources.list
apt-key adv --recv-keys --keyserver keys.gnupg.net 79AF54A9

echo

echo "Running apt update"
apt update

echo

echo "Installing Prosody"
apt install -y prosody lua-zlib lua-bitop lua-event lua-socket lua-sec

echo

echo "Installing Tor"
apt install -y tor deb.torproject.org-keyring

echo

echo "Installing Hiawatha"
apt install -y hiawatha

echo

echo "Installing Certbot"
apt install -y certbot

echo

echo "Installing dependencies for config & module pulling"
apt install -y git mercurial

echo

echo "Making directories"
mkdir /etc/prosody/certs
mkdir /etc/hiawahta/ssl

echo

echo "Pulling configs and modules"

echo

# Prosody configs & scripts
git clone https://github.com/lunarthegrey/xmpp.is /home/git/xmpp.is

# Prosody web registration theme
git clone https://github.com/lunarthegrey/Prosody-Web-Registration-Theme /etc/prosody/register-templates/Prosody-Web-Registration-Theme

# Email password reset module
git clone https://github.com/lunarthegrey/mod_email_pass_reset_english /etc/prosody/modules/git-modules/mod_email_pass_reset_english

# Official Prosody modules
hg clone https://hg.prosody.im/prosody-modules/ /etc/prosody/modules/prosody-modules

echo

echo "rsyncing configs"

echo

# Prosody config
rsync -av /home/git/xmpp.is/prosody/ /etc/prosody/

# Hiawatha config
rsync -av /home/git/xmpp.is/hiawatha/ /etc/hiawatha/

# Tor config
rsync -av /home/git/xmpp.is/tor/ /etc/tor/

# Web directories
rsync -av /home/git/xmpp.is/www/ /var/www/

echo

echo "Issuing initial SSL/TLS certificates"
service hiawatha stop
# certbot certonly --standalone --rsa-key-size 2048 -d test.xmpp.is
certbot certonly --standalone --rsa-key-size 4096 -d xmpp.is -d www.xmpp.is -d http.xmpp.is -d upload.xmpp.is
certbot certonly --standalone --rsa-key-size 4096 -d xmpp.co -d www.xmpp.co -d http.xmpp.co -d upload.xmpp.co
certbot certonly --standalone --rsa-key-size 4096 -d xmpp.cx -d www.xmpp.is -d http.xmpp.cx -d upload.xmpp.cx
certbot certonly --standalone --rsa-key-size 4096 -d xmpp.xyz -d www.xmpp.xyz -d http.xmpp.xyz -d upload.xmpp.xyz

echo

echo "Applying open file limits"
echo "prosody hard nofile 999999" | tee -a /etc/security/limits.conf
echo "prosody soft nofile 999999" | tee -a /etc/security/limits.conf
echo "DefaultLimitNOFILE=999999" | tee -a /etc/systemd/system.conf
echo "MAXFDS=999999" | tee -a /etc/default/prosody

echo

echo "Setting up TCP BBR"
echo "net.core.default_qdisc=fq" | tee -a /etc/sysctl.conf
echo "net.ipv4.tcp_congestion_control=bbr" | tee -a /etc/sysctl.conf

echo

echo "Executing final scripts"
bash /home/git/xmpp.is/scripts/letsencrypt-to-hiawatha.sh
bash /home/git/xmpp.is/scripts/letsencrypt-to-prosody.sh
bash /home/git/xmpp.is/scripts/force-owner-and-group.sh
crontab /home/git/xmpp.is/system/crontab

echo

echo "Restarting services"
service prosody restart
service hiawatha start
service tor restart

echo

echo "Deploy finished, server must be rebooted now"
