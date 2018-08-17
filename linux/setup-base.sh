#!/bin/bash -e

# This script will install base package required by other installation scripts.
#
# Usage:   setup-base.sh <user>
# Example: setup-base.sh ezhu

user=$1

# install Google PPA key and add Chrome repo
wget -q -O - https://dl-ssl.google.com/linux/linux_signing_key.pub | apt-key add -
touch /etc/apt/sources.list.d/google-chrome.list
if ! grep 'http://dl.google.com/linux/chrome/deb/' /etc/apt/sources.list.d/google-chrome.list; then
    sudo sh -c 'echo "deb http://dl.google.com/linux/chrome/deb/ stable main" >> /etc/apt/sources.list.d/google-chrome.list'
fi

apt update
apt -y upgrade

# install base packages
apt install -y curl vim git python-pip python3-pip
pip install --upgrade pip
pip3 install --upgrade pip

# install extra packages
apt install -y google-chrome-stable

echo
echo '###########################'
echo '# Base Packages Installed #'
echo '###########################'
echo
