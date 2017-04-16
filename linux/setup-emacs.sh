#!/bin/bash -e

# This script will install and customize emacs with plugins and scripts
#
# Usage:   setup-emacs.sh <user>
# Example: setup-emacs.sh ezhu

user=$1

# install emacs24.5
apt install -y emacs

# find where lisp scripts are located
dir=$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )
if [ ! -d ${dir}/emacs/lisp ] ; then
    dir="/tmp"
fi
if [ ! -d ${dir}/emacs/lisp ] ; then
    echo "Cannot locate lisp directories."
    exit 1
fi

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
pip install jedi epc pylint


echo
echo '###################'
echo '# Emacs Installed #'
echo '###################'
echo
