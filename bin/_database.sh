#!/usr/bin/env bash

# Install databases
apt-get install -y postgresql postgresql-contrib redis-server redis-tools

# Create PostgreSQL role for the application
sudo -u postgres createuser -d $USERNAME