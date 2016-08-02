#!/bin/sh -e

# This script will download and install Docker.
# It also grants Docker access to the specified non-root user.
#
# Usage:   setup-docker.sh <user>
# Example: setup-docker.sh ezhu

user=$1

apt-get update
apt-get install -y apt-transport-https ca-certificates

apt-key adv --keyserver hkp://p80.pool.sks-keyservers.net:80 --recv-keys 58118E89F3A912897C070ADBF76221572C52609D
touch /etc/apt/sources.list.d/docker.list
if ! grep 'https://apt.dockerproject.org/repo' /etc/apt/sources.list.d/docker.list; then
    sudo sh -c 'echo "deb https://apt.dockerproject.org/repo ubuntu-xenial main" >> /etc/apt/sources.list.d/docker.list'
fi

apt-get update
apt-get install -y docker-engine

gpasswd -a $user docker

pip install docker-compose
