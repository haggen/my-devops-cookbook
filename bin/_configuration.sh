#!/usr/bin/env bash

# Current external IP address
IP=$(curl -s icanhazip.com)

# Which password would you like to use for `root` user ?
ROOT_PASSWORD=$(cat /dev/urandom | tr -dc A-Za-z0-9 | head -c 64)

# What username would you like to use ?
USERNAME="app"

# And what password would you like to use ?
PASSWORD=$(cat /dev/urandom | tr -dc A-Za-z0-9 | head -c 64)

# What's the home directory for this user ?
HOME=/home/$USERNAME

# Your RSA public key will be asked.
read -p "Paste your public key:" PUBLIC_KEY

# What ports should be allowed in the firewall ?
PORTS="22 80 443"

# Let's give a nice and familiar name to this server.
HOSTNAME=$(shuf -n 1 ../txt/hostnames.txt)

# What packages should be installed ?
PACKAGES="build-essential git nodejs npm libssl-dev libcurl4-openssl-dev libreadline-dev"

# What version of Ruby should be installed ?
RUBY_VERSION=2.1.2

# What Gems should be installed ?
GEMS="bundler rails foreman passenger"

# What directory should be used for application ?
APPLICATION_PATH=$HOME/app

# What directory should be used for the bare repository ?
REPOSITORY_PATH=$HOME/git

# What directory should be used for the application processes logs ?
LOG_PATH=$HOME/log

# ...
TMP_PATH=$HOME/tmp

# -

echo
echo "Hostname:"
echo "=> @$HOSTNAME"
echo
echo "Root password:"
echo "=> $ROOT_PASSWORD"
echo
echo "Your user information:"
echo "=> $USERNAME"
echo "=> $PASSWORD"
echo
echo "Database:"
echo "=> postgres://app@localhost/app_production"
echo
echo "Application repository:"
echo "=> $USERNAME@$IP:git"
echo

read -p "Take note of the information above and press [enter] to continue..."
