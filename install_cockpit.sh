#!/bin/bash

# Install Cockpit
apt-get install cockpit -y

# Install zfsutils-linux
apt install zfsutils-linux -y

# Enable and start Cockpit service
systemctl enable cockpit.service
systemctl start cockpit.service

# Install 45drives repository
curl -sSL https://repo.45drives.com/setup | sudo bash

# Update package list
apt-get update

# Install cockpit-file-sharing
apt install cockpit-file-sharing -y

# Install cockpit-navigator
apt install cockpit-navigator -y

# Install cockpit-identities
apt install cockpit-identities -y

# Install cockpit-zfs-manager
apt install cockpit-zfs-manager -y

# Install additional Cockpit packages
apt-get install -y cockpit cockpit-packagekit cockpit-pcp cockpit-storaged tuned

# Uncomment entry for root in /etc/cockpit/disallowed-users
sed -i 's/#root/root/' /etc/cockpit/disallowed-users

# Get server IP address
server_ip=$(hostname -I | awk '{print $1}')

# Restart Cockpit service
systemctl restart cockpit.service

# Add dummy network interface
nmcli con add type dummy con-name fake ifname fake0 ip4 1.2.3.4/24 gw4 1.2.3.1

# Create a new user "eberle" with Samba permissions
useradd -m eberle
echo "Set a password for the user 'eberle':"
passwd eberle

# Install Samba if not installed
apt-get install -y samba

# Add "eberle" to Samba
smbpasswd -a eberle

# Create a new sudo user "gueb"
useradd -m -G sudo gueb
echo "Set a password for the user 'gueb':"
passwd gueb

# Display information
cat <<EOF

*************************************************
*                                               *
*             Cockpit Installation              *
*                                               *
*************************************************

Cockpit has been successfully installed and configured.
The entry for root in /etc/cockpit/disallowed-users has been uncommented.
You can access Cockpit by navigating to http://$server_ip:9090 in your web browser.

User 'eberle' has been created with Samba permissions.
Make sure to remember the password you set for 'eberle'.

A new sudo user 'gueb' has been created.

EOF
