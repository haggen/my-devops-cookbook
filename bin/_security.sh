#!/usr/bin/env bash

# Update machine hostname
hostname $HOSTNAME

# Update `root` password
chpasswd <<< "root:$ROOT_PASSWORD"

# Create your user unless it already exists
useradd -d $HOME -m -s /bin/bash $USERNAME

# Update your user's password
chpasswd <<< "$USERNAME:$PASSWORD"

# Add your public key to authorized keys list
mkdir $HOME/.ssh
echo "$PUBLIC_KEY" >> $HOME/.ssh/authorized_keys
chown -R $USERNAME:$USERNAME $HOME

# ...
sed -i -r 's/DEFAULT_FORWARD_POLICY=\".+?\"/DEFAULT_FORWARD_POLICY=\"ALLOW\"/' /etc/default/ufw

# ...
iptables -t nat -A PREROUTING -i eth0 -p tcp --dport 80 -j REDIRECT --to-port 3000

# ...
iptables-save > /etc/iptables.rules

# Configure ports and enable firewall
for P in $PORTS; do ufw allow $P; done
yes | ufw enable

# fail2ban scans logs for suspicious activity
apt-get install -y fail2ban

# Configure remote access
echo >> /etc/ssh/sshd_config
echo "PermitRootLogin no" >> /etc/ssh/sshd_config
echo "PasswordAuthentication no" >> /etc/ssh/sshd_config
echo "AllowUsers $USERNAME" >> /etc/ssh/sshd_config

service ssh restart
