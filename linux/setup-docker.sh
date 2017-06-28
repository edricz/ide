#!/bin/bash -e

# This script will download and install Docker.
# It also grants Docker access to the specified non-root user.
#
# Usage:   setup-docker.sh <user>
# Example: setup-docker.sh ezhu

user=$1

# install docker
apt install -yqq \
    apt-transport-https \
    ca-certificates \
    curl \
    software-properties-common

curl -fsSL https://download.docker.com/linux/ubuntu/gpg | apt-key add -

add-apt-repository \
   "deb [arch=amd64] https://download.docker.com/linux/ubuntu \
   $(lsb_release -cs) \
   stable"

add-apt-repository \
   "deb [arch=amd64] https://download.docker.com/linux/ubuntu \
   $(lsb_release -cs) \
   edge"

apt update

apt install -yqq docker-ce

# grant docker access to user
gpasswd -a $user docker

echo
echo '####################'
echo '# Docker Installed #'
echo '####################'
echo
