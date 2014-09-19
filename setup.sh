#!/usr/bin/env bash

set -ue

# Read configuration variables
source config.sh

# Set locale
locale-gen en_US en_US.UTF-8
dpkg-reconfigure locales

# Fetch packages source
apt-get update

# Upgrade currently installed packages
apt-get -y upgrade

# Install required packages
apt-get install -y build-essential git $EXTRA_PACKAGES

# Setup basic security
source safety.sh

# Setup PostgreSQL and Redis
source database.sh

# Setup Git, Ruby and Rails
source application.sh

