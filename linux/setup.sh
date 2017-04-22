#!/bin/bash -e

# This is the base setup script to configure a clean Kubuntu 16.04 install.
#
# Usage:   setup.sh <user>
# Example: setup.sh ezhu

user=$1
if [ -z "$user" ]; then echo "Usage: setup.sh <user>"; exit 1; fi
if [ $(id -u) != 0 ]; then echo "Must run as root!"; exit 1; fi

dir=$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )

$dir/setup-base.sh $user
$dir/setup-user.sh $user
$dir/setup-emacs.sh $user
$dir/setup-vnc.sh $user
$dir/setup-docker.sh $user
$dir/setup-gcloud.sh $user
