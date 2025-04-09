#!/bin/bash

# List of users to revoke sudo from
users=(
    Armorer 
    Butcher 
    Cleric 
    Farmer 
    Fisherman 
    Fletcher 
    Leatherworker 
    Librarian 
    Toolsmith 
    Notch 
    Alex 
    Steve 
)

echo "[*] Revoking sudo privileges from users..."

for user in "${users[@]}"; do
    echo "→ Processing user: $user"

    # Remove user from sudo group
    if id -nG "$user" | grep -qw "sudo"; then
        sudo deluser "$user" sudo
        echo "  - Removed $user from 'sudo' group"
    else
        echo "  - $user is not in the 'sudo' group"
    fi

    # Backup sudoers file before editing
    sudo cp /etc/sudoers /etc/sudoers.bak

    # Comment out any specific sudoers entry for the user in /etc/sudoers
    if sudo grep -q "^$user" /etc/sudoers; then
        sudo sed -i "/^$user/s/^/#/" /etc/sudoers
        echo "  - Commented out sudoers entry in /etc/sudoers"
    fi

    # Remove or comment out user-specific sudoers files in /etc/sudoers.d/
    if [ -f "/etc/sudoers.d/$user" ]; then
        sudo mv "/etc/sudoers.d/$user" "/etc/sudoers.d/$user.disabled"
        echo "  - Disabled /etc/sudoers.d/$user"
    fi
done

echo "[✓] Sudo privileges revoked for all listed users."


