#!/bin/sh -e

# This script will download and install Docker.
# It also grants Docker access to the specified non-root user.
#
# Usage:   setup-docker.sh <user>
# Example: setup-docker.sh ezhu

user=$1

[ -e /usr/lib/apt/methods/https ] || { sudo apt-get update; sudo apt-get install apt-transport-https; }
apt-key adv --keyserver hkp://keyserver.ubuntu.com:80 --recv-keys 36A1D7869245C8950F966E92D8576A8BA88D21E9
echo deb https://get.docker.io/ubuntu docker main > /etc/apt/sources.list.d/docker.list
apt-get update && apt-get install -y --force-yes apparmor lxc-docker

gpasswd -a $user docker

#pip install docker-compose
