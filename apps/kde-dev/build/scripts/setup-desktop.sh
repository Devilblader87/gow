#!/bin/bash
set -e

# Set up desktop shortcuts and environment
USER_HOME="/home/retro"
DESKTOP_DIR="$USER_HOME/Desktop"
APPLICATIONS_DIR="$USER_HOME/.local/share/applications"

# Create directories
mkdir -p "$DESKTOP_DIR" "$APPLICATIONS_DIR"

# Create VS Code desktop shortcut with container-safe flags
cat > "$APPLICATIONS_DIR/code.desktop" << EOF
[Desktop Entry]
Name=Visual Studio Code
Comment=Code Editing. Redefined.
GenericName=Text Editor
Exec=code --no-sandbox --disable-dev-shm-usage --user-data-dir=$USER_HOME/.config/Code
Icon=code
Type=Application
StartupNotify=true
StartupWMClass=Code
Categories=TextEditor;Development;IDE;
MimeType=text/plain;inode/directory;
Actions=new-empty-window;
Keywords=vscode;

[Desktop Action new-empty-window]
Name=New Empty Window
Exec=code --no-sandbox --disable-dev-shm-usage --new-window %F
Icon=code
EOF

# Create Chrome desktop shortcut with container-safe flags
cat > "$APPLICATIONS_DIR/google-chrome.desktop" << EOF
[Desktop Entry]
Version=1.0
Name=Google Chrome
Comment=Access the Internet
GenericName=Web Browser
Exec=google-chrome-stable --no-sandbox --disable-dev-shm-usage --user-data-dir=$USER_HOME/.config/google-chrome
Terminal=false
Icon=google-chrome
Type=Application
Categories=Network;WebBrowser;
MimeType=text/html;text/xml;application/xhtml+xml;x-scheme-handler/http;x-scheme-handler/https;
StartupWMClass=Google-chrome
Keywords=web;browser;internet;
EOF

# Create Discover (app store) shortcut on desktop
cp /usr/share/applications/org.kde.discover.desktop "$DESKTOP_DIR/" 2>/dev/null || true

# Set up KDE configuration for development
cat > "$USER_HOME/.config/kdeglobals" << EOF
[General]
BrowserApplication=google-chrome-stable --no-sandbox
TerminalApplication=konsole

[KFileDialog Settings]
Recent Files[$e]=file:$USER_HOME
Recent URLs[$e]=file:$USER_HOME
detailViewIconSize=16

[PreviewSettings]
MaximumRemoteSize=0
camera=true
EOF

# Configure KWallet to not require password for basic usage
mkdir -p "$USER_HOME/.config"
cat > "$USER_HOME/.config/kwalletrc" << EOF
[Wallet]
Default Wallet=kdewallet
Enabled=true
Leave Open=true
Prompt on Open=false
EOF

# Set proper ownership
chown -R retro:retro "$USER_HOME"
