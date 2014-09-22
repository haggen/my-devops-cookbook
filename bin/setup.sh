#!/usr/bin/env bash

set -ue

# Go to where the scripts are
cd $(dirname $0)

# Log everything
exec > >(tee setup.log)
exec 2>&1

# Require
source _configuration.sh

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
source _security.sh

# Setup PostgreSQL and Redis
source _database.sh

# Setup Git, Ruby and Rails
source _application.sh

echo
echo "=> Done!"