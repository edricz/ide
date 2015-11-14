#!/bin/bash -e

# This script will install base package required by other installation scripts.
#
# Usage:   setup-base.sh <user>
# Example: setup-base.sh ezhu

user=$1

# install Google PPA key and add Chrome repo
wget -q -O - https://dl-ssl.google.com/linux/linux_signing_key.pub | apt-key add -
if ! grep 'http://dl.google.com/linux/chrome/deb/' /etc/apt/sources.list.d/google-chrome.list; then
    sudo sh -c 'echo "deb http://dl.google.com/linux/chrome/deb/ stable main" >> /etc/apt/sources.list.d/google-chrome.list'
fi

# use git-core PPA to get latest version of git
add-apt-repository -y ppa:git-core/ppa

apt-get update
apt-get install -y curl git build-essential google-chrome-stable

su ${user} -c "git config --global push.default simple"

# upgrade python3
PYTHON_VERSION=3.5.0
curl -sSL -o /tmp/python3.tgz https://www.python.org/ftp/python/${PYTHON_VERSION}/Python-${PYTHON_VERSION}.tgz
mkdir -p /tmp/python3
tar -xz -C /tmp/python3 -f /tmp/python3.tgz --strip-components=1
cd /tmp/python3
./configure --enable-shared --prefix=/usr && make && make altinstall
cd /tmp
rm -rf python3*

echo Okay!
