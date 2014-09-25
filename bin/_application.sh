#!/usr/bin/env bash

# Create directories for application, repository, logs and temporary files
mkdir $REPOSITORY_PATH $APPLICATION_PATH $VAR_PATH

# Copy default .env to app directory
# Note: remember to add .env to your .gitignore
cp ../app/env $APPLICATION_PATH/.env

# Create bare repository
git -C $REPOSITORY_PATH init --bare

# Copy deploy hook and add execute permission
cp ../git/hooks/post-receive.0 $REPOSITORY_PATH/hooks/post-receive
chmod +x $REPOSITORY_PATH/hooks/post-receive

# Create application directory
git -C $APPLICATION_PATH init
git -C $APPLICATION_PATH remote add origin $REPOSITORY_PATH

# Clone and install ruby-build
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

# Install required version of Ruby and set it to default
rbenv install $RUBY_VERSION && rbenv global $RUBY_VERSION

# Install required Gems
gem install $GEMS && rbenv rehash

# Fix user home permissions
chown -R $USERNAME:$USERNAME $HOME

# Allow your user to export, start and stop the app service without password
echo "$USERNAME ALL = (root) NOPASSWD: /sbin/start, /sbin/stop" >> /etc/sudoers

# If the machine has less then aprox. 1Gb of RAM, swap is needed for Passenger setup
if [[ $(free | awk '/^Mem:/{print $2}') -lt 900000 ]]; then
  dd if=/dev/zero of=/swap bs=1M count=1024
  mkswap /swap
  swapon /swap
fi

# Run Passenger Nginx module setup
passenger-install-nginx-module --auto --auto-download --extra-configure-flags=none --languages ruby --prefix=/opt/nginx

# Configure nginx
# TODO: Use a modified version of h5bp nginx config files
#       https://github.com/h5bp/server-configs-nginx
