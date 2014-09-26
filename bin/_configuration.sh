#!/usr/bin/env bash

# Get public address
IP=$(curl -s icanhazip.com)

# Let's give a nice and familiar name to this server.
HOSTNAME=$(shuf -n 1 ../txt/hostnames.txt)

# Which password would you like to use for `root` user ?
ROOT_PASSWORD=$(cat /dev/urandom | tr -dc A-Za-z0-9 | head -c 64)

# What username would you like to use ?
USERNAME="app"

# And what password would you like to use ?
PASSWORD=$(cat /dev/urandom | tr -dc A-Za-z0-9 | head -c 64)

# What's the home directory for this user ?
HOME=/home/$USERNAME

# What packages should be installed ?
PACKAGES="build-essential git nodejs npm libssl-dev libcurl4-openssl-dev libreadline-dev newrelic-sysmond htop"

# What version of Ruby should be installed ?
RUBY_VERSION=2.1.2

# What Gems should be installed ?
GEMS="bundler rails foreman passenger"

# What port should the application use ?
APPLICATION_PORT=3000

# What ports should be allowed in the firewall ?
ALLOWED_PORTS="22 80 $APPLICATION_PORT"

# What directory should be used for application ?
APPLICATION_PATH=$HOME/app

# What directory should be used for the bare repository ?
REPOSITORY_PATH=$HOME/git

# What directory should be stored log and pid files ?
VAR_PATH=$HOME/var

# Provide a secret key base for Rails:
SECRET_KEY_BASE=$(cat /dev/urandom | tr -dc A-Za-z0-9 | head -c 128)


# -

# Ask for your public key:
echo
echo "Paste your public key:"
read -e -s -p '=> ' PUBLIC_KEY
echo

# Ask for New Relic license key:
echo
echo "Paste your New Relic license key:"
read -e -s -p '=> ' NEW_RELIC_LICENSE
echo

# -

echo
echo "Hostname:"
echo "=> $IP $HOSTNAME"
echo
echo "Root password:"
echo "=> $ROOT_PASSWORD"
echo
echo "Your password:"
echo "=> $PASSWORD"
echo
echo "Application repository:"
echo "=> $USERNAME@$IP:git"
echo

read -p "press [enter] to continue..."
