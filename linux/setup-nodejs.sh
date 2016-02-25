#!/bin/bash -e

# This script will install nodejs and npm
#
# Usage:   setup-nodejs.sh

# install ppa for nodejs 5.x
curl -sL https://deb.nodesource.com/setup_5.x | sudo -E bash -

# nodejs package contains npm
apt-get install -y nodejs build-essential

if [ ! -f /usr/bin/node ]; then
    ln -s /usr/bin/nodejs /usr/bin/node
fi
