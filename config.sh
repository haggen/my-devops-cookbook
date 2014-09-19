#!/usr/bin/env bash

[[ "$0" == "config.sh" ]] && echo "This script cannot be called directly, use `setup.sh`" && exit 1

# Which password would you like to use for `root` user ?
ROOT_PASSWORD=$(cat /dev/urandom | tr -dc A-Za-z0-9 | head -c 32)

# What username would you like to use ?
YOUR_USERNAME=""

# And what password would you like to use ?
YOUR_PASSWORD=$(cat /dev/urandom | tr -dc A-Za-z0-9 | head -c 32)

# What's the home directory for this user ?
HOME=/home/$YOUR_USERNAME

# What public key should be authorized for remote access ?
YOUR_PUBLIC_KEY=<<TEXT
TEXT

# What ports should be allowed in the firewall ?
PORTS="22 80 443"

# Let's give a nice and familiar name to this server.
HOSTNAME=$(shuf -n 1 hostnames.txt)

# What extra packages should be installed ?
EXTRA_PACKAGES=""

# What version of Ruby should be installed ?
RUBY_VERSION=2.1.2

# What directory should be used for application ?
APPLICATION_DIR=$HOME/app

# What directory should be used for the bare repository ?
REPOSITORY_DIR=$HOME/git

# -

echo
echo "Root password:"
echo "=> $ROOT_PASSWORD"
echo
echo "Your user information:"
echo "=> $YOUR_USERNAME@$HOSTNAME"
echo "=> $YOUR_PASSWORD"
echo
echo "Application repository:"
echo "=> $YOUR_USERNAME@$(curl -s icanhazip.com):git"
echo
echo "Database:"
echo "=> postgres://..."
echo

read -p "Take note of the information above and press [return] to continue..."

exit 1