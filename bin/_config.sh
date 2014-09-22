#!/usr/bin/env bash

# Current external IP address
IP_ADDRESS=$(curl -s icanhazip.com)

# Current working directory
CWD=$(dirname $0)

# Which password would you like to use for `root` user ?
ROOT_PASSWORD=$(cat /dev/urandom | tr -dc A-Za-z0-9 | head -c 64)

# What username would you like to use ?
YOUR_USERNAME="app"

# And what password would you like to use ?
YOUR_PASSWORD=$(cat /dev/urandom | tr -dc A-Za-z0-9 | head -c 64)

# What's the home directory for this user ?
HOME=/home/$YOUR_USERNAME

# Ask for user's public key.
read -p "Paste your public key:" PUBLIC_KEY

# What ports should be allowed in the firewall ?
PORTS="22 80 443"

# Let's give a nice and familiar name to this server.
HOSTNAME=$(shuf -n 1 $CWD/txt/hostnames.txt)

# What extra packages should be installed ?
EXTRA_PACKAGES=""

# What version of Ruby should be installed ?
RUBY_VERSION=2.1.2

# What directory should be used for application ?
APP_DIR=$HOME/app

# What directory should be used for the bare repository ?
BARE_DIR=$HOME/git

# What directory should be used for the application processes logs ?
LOG_DIR=$HOME/log

# ...
TMP_DIR=$HOME/tmp

# -

echo
echo "Hostname:"
echo "=> @$HOSTNAME"
echo
echo "Root password:"
echo "=> $ROOT_PASSWORD"
echo
echo "Your user information:"
echo "=> $YOUR_USERNAME"
echo "=> $YOUR_PASSWORD"
echo
echo "Database URI:"
echo "=> postgres://app@localhost/app_production"
echo
echo "Application repository:"
echo "=> $YOUR_USERNAME@$IP_ADDRESS:git"
echo
echo "Application directory:"
echo "=> $HOME/$APP_DIR"
echo
echo "Ports allowed:"
echo "=> $PORTS"
echo

read -p "Take note of the information above and press [enter] to continue..."
