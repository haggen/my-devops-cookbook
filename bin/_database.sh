#!/usr/bin/env bash

# Install databases
apt-get install -y postgresql libpq-dev redis-server redis-tools

# Create PostgreSQL role for the application
sudo -u postgres createuser -d $USERNAME

# Create production database
sudo -u postgres createdb app_production -O $USERNAME