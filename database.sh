#!/usr/bin/env bash

[[ "$0" == "database.sh" ]] && echo "This script cannot be called directly, use 'setup.sh'" && exit 1

# Install databases
apt-get install -y postgresql postgresql-contrib redis-server redis-tools

# Create PostgreSQL role for the application
su -u postgres createuser -d $YOUR_USERNAME