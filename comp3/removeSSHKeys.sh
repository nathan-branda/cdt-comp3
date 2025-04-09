#!/bin/bash

# Script to remove SSH authorized_keys from all users except "Greyteam"

# Exit on error
set -e

# Iterate through all user home directories in /home
for dir in /home/*; do
  if [ -d "$dir" ]; then
    user=$(basename "$dir")
    
    # Skip "Greyteam"
    if [ "$user" != "Greyteam" ]; then
      auth_keys="$dir/.ssh/authorized_keys"
      
      if [ -f "$auth_keys" ]; then
        echo "Removing SSH keys for user: $user"
        > "$auth_keys"  # Truncate the file (safer than deleting)
        chown "$user":"$user" "$auth_keys"
      fi
    fi
  fi
done

# Also check for system users outside /home, e.g., /root
if [ "$EUID" -eq 0 ] && [ "$1" != "--skip-root" ]; then
  if [ "$USER" != "Greyteam" ]; then
    if [ -f /root/.ssh/authorized_keys ]; then
      echo "Removing SSH keys for root"
      > /root/.ssh/authorized_keys
      chown root:root /root/.ssh/authorized_keys
    fi
  fi
fi

echo "SSH key cleanup complete."
