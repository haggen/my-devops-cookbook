#!/usr/bin/env bash

# Create application directories
mkdir $REPOSITORY_PATH $APPLICATION_PATH $LOG_PATH $TMP_PATH

# Copy default .env to app directory
# Note: remember to add .env to your .gitignore
cp ../app/env.0 $APPLICATION_PATH/.env

# Create bare repository
git -C $REPOSITORY_PATH init --bare

# Install deploy hook
cp ../git/hooks/post-receive.0 $REPOSITORY_PATH/hooks/
chmod +x $REPOSITORY_PATH/hooks/post-receive.0

# Create application directory
git -C $APPLICATION_PATH init
git -C $APPLICATION_PATH remote add origin $REPOSITORY_PATH

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

# Load rbenv here
source $HOME/.bash_profile

# Install Ruby
rbenv install $RUBY_VERSION

# Set default Ruby version
rbenv global $RUBY_VERSION

# Install required Gems
gem install bundler passenger

# Make rbenv detect new executables
rbenv rehash

# Fix permissions
chown -R $USERNAME:$USERNAME $HOME

# Run Passenger+Nginx setup
passenger-install-nginx-module --auto

# Configure nginx
# TODO: Use a modified version of h5bp nginx config files
#       https://github.com/h5bp/server-configs-nginx

# Start nginx service
service nginx start