#!/bin/sh

# Deploys XMPP.is on a new server

echo

echo "Adding the official Prosody repository"
echo deb http://packages.prosody.im/debian $(lsb_release -sc) main | tee -a /etc/apt/sources.list
wget https://prosody.im/files/prosody-debian-packages.key -O- | apt-key add -

echo

echo "Adding the official Tor repository"
echo deb http://deb.torproject.org/torproject.org $(lsb_release -sc) main | tee -a /etc/apt/sources.list
gpg --keyserver keys.gnupg.net --recv A3C4F0F979CAA22CDBA8F512EE8CBC9E886DDD89
gpg --export A3C4F0F979CAA22CDBA8F512EE8CBC9E886DDD89 | apt-key add -

echo

echo "Adding Hiawatha repository"
echo deb http://mirror.tuxhelp.org/debian/ squeeze main | tee -a /etc/apt/sources.list
apt-key adv --recv-keys --keyserver keys.gnupg.net 79AF54A9

echo

echo "Running apt update"
apt update

echo

echo "Installing tools I like :)"
apt install -y htop dstat nload iftop nmap iotop haveged rsync

echo

echo "Installing Prosody"
apt install -y prosody lua-zlib lua-bitop

echo

echo "Installing Tor"
apt install -y tor deb.torproject.org-keyring

echo

echo "Installing Hiawatha"
apt install -y hiawatha

echo

echo "Installing certbot"
apt install -y certbot

echo

echo "Installing dependencies for config & module pulling"
apt install -y git mercurial

echo

echo "Setting up Prosody directories"
mkdir /etc/prosody/certs

echo

echo "Pulling configs and modules"

# Prosody configs & scripts
git clone https://github.com/lunarthegrey/xmpp.is /home/git/xmpp.is

# Prosody web registration theme
git clone https://github.com/lunarthegrey/Prosody-Web-Registration-Theme /etc/prosody/register-templates/Prosody-Web-Registration-Theme

# Email password reset module
git clone https://github.com/lunarthegrey/mod_email_pass_reset /etc/prosody/modules/git-modules/mod_email_pass_reset

# Official Prosody modules
hg clone https://hg.prosody.im/prosody-modules/ /etc/prosody/modules/prosody-modules

echo

echo "rsyncing configs"

# Prosody config
rsync -av /home/git/xmpp.is/prosody/ /etc/prosody/

# Hiawatha config
rsync -av /home/git/xmpp.is/hiawatha/ /etc/hiawatha/

# Tor config
rsync -av /home/git/xmpp.is/tor/ /etc/tor/

echo

echo "Issuing initial SSL/TLS certificates"
service hiawatha stop
# certbot certonly --standalone --rsa-key-size 2048 -d test.xmpp.is
certbot certonly --standalone --rsa-key-size 4096 -d xmpp.is -d www.xmpp.is -d http.xmpp.is -d upload.xmpp.is
certbot certonly --standalone --rsa-key-size 4096 -d xmpp.co -d www.xmpp.co -d http.xmpp.co -d upload.xmpp.co
certbot certonly --standalone --rsa-key-size 4096 -d xmpp.cx -d www.xmpp.is -d http.xmpp.cx -d upload.xmpp.cx
certbot certonly --standalone --rsa-key-size 4096 -d xmpp.xyz -d www.xmpp.xyz -d http.xmpp.xyz -d upload.xmpp.xyz

echo

echo "Executing final scripts"
bash /home/git/xmpp.is/scripts/letsencrypt-to-hiawatha.sh
bash /home/git/xmpp.is/scripts/letsencrypt-to-prosody.sh
bash /home/git/xmpp.is/scripts/force-owner-and-group.sh

echo

echo "Restarting services"
service prosody restart
service hiawatha start
service tor restart
