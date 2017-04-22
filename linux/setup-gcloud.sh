#!/bin/bash -e

# This script will install and configure Google cloud SDK
#
# Usage:   setup-gcloud.sh <user>
# Example: setup-gcloud.sh ezhu

user=$1

export CLOUD_SDK_REPO="cloud-sdk-$(lsb_release -c -s)"
echo "deb https://packages.cloud.google.com/apt $CLOUD_SDK_REPO main" | tee -a /etc/apt/sources.list.d/google-cloud-sdk.list
curl https://packages.cloud.google.com/apt/doc/apt-key.gpg | apt-key add -
apt update
apt install -y google-cloud-sdk kubectl google-cloud-sdk-app-engine-python
