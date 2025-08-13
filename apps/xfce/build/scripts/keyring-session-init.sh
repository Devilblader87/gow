#!/bin/bash
set -euo pipefail

# Ensure XDG_RUNTIME_DIR exists and has proper permissions
RUNTIME_DIR="$HOME/.run/user/$(id -u)"
mkdir -p "$RUNTIME_DIR"
chmod 700 "$HOME/.run" "$HOME/.run/user" "$RUNTIME_DIR" 2>/dev/null || true
export XDG_RUNTIME_DIR="$RUNTIME_DIR"

# Start gnome-keyring if not already running
if ! pgrep -u "$(id -u)" -x gnome-keyring-d >/dev/null 2>&1; then
    eval "$(/usr/bin/gnome-keyring-daemon --start --components=secrets,ssh,pkcs11)"
    export SSH_AUTH_SOCK
fi

# Ensure the keyring environment is available to other processes
if [ -n "${SSH_AUTH_SOCK:-}" ]; then
    echo "export SSH_AUTH_SOCK='$SSH_AUTH_SOCK'" >> "$HOME/.xsessionrc"
fi

exit 0
