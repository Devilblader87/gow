#!/bin/bash

# Create desktop shortcuts with proper security flags for containerized environment

# Create Desktop directory if it doesn't exist
mkdir -p ~/Desktop

# VS Code shortcut with sandbox disabled for container environment
cat > ~/Desktop/code.desktop << 'EOF'
[Desktop Entry]
Version=1.0
Type=Application
Name=Visual Studio Code
Comment=Code Editing. Redefined.
Exec=code --no-sandbox --user-data-dir=/home/retro/.vscode-user
Icon=code
Terminal=false
Categories=Development;IDE;
MimeType=text/plain;inode/directory;
StartupWMClass=Code
EOF

# Chrome shortcut with sandbox disabled for container environment
cat > ~/Desktop/chrome.desktop << 'EOF'
[Desktop Entry]
Version=1.0
Type=Application
Name=Google Chrome
Comment=Access the Internet
Exec=google-chrome --no-sandbox --user-data-dir=/home/retro/.chrome-user --disable-dev-shm-usage --disable-gpu-sandbox
Icon=google-chrome
Terminal=false
Categories=Network;WebBrowser;
MimeType=text/html;text/xml;application/xhtml+xml;
StartupWMClass=Google-chrome
EOF

# Steam shortcut
cat > ~/Desktop/steam.desktop << 'EOF'
[Desktop Entry]
Version=1.0
Type=Application
Name=Steam
Comment=Application for managing and playing games on Steam
Exec=steam
Icon=steam
Terminal=false
Categories=Network;FileTransfer;Game;
StartupWMClass=Steam
EOF

# Blender shortcut
cat > ~/Desktop/blender.desktop << 'EOF'
[Desktop Entry]
Version=1.0
Type=Application
Name=Blender
Comment=3D modeling, animation, rendering and post-production
Exec=blender
Icon=blender
Terminal=false
Categories=Graphics;3DGraphics;
StartupWMClass=Blender
EOF

# Filezilla shortcut
cat > ~/Desktop/filezilla.desktop << 'EOF'
[Desktop Entry]
Version=1.0
Type=Application
Name=FileZilla
Comment=FTP, FTPS and SFTP client
Exec=filezilla
Icon=filezilla
Terminal=false
Categories=Network;FileTransfer;
StartupWMClass=Filezilla
EOF

# Docker Desktop shortcut (command line access)
cat > ~/Desktop/docker-terminal.desktop << 'EOF'
[Desktop Entry]
Version=1.0
Type=Application
Name=Docker Terminal
Comment=Open terminal with Docker commands
Exec=xfce4-terminal --title="Docker Terminal" --execute bash -c "echo 'Docker is available! Try: docker --version'; bash"
Icon=utilities-terminal
Terminal=false
Categories=Development;System;
StartupWMClass=Xfce4-terminal
EOF

# Unity Hub shortcut
cat > ~/Desktop/unity-hub.desktop << 'EOF'
[Desktop Entry]
Version=1.0
Type=Application
Name=Unity Hub
Comment=Unity development environment
Exec=/opt/unity-hub --no-sandbox
Icon=unity-hub
Terminal=false
Categories=Development;
StartupWMClass=Unity Hub
EOF

# Make all desktop files executable
chmod +x ~/Desktop/*.desktop

echo "Desktop shortcuts created successfully!"
