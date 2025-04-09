#!/bin/bash

# List of script filenames
scripts=(
  "changeFilePerms.sh"
  "changePassword.sh"
  "firewall.sh"
  "harden.sh"
  "nologin.sh"
  "removeSSHKeys.sh"
  "removeSudoUsers.sh"
)

# Must be run as root
if [ "$EUID" -ne 0 ]; then
  echo "Must run as root."
  exit 1
fi

echo "Making scripts executable..."
for script in "${scripts[@]}"; do
  if [ -f "$script" ]; then
    chmod +x "$script"
    echo "$script is now executable."
  else
    echo "$script not found, skipping chmod."
  fi
done

echo "Running all scripts..."
for script in "${scripts[@]}"; do
  if [ -x "$script" ]; then
    echo "Running $script..."
    ./"$script"
  else
    echo "$script is not executable or missing. Skipping."
  fi
done

echo "All applicable scripts executed."
