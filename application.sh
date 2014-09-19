#!/usr/bin/env bash

[[ "$0" == "application.sh" ]] && echo "This script cannot be called directly, use 'setup.sh'" && exit 1

# Create application directories
mkdir $BARE_DIR $APP_DIR $LOG_DIR $TMP_DIR

# Create bare repository
git -C $BARE_DIR init --bare

# Install deploy hook
cp post-receive.0 $BARE_DIR/hooks/
chmod +x $BARE_DIR/hooks/post-receive.0

# Create application directory
git -C $APP_DIR init
git -C $APP_DIR remote add origin $BARE_DIR

# Clone and install ruby-build
# ruby-build help us build Ruby from source with ease
git clone git://github.com/sstephenson/ruby-build.git /tmp/ruby-build
cd /tmp/ruby-build
bash install.sh
cd -

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