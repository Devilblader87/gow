# GOW (Games on Whales) - AI Coding Instructions

## Project Overview
GOW is a collection of Docker images for running games and apps remotely via [Wolf](https://github.com/games-on-whales/wolf). It provides containerized gaming environments with streaming capabilities, VR support, and desktop environments.

## Architecture

### Core Structure
- **`apps/`** - Individual application containers (Steam, Firefox, Kodi, etc.)
  - Each app has `assets/wolf.config.toml`, `build/Dockerfile`, and optional `scripts/`
  - Wolf config defines app metadata, Docker settings, and runtime requirements
- **`images/`** - Base Docker images (`base`, `base-app`, `base-emu`, `nvidia-driver`, `pulseaudio`)
- **`bin/`** - Build and deployment scripts
- **`website/`** - Hugo-based documentation site that aggregates app configs

### Build System
- **GitHub Actions** automatically builds containers to `ghcr.io/<username>/gow/<image>:edge`
- **`bin/build-toml.sh`** concatenates all `apps/*/assets/wolf.config.toml` into `website/public/apps.toml`
- **Multi-stage builds** common (e.g., Steam's bwrap-builder stage for security patches)

## Key Patterns

### Wolf Configuration Format
```toml
[[apps]]
title = "App Name"
icon_png_path = "https://games-on-whales.github.io/wildlife/apps/app/assets/icon.png"

[apps.runner]
type = "docker"
name = "WolfAppName"
image = "ghcr.io/games-on-whales/app:edge"
env = ["RUN_SWAY=true", "GOW_REQUIRED_DEVICES=/dev/input/* /dev/dri/*"]
mounts = ["app-data:/home/retro/.local/share/app:rw"]
base_create_json = """{"HostConfig": {"IpcMode": "host", "CapAdd": ["SYS_ADMIN"]}}"""
```

### Docker Image Inheritance
1. `ubuntu:25.04` → `base` (adds retro user, gosu, certificates)
2. `base` → `base-app` (adds desktop environment support)
3. `base-app` → app-specific images (Steam, Firefox, etc.)

### Common Environment Variables
- `GOW_REQUIRED_DEVICES` - Device access patterns
- `RUN_SWAY` - Enable Sway compositor
- `PUID/PGID` - User ID mapping for volumes

## Development Workflows

### Adding New Apps
1. Create `apps/new-app/` directory structure
2. Add `assets/wolf.config.toml` with app configuration
3. Create `build/Dockerfile` inheriting from `${BASE_APP_IMAGE}`
4. Add startup scripts in `build/scripts/` if needed
5. Test with `docker build --build-arg BASE_APP_IMAGE=ghcr.io/games-on-whales/base-app:edge`

### VR Applications
- Use `start_virtual_compositor = true` in Wolf config
- Require privileged containers with specific device access
- See `VR_APP_CONFIG.toml` and `apps/vr-steamvr/` for patterns

### Testing Locally
```bash
# Build specific app
cd apps/steam && docker build --build-arg BASE_APP_IMAGE=ghcr.io/games-on-whales/base-app:edge .

# Build website and aggregate configs
bin/build-website.sh

# Build complete development environment
./build-complete.sh
```

### Security Considerations
- Apps often need `CAP_SYS_ADMIN`, `SYS_PTRACE` for sandboxing (Steam, browsers)
- Use `seccomp=unconfined` and `apparmor=unconfined` for compatibility
- Device access via `DeviceCgroupRules` for input/graphics devices
- **Chrome/Electron apps** require `--no-sandbox` flag in containerized environments
- **VS Code/Electron** needs `gnome-keyring` and `libsecret-1-0` for credential storage
- Create proper `XDG_RUNTIME_DIR` and start `gnome-keyring-daemon` for session management

## Integration Points
- **Wolf server** consumes the aggregated `apps.toml` from website build
- **GitHub Container Registry** hosts all built images
- **GStreamer pipeline configs** in root `config.toml` handle video/audio streaming
- **Hugo website** at `games-on-whales.github.io/wildlife/` documents all apps
