#!/usr/bin/env bash

set -ue

# Log everything
exec > >(tee setup.log)
exec 2>&1

# Read configuration variables
source _config.sh

# Set locale
locale-gen en_US en_US.UTF-8
dpkg-reconfigure locales

# Fetch packages source
apt-get -y update

# Upgrade currently installed packages
apt-get -y upgrade

# Install required packages
apt-get install -y build-essential git libssl-dev libcurl4-openssl-dev $EXTRA_PACKAGES

# Setup basic security
source _safety.sh

# Setup PostgreSQL and Redis
source _database.sh

# Setup Git, Ruby and Rails
source _application.sh

echo
echo "=> Done!"