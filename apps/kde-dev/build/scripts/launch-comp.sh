#!/bin/bash
set -e

# Initialize XDG runtime directory
export XDG_RUNTIME_DIR=${XDG_RUNTIME_DIR:-/tmp/user/1000}
mkdir -p "$XDG_RUNTIME_DIR"
chmod 700 "$XDG_RUNTIME_DIR"

# Start D-Bus
if [ ! -d /run/dbus ]; then
    mkdir -p /run/dbus
fi
if [ ! -f /run/dbus/pid ]; then
    dbus-daemon --system --fork
fi

# Start session D-Bus
export DBUS_SESSION_BUS_ADDRESS="unix:path=$XDG_RUNTIME_DIR/bus"
dbus-daemon --session --fork --address="$DBUS_SESSION_BUS_ADDRESS"

# Initialize KWallet (KDE's keyring)
export KWALLET_DISABLE_TIMEOUT=1
kwalletd5 --daemon &

# Start Plasma desktop
export DISPLAY=${DISPLAY:-:0}
export KDE_FULL_SESSION=true
export DESKTOP_SESSION=plasma

# Configure Plasma for container use
/opt/gow/scripts/setup-desktop.sh

# Start Plasma Wayland session
exec startplasma-wayland
