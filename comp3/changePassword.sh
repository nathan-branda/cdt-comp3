#!/bin/bash

# Script to change passwords for multiple users in Ubuntu (including root)
# Requires root privileges and confirms before changing sensitive accounts

# Check if running as root
if [ "$(id -u)" -ne 0 ]; then
    echo "ERROR: This script must be run as root" >&2
    echo "Use: sudo $0" >&2
    exit 1
fi

# Base password (change this to your desired base password)
base_password="!BlueTeam"

# List of users (customize as needed)
users=(
    "Armorer" "Butcher" "Cleric" "Farmer" 
    "Fisherman" "Fletcher" "Leatherworker" 
    "Librarian" "Toolsmith" "Notch" 
    "Alex" "Herobrine" "Nitwit"
    "root"  # Explicitly included
)

echo "=== Password Change Script ==="
echo "WARNING: This will change passwords for ${#users[@]} accounts, including root."
read -rp "Continue? (y/N): " confirm
[[ "$confirm" != [yY] ]] && exit 1

# Main loop
counter=1
for username in "${users[@]}"; do
    if id "$username" &>/dev/null; then
        new_password="${base_password}${counter}"
        
        # Extra confirmation for root
        if [ "$username" = "root" ]; then
            echo "=== WARNING: Changing ROOT password ==="
            read -rp "Proceed with root password change? (y/N): " root_confirm
            [[ "$root_confirm" != [yY] ]] && continue
        fi

        echo "Changing password for $username..."
        if ! echo "$username:$new_password" | chpasswd; then
            echo "FAILED: $username" >&2
            continue
        fi

        # Verification
        pw_status=$(passwd -S "$username" 2>/dev/null | awk '{print $2}')
        if [ "$pw_status" = "P" ]; then
            echo "SUCCESS: $username password set"
            ((counter++))  # Only increment on success
        else
            echo "WARNING: Password may not be active for $username" >&2
        fi
    else
        echo "SKIPPED: User $username does not exist" >&2
    fi
    echo "---------------------------------"
done

echo "=== Results ==="
echo "Changed $(($counter-1)) passwords."
echo "Store passwords securely!"
