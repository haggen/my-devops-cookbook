#!/usr/bin/env bash

# Update hostname
OLDNAME=$(cat /etc/hostname)
sed -i "s/$OLDNAME/$HOSTNAME/g" /etc/hosts
sed -i "s/$OLDNAME/$HOSTNAME/g" /etc/hostname

# Change root password
chpasswd <<< "root:$ROOT_PASSWORD"

# Create application's user and change its password
useradd -d $HOME -m -s /bin/bash $USERNAME
chpasswd <<< "$USERNAME:$PASSWORD"

# Add your public key to authorized keys list and fix its permissions
mkdir $HOME/.ssh
echo "$PUBLIC_KEY" >> $HOME/.ssh/authorized_keys
chown -R $USERNAME:$USERNAME $HOME

# fail2ban looks for suspicious activity
apt-get install -y fail2ban

# Configure iptables and export configuration to file
# At this point we've already installed fail2ban - which add its own
# iptables rules - so we can safely save those configurations.
iptables -P PREROUTING ACCEPT -t nat
iptables -I INPUT 1 -i lo -j ACCEPT
iptables -A INPUT -m conntrack --ctstate ESTABLISHED,RELATED -j ACCEPT
iptables -A INPUT -p tcp --dport 22 -j ACCEPT
iptables -A INPUT -p tcp --dport 80 -j ACCEPT
iptables -A INPUT -p tcp --dport 3000 -j ACCEPT
iptables -A PREROUTING -t nat -p tcp --dport 80 -j REDIRECT --to-port 3000
iptables -A INPUT DROP

iptables-save > /etc/iptables.conf

# Add upstart job to load iptables configuration
cp ../etc/init/iptables.conf /etc/init/iptables.conf
chmod +x /etc/init/iptables.conf

# Configure remote access
echo >> /etc/ssh/sshd_config
echo "PermitRootLogin no" >> /etc/ssh/sshd_config
echo "PasswordAuthentication no" >> /etc/ssh/sshd_config
echo "AllowUsers $USERNAME" >> /etc/ssh/sshd_config

service ssh restart
