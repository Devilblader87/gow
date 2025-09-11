#!/bin/bash
# Gaming Environment Setup Script
# This script sets up gaming tools and optimizations for the KDE Gaming Desktop

set -e

echo "🎮 Setting up gaming environment..."

# Create gaming directories
mkdir -p /home/retro/{Games,Emulation,ROMs}
mkdir -p /home/retro/.config/{lutris,steam,retroarch}
mkdir -p /home/retro/.local/share/{Steam,lutris,applications}

# Set up Wine environment
echo "🍷 Configuring Wine..."
export WINEPREFIX=/home/retro/.wine
if [ ! -d "$WINEPREFIX" ]; then
    winecfg /S || true
    winetricks -q vcredist2019 dxvk || true
fi

# Configure Steam for optimal performance
echo "⚡ Optimizing Steam configuration..."
mkdir -p /home/retro/.steam/steam/config
cat > /home/retro/.steam/steam/config/config.vdf << 'EOF'
"InstallConfigStore"
{
	"Software"
	{
		"Valve"
		{
			"Steam"
			{
				"CompatToolMapping"
				{
					"0"
					{
						"name"		"Default"
						"tool"		"Proton Experimental"
					}
				}
			}
		}
	}
}
EOF

# Set up Lutris configuration
echo "🎯 Configuring Lutris..."
mkdir -p /home/retro/.config/lutris
cat > /home/retro/.config/lutris/lutris.conf << 'EOF'
[lutris]
library_sync_at_startup = True
show_advanced_options = True

[system]
disable_compositor = True
reset_pulse = True
use_us_layout = False

[wine]
autoconfigure_prefix = True
desktop = False
auto_python_to_wine = True
EOF

# Set up MangoHud configuration
echo "📊 Configuring MangoHud..."
mkdir -p /home/retro/.config/MangoHud
cat > /home/retro/.config/MangoHud/MangoHud.conf << 'EOF'
fps
frame_timing
cpu_temp
gpu_temp
cpu_load_change
gpu_load_change
ram
vram
engine_version
vulkan_driver
wine
gamemode
position=top-left
background_alpha=0.4
font_size=24
EOF

# Set up GameMode configuration
echo "🏎️ Configuring GameMode..."
sudo mkdir -p /etc/gamemode
sudo tee /etc/gamemode/gamemode.ini > /dev/null << 'EOF'
[general]
renice=10
ioprio=0
inhibit_screensaver=1

[gpu]
apply_gpu_optimisations=accept-responsibility
gpu_device=0
amd_performance_level=high
nvidia_powermizer_mode=prefer-maximum-performance

[cpu]
pin_prefer_available_cores=1
park_cores=0
soft_realtime=auto
EOF

# Create desktop shortcuts for gaming tools
echo "🖥️ Creating desktop shortcuts..."
mkdir -p /home/retro/Desktop

# Steam shortcut
cat > /home/retro/Desktop/Steam.desktop << 'EOF'
[Desktop Entry]
Version=1.0
Type=Application
Name=Steam
Comment=Application for managing and playing games on Steam
Exec=steam %U
Icon=steam
StartupNotify=true
NoDisplay=false
Categories=Network;FileTransfer;Game;
MimeType=x-scheme-handler/steam;x-scheme-handler/steamlink;
EOF

# Lutris shortcut
cat > /home/retro/Desktop/Lutris.desktop << 'EOF'
[Desktop Entry]
Type=Application
Name=Lutris
Comment=Open Gaming Platform
Exec=lutris %U
Icon=lutris
Categories=Game;
StartupNotify=true
MimeType=application/x-lutris-installer;x-scheme-handler/lutris;
EOF

# Game development shortcuts
cat > /home/retro/Desktop/Unity\ Hub.desktop << 'EOF'
[Desktop Entry]
Version=1.0
Type=Application
Name=Unity Hub
Comment=Unity Hub
Exec=flatpak run com.unity.UnityHub %U
Icon=com.unity.UnityHub
StartupNotify=true
Categories=Development;IDE;
EOF

cat > /home/retro/Desktop/Godot.desktop << 'EOF'
[Desktop Entry]
Version=1.0
Type=Application
Name=Godot
Comment=Godot Engine
Exec=flatpak run org.godotengine.Godot %U
Icon=org.godotengine.Godot
StartupNotify=true
Categories=Development;IDE;
EOF

# Make shortcuts executable
chmod +x /home/retro/Desktop/*.desktop

# Set proper ownership
chown -R retro:retro /home/retro/

echo "✅ Gaming environment setup complete!"
echo "🎮 Available gaming platforms:"
echo "   - Steam (Flatpak + native)"
echo "   - Lutris (Flatpak - Wine + native)"
echo "   - Heroic Games Launcher (Flatpak - Epic/GOG)"
echo "   - RetroArch (Flatpak - retro gaming)"
echo "   - PrismLauncher (Flatpak - Minecraft)"
echo "   - Discord (Flatpak - communication)"
echo ""
echo "🛠️ Development tools ready:"
echo "   - Unity Hub (Flatpak)"
echo "   - Godot Engine (Flatpak)" 
echo "   - Blender (native)"
echo "   - VS Code (native)"
echo "   - Docker (native)"
echo "   - Full SDK support (Java, Node.js, Python, Go, Rust)"
echo ""  
echo "📦 First run will install Flatpak apps automatically"
echo "    This may take a few minutes on first startup"
