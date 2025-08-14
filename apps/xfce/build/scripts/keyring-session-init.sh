#!/bin/bash
set -e

# Keyring Session Initialization for Wolf containers
# This ensures GNOME keyring is properly initialized for VS Code and other applications

# Setup XDG_RUNTIME_DIR if not already set
if [ -z "${XDG_RUNTIME_DIR:-}" ]; then
    RUNTIME_DIR="/tmp/user/$(id -u)"
    mkdir -p "$RUNTIME_DIR"
    chmod 700 "/tmp/user" "$RUNTIME_DIR" 2>/dev/null || true
    export XDG_RUNTIME_DIR="$RUNTIME_DIR"
fi

# Start gnome-keyring if not already running
if ! pgrep -u "$(id -u)" -x gnome-keyring-d >/dev/null 2>&1; then
    echo "Starting GNOME keyring daemon..."
    eval "$(/usr/bin/gnome-keyring-daemon --start --components=secrets,ssh,pkcs11 --daemonize)"
    
    # Export the SSH_AUTH_SOCK for the session
    if [ -n "${SSH_AUTH_SOCK:-}" ]; then
        echo "export SSH_AUTH_SOCK='$SSH_AUTH_SOCK'" >> "$HOME/.bashrc"
        echo "GNOME keyring started successfully"
    else
        echo "Warning: GNOME keyring may not have started properly"
    fi
else
    echo "GNOME keyring already running"
fi

exit 0
