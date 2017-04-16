#!/bin/bash -e

# This script will download and install Docker.
# It also grants Docker access to the specified non-root user.
#
# Usage:   setup-docker.sh <user>
# Example: setup-docker.sh ezhu

user=$1

# install docker
apt install -y docker.io

# grant docker access to user
gpasswd -a $user docker

echo
echo '####################'
echo '# Docker Installed #'
echo '####################'
echo
