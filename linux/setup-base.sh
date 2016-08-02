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

apt-get update
apt-get install -y curl git python python-pip python3 python3-pip build-essential zlib1g-dev libbz2-dev liblzma-dev libssl-dev libsqlite3-dev ca-certificates google-chrome-stable

pip install --upgrade pip
pip3 install --upgrade pip

su ${user} -c "git config --global push.default simple"


echo Okay!
