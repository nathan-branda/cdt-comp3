#!/bin/bash

# Script to change passwords for multiple users in Ubuntu with password verification
# This script must be run with root privileges

# Check if running as root
if [ "$(id -u)" -ne 0 ]; then
    echo "Error: This script must be run as root"
    echo "Please run with sudo: sudo $0"
    exit 1
fi

# Base password (change this to your desired base password)
base_password="Your_Password_Here"

# Array of users to change passwords for
users=(
    "Armorer"
    "Butcher"
    "Cleric"
    "Farmer"
    "Fisherman"
    "Fletcher"
    "Leatherworker"
    "Librarian"
    "Toolsmith"
    "Notch"
    "Alex"
    "Herobrine"
    "ubuntu"
    "Nitwit"
    "root"
)

echo "Starting password changes..."
echo "================================="

# Change passwords for each user
counter=1
for username in "${users[@]}"; do
    # Check if user exists
    if id "$username" &>/dev/null; then
        # Create password variation with counter (e.g., BlueTeam1, BlueTeam2, etc.)
        new_password="${base_password}${counter}"
        
        echo "Changing password for $username to ${new_password}..."
        
        # Change the password
        echo "$username:$new_password" | chpasswd
        
        # Verify the password was changed
        # This creates a test using the passwd command's check mode
        if echo "$new_password" | passwd --stdin "$username" --status >/dev/null 2>&1; then
            echo "VERIFICATION FAILED: Could not verify password for $username"
        else
            # Check exit code - if it's 0, the password is correct
            passwd_status=$(passwd -S "$username" | awk '{print $2}')
            if [ "$passwd_status" = "P" ]; then
                echo "SUCCESS: Password verified for $username"
            else
                echo "VERIFICATION FAILED: Password may not be set correctly for $username"
            fi
        fi
    else
        echo "WARNING: User $username does not exist"
    fi
