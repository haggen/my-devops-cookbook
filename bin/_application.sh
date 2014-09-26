#!/usr/bin/env bash

# Create directories for application codebase, bare repository and variable files (log and pid)
mkdir $REPOSITORY_PATH $APPLICATION_PATH $VAR_PATH

# .env file holds environment variables to support the application
# Copy default template to the application's directory and add your SECRET_KEY_BASE
cp ../app/env $APPLICATION_PATH/.env
echo "SECRET_KEY_BASE=$SECRET_KEY_BASE" >> $APPLICATION_PATH/.env

# Initialize bare repository
git -C $REPOSITORY_PATH init --bare

# Copy deploy hook to the repository and allow it to be executed
cp ../git/hooks/post-receive $REPOSITORY_PATH/hooks/post-receive
chmod +x $REPOSITORY_PATH/hooks/post-receive

# Setup application working tree repository
git -C $APPLICATION_PATH init
git -C $APPLICATION_PATH remote add origin $REPOSITORY_PATH

# Download and install ruby-build
git clone git://github.com/sstephenson/ruby-build.git /tmp/ruby-build
cd /tmp/ruby-build
bash install.sh
cd -

# Clone and setup rbenv
git clone https://github.com/sstephenson/rbenv.git $HOME/.rbenv

# Add rbenv initialization to user's bash profile
echo 'export PATH="$HOME/.rbenv/bin:$PATH"' >> $HOME/.bash_profile
echo 'eval "$(rbenv init -)"' >> $HOME/.bash_profile

# Load rbenv here
source $HOME/.bash_profile

# Setup required version of Ruby and set it to default
rbenv install $RUBY_VERSION && rbenv global $RUBY_VERSION

# Install required Gems and reload Gem binaries path
gem install $GEMS && rbenv rehash

# Fix user's home permissions
chown -R $USERNAME:$USERNAME $HOME

# Swap space is needed for Passenger setup (it failed even with 1Gb of RAM)
if [[ $(free | awk '/^Swap:/{print $2}') -eq 0 ]]; then
  dd if=/dev/zero of=/swap bs=1M count=1024
  mkswap /swap
  swapon /swap
fi

# Run Passenger Nginx module setup
passenger-install-nginx-module --auto --auto-download --extra-configure-flags=none --languages ruby --prefix=/opt/nginx

# Configure nginx
# TODO: Use a modified version of h5bp nginx config files
#       https://github.com/h5bp/server-configs-nginx
