#!/usr/bin/env bash

# Update machine hostname
echo $HOSTNAME > /etc/hostname

# Update `root` password
chpasswd <<< "root:$ROOT_PASSWORD"

# Create your user unless it already exists
useradd -d $HOME -m -s /bin/bash $USERNAME

# Update your user's password
chpasswd <<< "$USERNAME:$PASSWORD"

# Add your public key to authorized keys list
mkdir $HOME/.ssh; echo "$PUBLIC_KEY" >> $HOME/.ssh/authorized_keys

# Fix permissions for SSH connection to work
chown -R $USERNAME:$USERNAME $HOME

# Allow ports on firewall
for P in $PORTS; do
  ufw allow $P
done

# Enable firewall
yes | ufw enable

# Install fail2ban
apt-get install -y fail2ban

# Configure remote access
# SSH need to be restarted, but if we do it now you'll lose the connection
echo >> /etc/ssh/sshd_config
echo "PermitRootLogin no" >> /etc/ssh/sshd_config
echo "PasswordAuthentication no" >> /etc/ssh/sshd_config
echo "AllowUsers $USERNAME" >> /etc/ssh/sshd_config

# Restart SSH
service restart ssh