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

apt-get install -y wget software-properties-common nano curl \
build-essential dos2unix gcc git git-flow apt-utils \
make python2.7-dev python-pip re2c supervisor unattended-upgrades whois vim zip unzip \
apt-transport-https lsb-release ca-certificates lsof apt-utils



                  # Create admin user

sudo adduser admin

sudo usermod -p $(echo pas | openssl passwd -1 -stdin) admin

sudo usermod -a -G sudo admin

sudo usermod -a -G www-data admin 

sudo echo 'admin ALL=NOPASSWD: ALL' >> /etc/sudoers

sudo echo 'root ALL=NOPASSWD: ALL' >> /etc/sudoers


# Install admin tools
sudo apt update
sudo apt install net-tools

# Install Composer
curl -sS https://getcomposer.org/installer | php
mv composer.phar /usr/local/bin/composer

# Add Composer Global Bin To Path
printf "\nPATH=\"/home/admin/.composer/vendor/bin:\$PATH\"\n"

# Install Node
git clone https://github.com/tj/n.git /n
cd /n
make install
n stable
npm install -g gulp
npm install -g bower
cd /var/www/html
