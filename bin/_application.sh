#!/usr/bin/env bash

# Create directories for application codebase, bare repository and variable files (log and pid)
mkdir $REPOSITORY_PATH $APPLICATION_PATH $VAR_PATH

# .env file holds environment variables to support the application
# Copy default template to the application's directory and add your SECRET_KEY_BASE
echo "LC_ALL=en_US.UTF-8" > $APPLICATION_PATH/.env
echo "RAILS_ENV=production" >> $APPLICATION_PATH/.env
echo "PORT=$APPLICATION_PORT" >> $APPLICATION_PATH/.env
echo "SECRET_KEY_BASE=$SECRET_KEY_BASE" >> $APPLICATION_PATH/.env

# Initialize bare repository
cd $REPOSITORY_PATH
git init . --bare
cd -

# Copy deploy hook to the repository and allow it to be executed
cp ../git/hooks/post-receive $REPOSITORY_PATH/hooks/post-receive
chmod +x $REPOSITORY_PATH/hooks/post-receive

# Setup application working tree repository
cd $APPLICATION_PATH
git init .
git remote add origin $REPOSITORY_PATH
cd -

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
