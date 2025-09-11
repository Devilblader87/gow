#!/bin/bash
set -e

echo "🚀 Initializing KDE Gaming & Development Desktop..."

# Initialize XDG runtime directory
export XDG_RUNTIME_DIR=${XDG_RUNTIME_DIR:-/tmp/user/1000}
mkdir -p "$XDG_RUNTIME_DIR"
chmod 700 "$XDG_RUNTIME_DIR"

# Create essential directories
mkdir -p /home/retro/{Games,Projects,Downloads,Documents}
mkdir -p /home/retro/.config/{kde,steam,lutris,wine}
mkdir -p /home/retro/.local/share/{applications,Steam,lutris}

# Start D-Bus services
echo "📡 Starting D-Bus services..."
if [ ! -d /run/dbus ]; then
    mkdir -p /run/dbus
fi
if [ ! -f /run/dbus/pid ]; then
    dbus-daemon --system --fork
fi

# Start session D-Bus
export DBUS_SESSION_BUS_ADDRESS="unix:path=$XDG_RUNTIME_DIR/bus"
dbus-daemon --session --fork --address="$DBUS_SESSION_BUS_ADDRESS"

# Initialize gaming environment
echo "🎮 Setting up gaming environment..."
export DXVK_HUD=${DXVK_HUD:-fps,memory}
export MANGOHUD=${MANGOHUD:-1}
export GAMEMODE=${GAMEMODE:-1}
export WINE_CPU_TOPOLOGY=4:2
export WINEPREFIX=/home/retro/.wine

# Initialize development environment
echo "💻 Setting up development environment..."
export JAVA_HOME=/usr/lib/jvm/java-21-openjdk-amd64
export ANDROID_HOME=/opt/android-sdk
export PATH=$PATH:$JAVA_HOME/bin:/usr/local/go/bin:/home/retro/.cargo/bin

# Initialize KWallet and credential storage
echo "🔐 Starting credential services..."
export KWALLET_DISABLE_TIMEOUT=1
kwalletd5 --daemon &

# Start gnome-keyring for additional credential support
eval $(gnome-keyring-daemon --start --components=pkcs11,secrets,ssh,gpg)
export GNOME_KEYRING_CONTROL
export GNOME_KEYRING_PID

# Start Docker daemon if not running (for development)
if ! pgrep dockerd > /dev/null; then
    echo "🐳 Starting Docker daemon..."
    dockerd &
    sleep 3
fi

# Set up GPU and audio for gaming
echo "🎬 Configuring GPU and audio..."
# Ensure proper GPU driver setup
if [ -d /dev/dri ]; then
    chmod 666 /dev/dri/* 2>/dev/null || true
fi

# Start audio services
pulseaudio --start --log-target=syslog &

# Configure display and desktop
echo "🖥️ Starting KDE Plasma desktop..."
export DISPLAY=${DISPLAY:-:0}
export KDE_FULL_SESSION=true
export DESKTOP_SESSION=plasma
export XDG_CURRENT_DESKTOP=KDE

# Configure Plasma for container use
/opt/gow/scripts/setup-desktop.sh

# Install essential Flatpak apps on first run
echo "📦 Setting up Flatpak applications..."
FLATPAK_SETUP_MARKER="/home/retro/.flatpak-setup-complete"
if [ ! -f "$FLATPAK_SETUP_MARKER" ]; then
    echo "🎮 Installing gaming and development apps via Flatpak..."
    flatpak install -y --noninteractive flathub com.valvesoftware.Steam || echo "Steam install failed"
    flatpak install -y --noninteractive flathub net.lutris.Lutris || echo "Lutris install failed"  
    flatpak install -y --noninteractive flathub com.heroicgameslauncher.hgl || echo "Heroic install failed"
    flatpak install -y --noninteractive flathub org.prismlauncher.PrismLauncher || echo "PrismLauncher install failed"
    flatpak install -y --noninteractive flathub com.github.tchx84.Flatseal || echo "Flatseal install failed"
    flatpak install -y --noninteractive flathub org.godotengine.Godot || echo "Godot install failed"
    flatpak install -y --noninteractive flathub com.unity.UnityHub || echo "Unity Hub install failed"
    flatpak install -y --noninteractive flathub org.libretro.RetroArch || echo "RetroArch install failed"
    flatpak install -y --noninteractive flathub com.discordapp.Discord || echo "Discord install failed"
    touch "$FLATPAK_SETUP_MARKER"
    echo "✅ Flatpak apps installation complete!"
else
    echo "✅ Flatpak apps already installed"
fi

# Start gaming services in background
echo "🎯 Starting gaming services..."
# Initialize Steam (headless)
if command -v steam >/dev/null 2>&1; then
    steam -silent &
fi

# Start MangoHud service
if command -v mangohud >/dev/null 2>&1; then
    mangohud --dlsym &
fi

echo "✅ KDE Gaming & Development Desktop ready!"

# Start Plasma Wayland session
exec startplasma-wayland
