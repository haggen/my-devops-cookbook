#!/usr/bin/env bash

[[ "$0" == "safety.sh" ]] && echo "This script cannot be called directly, use 'setup.sh'" && exit 1

# Update machine hostname
echo $HOSTNAME > /etc/hostname

# Update `root` password
chpasswd <<< "root:$ROOT_PASSWORD"

# Create your user unless it already exists
[[ id -u $YOUR_USERNAME > /dev/null 2>&1 ]] && useradd -d $HOME -m $YOUR_USERNAME

# Update your user's password
chpasswd <<< "$YOUR_USERNAME:$YOUR_PASSWORD"

# Add your public key to authorized keys list
mkdir $HOME/.ssh && echo "$YOUR_PUBLIC_KEY" >> $HOME/.ssh/authorized_keys

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
echo "PermitRootLogin no" >> /etc/ssh/sshd_config
echo "PasswordAuthentication no" >> /etc/ssh/sshd_config
echo "AllowUsers $YOUR_USERNAME" >> /etc/ssh/sshd_config
