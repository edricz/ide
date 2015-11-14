#!/bin/bash -e

# This script will download, compile, and install Emacs.
# The emacs version number is specified by $version variable.
# Once emacs is installed, it's customized with plugins, scripts, and fonts.
#
# Usage:   setup-emacs.sh <user>
# Example: setup-emacs.sh ezhu

user=$1
version=24.5

# find where fonts/scripts are located
dir=$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )
if [ ! -d ${dir}/emacs/fonts -o ! -d ${dir}/emacs/lisp ] ; then
    dir="/tmp"
fi
if [ ! -d ${dir}/emacs/fonts -o ! -d ${dir}/emacs/lisp ] ; then
    echo "Cannot locate fonts and lisp directories."
    exit 1
fi

# pre-seed the install to automate postfix package installation
debconf-set-selections <<EOF
postfix postfix/mailname string localhost
EOF
debconf-set-selections <<EOF
postfix postfix/main_mailer_type string 'No configuration'
EOF

# install emacs24 build dependencies
apt-get build-dep -y emacs24

# install emacs from source, since no PPA is available
curl -SL http://ftp.gnu.org/gnu/emacs/emacs-${version}.tar.gz -o /tmp/emacs.tgz
tar -xz -C /tmp -f /tmp/emacs.tgz
cd /tmp/emacs* && ./configure && make
make install

# move font files to the correct location
mkdir -p /usr/share/fonts/truetype/ubuntu-font-family
cp ${dir}/emacs/fonts/*.ttf /usr/share/fonts/truetype/ubuntu-font-family

# move emacs configuration files to user's home directory
cp ${dir}/emacs/lisp/emacs.el /home/${user}/.emacs
mkdir -p /home/${user}/.emacs.d
cp -a ${dir}/emacs/lisp /home/${user}/.emacs.d
chown -R ${user}:${user} /home/${user}/.emacs
chown -R ${user}:${user} /home/${user}/.emacs.d

# run emacs configuration script
su ${user} -c "emacs --batch --script ${dir}/emacs/lisp/emacs-setup.el"

# install spell checker
apt-get install -y hunspell

# install python support
apt-get install -y python-pip
pip install jedi epc pylint

# cleanup
cd /tmp
rm -rf /tmp/emacs*

echo Okay!
