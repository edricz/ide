#!/bin/bash -e

# This script will install vmware tools and configure vmhgfs
#
# Usage:   setup-vmware.sh <user>
# Example: setup-vmware.sh ezhu

user=$1

# find where config scripts are located
dir=$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )
if [ ! -f ${dir}/vmware/hgfs ] ; then
    dir="/tmp"
fi
if [ ! -f ${dir}/vmware/hgfs ] ; then
    echo "Cannot locate hgfs config file."
    exit 1
fi

# install vmware tools
apt install -y open-vm-tools-desktop

su ${user} -c "mkdir -p /home/${user}/hgfs"

sed -i 's|#user_allow_other|user_allow_other|' /etc/fuse.conf

# configure vmhgfs
cp ${dir}/vmware/hgfs /etc/init.d/hgfs
chown root:root /etc/init.d/hgfs
chmod a+x /etc/init.d/hgfs
sed -i "s/__USER__/${user}/" /etc/init.d/hgfs
update-rc.d hgfs defaults
service hgfs start


echo
echo '##########################'
echo '# VMWare Tools Installed #'
echo '##########################'
echo
