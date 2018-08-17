#!/bin/bash -e

# This script will download and install VNC Server.
# It also install the lightweight window manager lxde.
#
# Usage:   setup-vnc.sh <user>
# Example: setup-vnc.sh ezhu

vnc_user=$1
vnc_passwd=${2:-5ab2cdc0badcaf13} # default to empty password
# Command to generate VNC password:
# vnc_passwd=$(echo "HackersRUs" | vncpasswd -p Password /tmp/secret &> /dev/null && cat /tmp/secret |awk -F= '{print $2}')

# find where config scripts are located
dir=$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )
if [ ! -f ${dir}/vnc/vncserver ] ; then
    dir="/tmp"
fi
if [ ! -f ${dir}/vnc/vncserver ] ; then
    echo "Cannot locate vncserver config file."
    exit 1
fi

# Based on article at https://www.realvnc.com/products/vnc/deployment/script/

# quit if already installed
#if [ -x /usr/bin/vncserver ]; then
#    exit 0
#fi

############# Download VNC #############
# Download and unpack the latest VNC on a 64-bit Debian-compatible system:
curl -L -o /tmp/vnc.tgz https://www.realvnc.com/download/file/vnc.files/VNC-5.2.3-Linux-x64-DEB.tar.gz
tar -xz -C /tmp -f /tmp/vnc.tgz
rm /tmp/vnc.tgz

############# Install VNC Server #############
# Install VNC Server on a Debian-compatible system
apt-get install -y libxtst6
dpkg -i /tmp/VNC-Server*.deb
rm /tmp/VNC*.deb

############# License VNC Server #############
# Mandatory. More information:
# man vnclicense
# Apply a free license
vnclicense -add F2HNH-RB34G-KP5RB-NBSVB-TJD9A

############# Setup X11 Windows Environment #############
# Mandatory for a headless system without X11. Recommended for Ubuntu 13.04+ and Fedora 19+. 
# More information: https://support.realvnc.com/Knowledgebase/Article/View/345/
# Install a desktop environment suitable for virtualization (for example, LXDE) on Ubuntu 13.04+:
# x11-xserver-utils required for xrandr
apt-get install -y --no-install-recommends lxde x11-xserver-utils xauth
# Use LXDE instead of the console desktop environment (if any) for all virtual desktops:
echo -e '#!/bin/sh\nDESKTOP_SESSION=LXDE\nexport DESKTOP_SESSION\nstartlxde\nvncserver-virtual -kill $DISPLAY' | sudo tee /etc/vnc/xstartup.custom
chmod +x /etc/vnc/xstartup.custom

# copy over custom shortcuts
mkdir -p /home/${vnc_user}/.config/openbox
cp ${dir}/vnc/lxde-rc.xml /home/${vnc_user}/.config/openbox/lxde-rc.xml

############# Run VNC in User Mode #############
cp ${dir}/vnc/vncserver /etc/init.d/vncserver
chown root:root /etc/init.d/vncserver
chmod a+x /etc/init.d/vncserver
sed -i "s/__USER__/${vnc_user}/" /etc/init.d/vncserver
sed -i "s/__PASSWORD__/${vnc_passwd}/" /etc/init.d/vncserver
update-rc.d vncserver defaults
service vncserver start


echo
echo '########################'
echo '# VNC Server Installed #'
echo '########################'
echo
