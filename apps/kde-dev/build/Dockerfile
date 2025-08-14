# syntax=docker/dockerfile:1.4
ARG BASE_APP_IMAGE

# hadolint ignore=DL3006
FROM ${BASE_APP_IMAGE}

ARG DEBIAN_FRONTEND=noninteractive

# Core KDE and essential packages
ARG CORE_PACKAGES=" \
    kde-plasma-desktop \
    plasma-workspace \
    plasma-nm \
    kde-config-gtk-style \
    breeze-gtk-theme \
    konsole \
    dolphin \
    kate \
    firefox \
    dbus-x11 \
    sudo \
    flatpak \
    snapd \
    gnome-keyring \
    libsecret-1-0 \
    libsecret-tools \
    kwallet-kf5 \
    kwalletmanager \
    "

# Development tools that integrate well with KDE
ARG DEV_PACKAGES=" \
    git \
    vim \
    curl \
    wget \
    build-essential \
    python3 \
    python3-pip \
    python3-venv \
    nodejs \
    npm \
    default-jdk \
    ca-certificates \
    software-properties-common \
    "

# Prevent firefox snap
COPY scripts/ff-unsnap /etc/apt/preferences.d/ff-unsnap

RUN \
    # Setup repositories \
    apt-get update && \
    apt-get install -y --no-install-recommends software-properties-common gpg-agent && \
    # Add Firefox PPA \
    add-apt-repository -y ppa:mozillateam/ppa && \
    # Add Microsoft GPG key and repository for VS Code \
    wget -qO- https://packages.microsoft.com/keys/microsoft.asc | gpg --dearmor > packages.microsoft.gpg && \
    install -o root -g root -m 644 packages.microsoft.gpg /etc/apt/trusted.gpg.d/ && \
    echo "deb [arch=amd64,arm64,armhf signed-by=/etc/apt/trusted.gpg.d/packages.microsoft.gpg] https://packages.microsoft.com/repos/code stable main" > /etc/apt/sources.list.d/vscode.list && \
    # Add Google Chrome repository \
    wget -q -O - https://dl.google.com/linux/linux_signing_key.pub | gpg --dearmor -o /usr/share/keyrings/googlechrome-keyring.gpg && \
    echo "deb [arch=amd64 signed-by=/usr/share/keyrings/googlechrome-keyring.gpg] https://dl.google.com/linux/chrome/deb/ stable main" > /etc/apt/sources.list.d/google-chrome.list && \
    # Update package lists \
    apt-get update && \
    # Install core packages \
    apt-get install -y --no-install-recommends $CORE_PACKAGES $DEV_PACKAGES && \
    # Install VS Code and Chrome \
    apt-get install -y --no-install-recommends code google-chrome-stable && \
    # Clean up repository tools \
    apt-get remove -y software-properties-common gpg-agent && \
    apt-get autoremove -y && \
    apt-get clean && \
    rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/* packages.microsoft.gpg

# Setup Flatpak for easy app installation
RUN \
    flatpak remote-add --if-not-exists flathub https://flathub.org/repo/flathub.flatpakrepo && \
    # Pre-install some useful Flatpak apps \
    flatpak install -y flathub org.blender.Blender && \
    flatpak install -y flathub org.filezillaproject.Filezilla && \
    flatpak install -y flathub com.unity.UnityHub && \
    # Clean up \
    flatpak uninstall --unused -y || true

# Setup user and permissions
RUN \
    # Ensure retro user exists \
    id retro || useradd -m -s /bin/bash retro && \
    # Create essential directories \
    mkdir -p /opt/gow/scripts /etc/xdg/autostart && \
    # Allow retro user sudo access for installing packages \
    echo "retro ALL=(ALL) NOPASSWD: ALL" >> /etc/sudoers && \
    echo "ALL ALL=NOPASSWD: /opt/gow/startdbus" >> /etc/sudoers && \
    # Fix flatpak permissions \
    chmod u+s /usr/bin/bwrap

# Copy scripts and configs
COPY --chmod=755 scripts/launch-comp.sh /opt/gow/launch-comp.sh
COPY --chmod=755 scripts/startup.sh /opt/gow/startup-app.sh
COPY --chmod=755 scripts/startdbus.sh /opt/gow/startdbus
COPY --chmod=755 scripts/setup-desktop.sh /opt/gow/scripts/setup-desktop.sh
COPY --chmod=644 configs/plasma-config /opt/gow/configs/plasma-config
COPY scripts/locale /etc/default/locale

# Set proper ownership
RUN chown -R retro:retro /opt/gow

# Wolf-compatible environment
ENV XDG_RUNTIME_DIR=/tmp/user/1000
ENV DESKTOP_SESSION=plasma
ENV XDG_CURRENT_DESKTOP=KDE
ENV KDE_FULL_SESSION=true

ARG IMAGE_SOURCE
LABEL org.opencontainers.image.source=$IMAGE_SOURCE
LABEL org.opencontainers.image.title="KDE Development Desktop with App Store"
LABEL org.opencontainers.image.description="KDE Plasma desktop with Flatpak app store, VS Code, Chrome, and development tools"
