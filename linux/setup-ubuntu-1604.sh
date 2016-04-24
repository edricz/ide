#!/bin/bash -ex

user=$1

#
# Install base packages
#

# install Google PPA key and add Chrome repo
wget -q -O - https://dl-ssl.google.com/linux/linux_signing_key.pub | apt-key add -
if ! grep 'http://dl.google.com/linux/chrome/deb/' /etc/apt/sources.list.d/google-chrome.list; then
    sudo sh -c 'echo "deb http://dl.google.com/linux/chrome/deb/ stable main" >> /etc/apt/sources.list.d/google-chrome.list'
fi

apt-get update
apt-get install -y \
        curl git build-essential zlib1g-dev libbz2-dev liblzma-dev libssl-dev libsqlite3-dev ca-certificates \
        google-chrome-stable emacs24 python3 python3-dev python3-pip

#
# Setup sudo
#

# disable password for sudoers
sudo sed 's/%sudo.*ALL=(ALL:ALL) ALL/%sudo ALL=(ALL:ALL) NOPASSWD:ALL/' /etc/sudoers > /tmp/sudoers
sudo chown root:root /tmp/sudoers
sudo chmod 0440 /tmp/sudoers
sudo mv /tmp/sudoers /etc/sudoers

# add user
if id $user &> /dev/null ; then
    passwd $user -d
else
    adduser --disabled-password --gecos "" ${user}
fi
adduser ${user} sudo

# change ls color for directory to WHITE
grep -q -F 'export LS_COLORS="di=01;37"' /home/${user}/.bashrc || echo 'export LS_COLORS="di=01;37"' >> /home/${user}/.bashrc

# Add git config
if [ $(domainname) == '(none)' ]; then
    email="${user}@$(hostname).local"
else
    email="${user}@$(hostname).$(domainname)"
fi
su ${user} -c "git config --global push.default simple"
su ${user} -c "git config --global user.email ${email}"
su ${user} -c "git config --global user.name ${user}"

#
# Setup emacs
#

# find where fonts/scripts are located
dir=$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )
if [ ! -d ${dir}/emacs/fonts -o ! -d ${dir}/emacs/lisp ] ; then
    dir="/tmp"
fi
if [ ! -d ${dir}/emacs/fonts -o ! -d ${dir}/emacs/lisp ] ; then
    echo "Cannot locate fonts and lisp directories."
    exit 1
fi

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

# install python virtualenv
apt-get install -y python-pip
pip install virtualenvwrapper 

read -r -d '' cmds <<EOF || true
if [ x\$WORKON_HOME == x ]; then
    export WORKON_HOME=~/envs
    source /usr/local/bin/virtualenvwrapper.sh
fi
EOF

grep -q -F "if [ x\$WORKON_HOME == x ]; then" /home/${user}/.bashrc || echo "$cmds" >> /home/${user}/.bashrc

# enable Emacs elpy support
read -r -d '' cmds <<EOF || true
export WORKON_HOME=/home/${user}/envs
mkdir -p /home/${user}/envs
source /usr/local/bin/virtualenvwrapper.sh
mkvirtualenv -p $(which python3.5) emacs
pip install jedi epc flake8 rope importmagic autopep8 yapf
EOF
su ${user} -c "$cmds"

# cleanup
cd /tmp
rm -rf /tmp/emacs*
cd $dir
rm -rf emacs-${version}*
