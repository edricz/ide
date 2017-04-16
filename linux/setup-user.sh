#!/bin/bash -e

# This script will configure a given user to have sudo access without password.
# it can also optionally install RSA and GPG keys, if they are present in /tmp.
#
# Usage:   setup-user.sh <user>
# Example: setup-user.sh ezhu

user=$1

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
echo 'export LS_COLORS="di=01;37"' >> /home/${user}/.bashrc

# Add git config
if [ $(domainname) == '(none)' ]; then
    email="${user}@$(hostname).local"
else
    email="${user}@$(hostname).$(domainname)"
fi
su ${user} -c "git config --global push.default simple"
su ${user} -c "git config --global user.email ${email}"
su ${user} -c "git config --global user.name ${user}"

# move over RSA private key
if [ -f /tmp/key.rsa ] ; then
    mkdir -p /home/${user}/.ssh
    mv /tmp/key.rsa /home/${user}/.ssh/id_rsa
    chown -R ${user}:${user} /home/${user}/.ssh
    chmod 0400 /home/${user}/.ssh/id_rsa
fi

# install pgp key
if [ -f /tmp/key.pgp ] ; then

    cat > /tmp/install-pgp.sh <<EOF
gpg --allow-secret-key-import --import /tmp/key.pgp
echo \$(gpg --list-keys --with-fingerprint --with-colons |tail -2 |head -1 |tr -s ":" ":"|cut -d ":" -f2):4: > /tmp/trustkey.fp
gpg --import-ownertrust < /tmp/trustkey.fp
rm /tmp/trustkey.fp
EOF

    # install GNU OpenPGP
    apt-get install -y gnupg-agent

    # install user specified PGP private/public key pair
    su ${user} -c "/bin/sh -e /tmp/install-pgp.sh"
    rm /tmp/key.pgp
    rm /tmp/install-pgp.sh

fi

echo
echo '###############################'
echo '# User Environment Configured #'
echo '###############################'
echo
