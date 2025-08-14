# syntax=docker/dockerfile:1.4
ARG BASE_APP_IMAGE

# hadolint ignore=DL3006
FROM ${BASE_APP_IMAGE}

ARG DEBIAN_FRONTEND=noninteractive

# Install essential packages first (minimal approach)
RUN apt-get update && \
    apt-get install -y --no-install-recommends \
        wget \
        curl \
        ca-certificates \
        gnupg \
        sudo \
        dbus-x11 \
        && \
    apt-get clean && \
    rm -rf /var/lib/apt/lists/*

# Install KDE desktop environment
RUN apt-get update && \
    apt-get install -y --no-install-recommends \
        kde-plasma-desktop \
        plasma-workspace \
        konsole \
        dolphin \
        kate \
        firefox \
        kwalletmanager \
        plasma-nm \
        xdg-utils \
        && \
    apt-get clean && \
    rm -rf /var/lib/apt/lists/*

# Install development tools
RUN apt-get update && \
    apt-get install -y --no-install-recommends \
        git \
        vim \
        build-essential \
        python3 \
        python3-pip \
        nodejs \
        npm \
        gnome-keyring \
        libsecret-1-0 \
        libsecret-tools \
        && \
    apt-get clean && \
    rm -rf /var/lib/apt/lists/*

# Install VS Code
RUN wget -qO- https://packages.microsoft.com/keys/microsoft.asc | gpg --dearmor > packages.microsoft.gpg && \
    install -o root -g root -m 644 packages.microsoft.gpg /etc/apt/trusted.gpg.d/ && \
    echo "deb [arch=amd64,arm64,armhf signed-by=/etc/apt/trusted.gpg.d/packages.microsoft.gpg] https://packages.microsoft.com/repos/code stable main" > /etc/apt/sources.list.d/vscode.list && \
    apt-get update && \
    apt-get install -y --no-install-recommends code && \
    apt-get clean && \
    rm -rf /var/lib/apt/lists/* packages.microsoft.gpg

# Install Chrome
RUN wget -q -O - https://dl.google.com/linux/linux_signing_key.pub | gpg --dearmor -o /usr/share/keyrings/googlechrome-keyring.gpg && \
    echo "deb [arch=amd64 signed-by=/usr/share/keyrings/googlechrome-keyring.gpg] https://dl.google.com/linux/chrome/deb/ stable main" > /etc/apt/sources.list.d/google-chrome.list && \
    apt-get update && \
    apt-get install -y --no-install-recommends google-chrome-stable && \
    apt-get clean && \
    rm -rf /var/lib/apt/lists/*

# Prevent firefox snap (after package installation)
COPY scripts/ff-unsnap /etc/apt/preferences.d/ff-unsnap

# Setup Flatpak for easy app installation (basic setup only)
RUN apt-get update && \
    apt-get install -y --no-install-recommends flatpak && \
    flatpak remote-add --if-not-exists flathub https://flathub.org/repo/flathub.flatpakrepo && \
    apt-get clean && \
    rm -rf /var/lib/apt/lists/*

# Setup user and permissions
RUN \
    # Check if retro user exists, if not create it \
    id -u retro >/dev/null 2>&1 || useradd -m -s /bin/bash -u 1000 retro && \
    # Ensure retro user is in sudo group \
    usermod -aG sudo retro && \
    # Create essential directories \
    mkdir -p /opt/gow/scripts /etc/xdg/autostart /home/retro/.config && \
    # Allow retro user sudo access for installing packages \
    echo "retro ALL=(ALL) NOPASSWD: ALL" >> /etc/sudoers && \
    echo "ALL ALL=NOPASSWD: /opt/gow/startdbus" >> /etc/sudoers && \
    # Fix flatpak permissions if bwrap exists \
    [ -f /usr/bin/bwrap ] && chmod u+s /usr/bin/bwrap || true

# Copy scripts and configs
COPY --chmod=755 scripts/launch-comp.sh /opt/gow/launch-comp.sh
COPY --chmod=755 scripts/startup.sh /opt/gow/startup-app.sh
COPY --chmod=755 scripts/startdbus.sh /opt/gow/startdbus
COPY --chmod=755 scripts/setup-desktop.sh /opt/gow/scripts/setup-desktop.sh
COPY --chmod=644 configs/plasma-config /opt/gow/configs/plasma-config
COPY scripts/locale /etc/default/locale

# Set proper ownership (retro user should exist)
RUN chown -R retro:retro /opt/gow && chown -R retro:retro /home/retro

# Wolf-compatible environment
ENV XDG_RUNTIME_DIR=/tmp/user/1000
ENV DESKTOP_SESSION=plasma
ENV XDG_CURRENT_DESKTOP=KDE
ENV KDE_FULL_SESSION=true

ARG IMAGE_SOURCE
LABEL org.opencontainers.image.source=$IMAGE_SOURCE
LABEL org.opencontainers.image.title="KDE Development Desktop with App Store"
LABEL org.opencontainers.image.description="KDE Plasma desktop with Flatpak app store, VS Code, Chrome, and development tools"
