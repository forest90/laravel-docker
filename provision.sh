#!/usr/bin/env bash

# Update Package List
apt-get update
apt-get upgrade -y

chown -R 1000:1000 /var/www/html

echo "
alias ll='ls -alF'
alias la='ls -A'
alias l='ls -CF'
" >> /etc/bash.bashrc

ln -sf /usr/share/zoneinfo/Poland /etc/localtime

# Basic packages
echo "N" | apt-get install -y sudo

apt-get install -y wget nano curl \
git apt-utils zip unzip python-pip make python2.7-dev \
apt-transport-https lsof apt-utils sass

#git-flow re2c supervisor unattended-upgrades whois vim lsb-release ca-certificates
#software-properties-common build-essential dos2unix gcc 

                  # Create admin user

sudo adduser admin

sudo usermod -p $(echo pas | openssl passwd -1 -stdin) admin

sudo usermod -a -G sudo admin

sudo usermod -a -G www-data admin 

sudo echo 'admin ALL=NOPASSWD: ALL' >> /etc/sudoers

sudo echo 'root ALL=NOPASSWD: ALL' >> /etc/sudoers


# Install admin tools
sudo apt update
sudo apt install net-tools iputils-ping procps

# Install Composer
curl -sS https://getcomposer.org/installer | php
mv composer.phar /usr/local/bin/composer

# Add Composer Global Bin To Path
printf "\nPATH=\"/home/admin/.composer/vendor/bin:\$PATH\"\n"

# Install Node
git clone https://github.com/tj/n.git /n
make -C /n install
n 7 # node-sass (npm install) will not work with higher version of node
npm i -g npm@6 # this version is required for proper work of gulp
npm install -g gulp
npm install -g bower
