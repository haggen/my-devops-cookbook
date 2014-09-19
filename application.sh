#!/usr/bin/env bash

[[ "$0" == "application.sh" ]] && echo "This script cannot be called directly, use `setup.sh`" && exit 1

# Create bare repository
mkdir $HOME/git && cd $HOME/git && git init --bare

# Create application directory
mkdir $HOME/app && cd $HOME/app && git init && git remote add origin $HOME/git

# Create log directory
mkdir $HOME/log

# Clone and install ruby-build
# ruby-build help us build Ruby from source with ease
git clone git://github.com/sstephenson/ruby-build.git /tmp/ruby-build
cd /tmp/ruby-build && ./install.sh

# Clone and setup rbenv
# rbenv help us handle your Ruby environment
git clone https://github.com/sstephenson/rbenv.git $HOME/.rbenv

# Configure rbenv
echo 'export PATH="$HOME/.rbenv/bin:$PATH"' >> $HOME/.bash_profile
echo 'eval "$(rbenv init -)"' >> $HOME/.bash_profile

source $HOME/.bash_profile

# Install required Ruby version and set it as default
rbenv install $RUBY_VERSION && rbenv global $RUBY_VERSION

# Install required Gems
gem install bundler rails passenger

# Make rbenv detect new executables
rbenv rehash

# Run Passenger+Nginx setup
passenger-install-nginx-module