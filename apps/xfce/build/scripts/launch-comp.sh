#!/bin/bash
set -e

source /opt/gow/bash-lib/utils.sh

function launcher() {
  export XDG_DATA_DIRS=/var/lib/flatpak/exports/share:/home/retro/.local/share/flatpak/exports/share:/usr/local/share/:/usr/share/

  if [ ! -d "$HOME/.config/xfce4" ]; then
    # set default config
    mkdir -p $HOME/.config/xfce4
    cp -r /opt/gow/xfce4/* $HOME/.config/xfce4/
    
    # add flathub repo
    flatpak remote-add --user --if-not-exists flathub https://dl.flathub.org/repo/flathub.flatpakrepo
    # XFCE4 will only run in X11 so we have to disable wayland
    flatpak override --user --nosocket=wayland

    # Create common folders
    mkdir -p ~/Desktop ~/Documents ~/Downloads ~/Music ~/Pictures ~/Public ~/Templates ~/Videos
    chmod 755 ~/Desktop ~/Documents ~/Downloads ~/Music ~/Pictures ~/Public ~/Templates ~/Videos
    
    # Create desktop shortcuts with proper container settings
    if [ -f "/opt/gow/scripts/create-desktop-shortcuts.sh" ]; then
      bash /opt/gow/scripts/create-desktop-shortcuts.sh
    fi
  fi

  #
  # Launch DBUS
  sudo /opt/gow/startdbus

  # Wolf-compatible environment setup
  export DESKTOP_SESSION=xfce
  export XDG_CURRENT_DESKTOP=XFCE
  export XDG_SESSION_TYPE="x11"
  export _JAVA_AWT_WM_NONREPARENTING=1
  export GDK_BACKEND=x11
  export MOZ_ENABLE_WAYLAND=0
  export QT_QPA_PLATFORM="xcb"
  export QT_AUTO_SCREEN_SCALE_FACTOR=1
  export QT_ENABLE_HIGHDPI_SCALING=1
  export DISPLAY=:0
  export $(dbus-launch)
  export REAL_WAYLAND_DISPLAY=$WAYLAND_DISPLAY
  export GTK_THEME=Arc-Dark:dark
  unset WAYLAND_DISPLAY

  # Setup XDG_RUNTIME_DIR for keyring - Wolf compatible
  RUNTIME_DIR="/tmp/user/$(id -u)"
  mkdir -p "$RUNTIME_DIR"
  chmod 700 "/tmp/user" "$RUNTIME_DIR" 2>/dev/null || true
  export XDG_RUNTIME_DIR="$RUNTIME_DIR"

  # Start gnome-keyring for VS Code and other apps
  gow_log "[keyring] Starting GNOME keyring daemon..."
  if ! pgrep -u "$(id -u)" -x gnome-keyring-d >/dev/null 2>&1; then
    eval "$(/usr/bin/gnome-keyring-daemon --start --components=secrets,ssh,pkcs11 --daemonize)"
    if [ -n "${SSH_AUTH_SOCK:-}" ]; then
      export SSH_AUTH_SOCK
      gow_log "[keyring] GNOME keyring started successfully"
    else
      gow_log "[keyring] Warning: GNOME keyring may not have started properly"
    fi
  else
    gow_log "[keyring] GNOME keyring already running"
  fi

  #
  # Start Xwayland and xfce4 - Wolf pattern
  gow_log "[xfce] Starting XFCE desktop environment..."
  dbus-run-session -- bash -E -c "WAYLAND_DISPLAY=\$REAL_WAYLAND_DISPLAY Xwayland :0 & sleep 3 && startxfce4"
}
