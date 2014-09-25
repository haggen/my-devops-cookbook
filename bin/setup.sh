#!/usr/bin/env bash

set -ue

# Log and time everything
exec > >(tee setup.log)
exec 2>&1

TIME=$(date +%s)

# Go to where the scripts are
chdir $(dirname $0)

# Require
source _configuration.sh

# Set locale
locale-gen en_US en_US.UTF-8
dpkg-reconfigure locales

# Configure New Relic packages source
echo deb http://apt.newrelic.com/debian/ newrelic non-free >> /etc/apt/sources.list.d/newrelic.list
wget -O- https://download.newrelic.com/548C16BF.gpg | apt-key add -

# Fetch packages source
apt-get -y update

# Upgrade currently installed packages
apt-get -y upgrade

# Install required packages
apt-get install -y $PACKAGES

# Configure New Relic agent
nrsysmond-config --set license_key=$NEW_RELIC_LICENSE
/etc/init.d/newrelic-sysmond start

# Setup basic security
source _security.sh

# Setup PostgreSQL and Redis
source _database.sh

# Setup Git, Ruby and Rails
source _application.sh

echo
echo "=> Done in $(($(date +%s) - TIME))s"

exit 0
