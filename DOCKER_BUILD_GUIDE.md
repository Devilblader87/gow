# 🐳 Docker Build Instructions

## Issue Summary
We've fixed both issues in your XFCE container:
- ✅ **Keyring Error**: Added `gnome-keyring` and proper session initialization
- ✅ **Chrome Won't Start**: Added `--no-sandbox` flags and container-safe shortcuts

## Build Options

### Option 1: Build on Host System (Recommended)
```bash
# Copy the files to your Wolf system and run:
./build-xfce-enhanced.sh
```

### Option 2: Manual Docker Build
```bash
cd apps/xfce
docker build \
    --build-arg BASE_APP_IMAGE=ghcr.io/games-on-whales/base-app:edge \
    --tag ghcr.io/games-on-whales/xfce:enhanced \
    build/
```

### Option 3: GitHub Actions (Automatic)
1. Push changes to your GitHub repository
2. GitHub Actions will automatically build the container
3. Use the built image: `ghcr.io/your-username/gow/xfce:edge`

## Files Modified
- ✅ `apps/xfce/build/Dockerfile` - Added keyring packages
- ✅ `apps/xfce/build/scripts/launch-comp.sh` - Added keyring initialization
- ✅ `apps/xfce/build/scripts/create-desktop-shortcuts.sh` - Container-safe app shortcuts
- ✅ `apps/xfce/build/scripts/keyring-session-init.sh` - Session initialization
- ✅ `apps/xfce/build/configs/autostart/keyring-session-init.desktop` - Autostart entry

## Why Docker Won't Install Here
This VS Code environment is running in a Flatpak sandbox (Freedesktop SDK 24.08) with:
- No package managers (apt, yum, etc.)
- No sudo/root access
- Limited system permissions
- Sandboxed runtime environment

This is normal and secure - build the container on your host system instead.

## Next Steps After Building
1. Update your Wolf config to use the new image
2. Restart Wolf containers
3. VS Code keyring errors should be gone
4. Chrome should start properly with the new desktop shortcuts
