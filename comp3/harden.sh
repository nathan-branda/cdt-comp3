#!/bin/bash

# Path to smb.conf
SMB_CONF="/etc/samba/smb.conf"
BACKUP_PATH="/etc/samba/smb.conf.bak"

# Must be root
if [ "$EUID" -ne 0 ]; then
  echo "Must run as root"
  exit 1
fi

# Backup current smb.conf
echo "[*] Backing up existing smb.conf to $BACKUP_PATH"
cp "$SMB_CONF" "$BACKUP_PATH"

# Generate new secure smb.conf
cat > "$SMB_CONF" <<EOF
[global]
workgroup = WORKGROUP
server string = Hardened Samba Server
server role = standalone server
security = user
map to guest = never
encrypt passwords = yes
passdb backend = tdbsam
pam password change = yes
log file = /var/log/samba/log.%m
log level = 1
max log size = 1000

[secure_share]
path = /srv/samba/secure
valid users = Greyteam
read only = no
browsable = no
create mask = 0600
directory mask = 0700
EOF

# Create secure directory with minimal privileges
echo "[*] Creating secure share directory with 700 permissions..."
mkdir -p /srv/samba/secure
chmod 700 /srv/samba/secure
chown root:root /srv/samba/secure