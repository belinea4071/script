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

# Add dummy network interface
nmcli con add type dummy con-name fake ifname fake0 ip4 1.2.3.4/24 gw4 1.2.3.1

# comment entry for root in /etc/cockpit/disallowed-users
sed -i 's/root/#root/' /etc/cockpit/disallowed-users

# Restart Cockpit service
systemctl restart cockpit.service

# EOF text
cat <<EOF

*************************************************
*                                               *
*             Cockpit Installation              *
*                                               *
*************************************************

Cockpit has been successfully installed and configured.
The entry for root in /etc/cockpit/disallowed-users has been uncommented.
You can access Cockpit by navigating to http://your-server-ip:9090 in your web browser.

EOF
