#!/bin/bash

# List of users to restrict
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
  "Nitwit"
  "root"
)

# Must be root
if [ "$EUID" -ne 0 ]; then
  echo "Must run as root."
  exit 1
fi

# Loop through users and set their shell
for user in "${users[@]}"; do
  if id "$user" &>/dev/null; then
    echo "Locking shell access for user: $user"
    usermod -s /sbin/nologin "$user"
  else
    echo "User '$user' does not exist. Skipping."
  fi
done

echo "[*] All applicable users updated."
