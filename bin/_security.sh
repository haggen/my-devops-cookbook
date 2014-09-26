#!/usr/bin/env bash

# Change root password
chpasswd <<< "root:$ROOT_PASSWORD"

# Create application's user and change its password
useradd -d $HOME -m -s /bin/bash $USERNAME
chpasswd <<< "$USERNAME:$PASSWORD"

# Add your public key to authorized keys list and fix its permissions
mkdir $HOME/.ssh
echo "$PUBLIC_KEY" >> $HOME/.ssh/authorized_keys
chown -R $USERNAME:$USERNAME $HOME

# Flush iptables configuration
iptables -P INPUT ALLOW
iptables -P OUTPUT ALLOW
iptables -P FORWARD ALLOW
iptables -P PREROUTING ALLOW -t nat
iptables -F

# Configure iptables and export configuration to file
# iptables configuration must be saved BEFORE fail2ban is
# installed, since it automatically adds its own rules
iptables -I INPUT 1 -i lo -j ACCEPT
iptables -A INPUT -m conntrack --ctstate ESTABLISHED,RELATED -j ACCEPT
for P in $PORTS; do iptables -A INPUT -p tcp --dport $P -j ACCEPT; done
iptables -A PREROUTING -t nat -p tcp --dport 80 -j REDIRECT --to-port $APPLICATION_PORT
iptables -A INPUT -j DROP

iptables-save > /etc/iptables.conf

# Restore iptables configuration when network is up
echo '#!/usr/bin/env bash' > /etc/network/if-up.d/iptables
echo 'iptables-restore < /etc/iptables.conf' >> /etc/network/if-up.d/iptables
chmod +x /etc/network/if-up.d/iptables

# Setup fail2ban - fail2ban looks for suspicious activity
apt-get install -y fail2ban

# Configure SSH
echo >> /etc/ssh/sshd_config
echo "PermitRootLogin no" >> /etc/ssh/sshd_config
echo "PasswordAuthentication no" >> /etc/ssh/sshd_config
echo "AllowUsers $USERNAME" >> /etc/ssh/sshd_config

service ssh restart
