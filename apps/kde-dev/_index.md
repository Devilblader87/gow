# KDE Development Desktop

A complete KDE Plasma development environment with integrated app store and credential management.

## Features

- **KDE Plasma Desktop** - Modern, feature-rich desktop environment
- **Integrated App Store** - Discover (KDE) + Flatpak for easy app installation
- **Credential Management** - KWallet for secure password/key storage
- **Pre-installed Development Tools**:
  - Visual Studio Code
  - Google Chrome
  - Konsole terminal
  - Kate text editor
  - Dolphin file manager
  - Git, Python, Node.js, Java
  
## App Installation

- **Flatpak Apps**: Use KDE Discover or `flatpak install flathub <app-id>`
- **APT Packages**: Use `sudo apt install <package>` 
- **Snap Apps**: Use `sudo snap install <app>`

## Pre-installed Flatpak Apps

- Blender (3D modeling)
- Filezilla (FTP client)
- Unity Hub (game development)

## Container-Safe Applications

All GUI applications are configured with appropriate flags for container usage:
- VS Code: `--no-sandbox --disable-dev-shm-usage`
- Chrome: `--no-sandbox --disable-dev-shm-usage`

## Credential Storage

- **KWallet**: KDE's secure credential storage
- **Auto-configured**: No password required for basic usage
- **Integration**: Works with browsers and applications
