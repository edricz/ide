#!/bin/bash -e

# This script will download, compile, and install Emacs.
# The emacs version number is specified by $version variable.
# Once emacs is installed, it's customized with plugins, scripts, and fonts.
#
# Usage:   setup-emacs.sh <user>
# Example: setup-emacs.sh ezhu

user=$1
readonly version="24.5"

# find where fonts/scripts are located
dir=$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )
if [ ! -d ${dir}/emacs/fonts -o ! -d ${dir}/emacs/lisp ] ; then
    dir="/tmp"
fi
if [ ! -d ${dir}/emacs/fonts -o ! -d ${dir}/emacs/lisp ] ; then
    echo "Cannot locate fonts and lisp directories."
    exit 1
fi

# install dependencies
sudo apt-get -qq update
sudo apt-get -qq install -y stow build-essential libx11-dev xaw3dg-dev \
     libjpeg-dev libpng12-dev libgif-dev libtiff5-dev libncurses5-dev \
     libxft-dev librsvg2-dev libmagickcore-dev libmagick++-dev \
     libxml2-dev libgpm-dev libotf-dev libm17n-dev \
     libgnutls-dev wget stow

# download source package
if [[ ! -d emacs-"$version" ]]; then
   wget http://ftp.gnu.org/gnu/emacs/emacs-"$version".tar.xz
   tar xvf emacs-"$version".tar.xz
fi

# build and install
sudo mkdir -p /usr/local/stow
cd emacs-"$version"
./configure \
    --with-xft \
    --with-x-toolkit=lucid
make
sudo make \
    install-arch-dep \
    install-arch-indep \
    prefix=/usr/local/stow/emacs-"$version"

# management package with stow
cd /usr/local/stow
stow emacs-"$version"

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
cd $dir
rm -rf emacs-${version}*

echo Okay!
