# syntax=docker/dockerfile:1.4
ARG BASE_APP_IMAGE

# hadolint ignore=DL3006
FROM ${BASE_APP_IMAGE}

# Essential packages for XFCE desktop with VS Code, Chrome, and keyring support
ARG CORE_PACKAGES=" \
    dbus-x11 \
    firefox \
    flatpak \
    sudo \
    gnome-keyring \
    libsecret-1-0 \
    libsecret-tools \
    seahorse \
    "

ARG DE_PACKAGES=" \
    xfce4 \
    xfce4-settings \
    xubuntu-default-settings \
    xubuntu-icon-theme \
    thunar \
    thunar-volman \
    "

ARG ADDITIONAL_PACKAGES=" \
    xfce4-terminal \
    xfce4-taskmanager \
    mousepad \
    file-roller \
    git \
    vim \
    curl \
    wget \
    blender \
    filezilla \
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
    # Install packages \
    apt-get install -y --no-install-recommends $CORE_PACKAGES $DE_PACKAGES $ADDITIONAL_PACKAGES && \
    # Install VS Code and Chrome \
    apt-get install -y --no-install-recommends code google-chrome-stable && \
    # Clean up \
    apt-get remove -y software-properties-common gpg-agent && \
    apt-get autoremove -y && \
    apt-get clean && \
    rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/* packages.microsoft.gpg

# Install Docker in a separate layer for better caching
RUN \
    # Add Docker's official GPG key \
    curl -fsSL https://download.docker.com/linux/ubuntu/gpg | gpg --dearmor -o /usr/share/keyrings/docker-archive-keyring.gpg && \
    # Add Docker repository \
    echo "deb [arch=amd64 signed-by=/usr/share/keyrings/docker-archive-keyring.gpg] https://download.docker.com/linux/ubuntu $(lsb_release -cs) stable" > /etc/apt/sources.list.d/docker.list && \
    # Update package lists \
    apt-get update && \
    # Install Docker CE \
    apt-get install -y docker-ce docker-ce-cli containerd.io docker-buildx-plugin docker-compose-plugin && \
    # Clean up \
    apt-get clean && \
    rm -rf /var/lib/apt/lists/*

# Install Unity Hub
RUN \
    # Download and install Unity Hub \
    wget -qO unity-hub.AppImage https://public-cdn.cloud.unity3d.com/hub/prod/UnityHub.AppImage && \
    chmod +x unity-hub.AppImage && \
    mv unity-hub.AppImage /opt/unity-hub && \
    # Create Unity Hub desktop entry \
    mkdir -p /usr/share/applications && \
    echo '[Desktop Entry]\n\
Name=Unity Hub\n\
Comment=Unity development environment\n\
Exec=/opt/unity-hub --no-sandbox\n\
Icon=unity-hub\n\
Terminal=false\n\
Type=Application\n\
Categories=Development;' > /usr/share/applications/unity-hub.desktop

# Setup directories and permissions
RUN \
    # Ensure retro user exists \
    id retro || useradd -m -s /bin/bash retro && \
    # Add retro user to docker group \
    usermod -aG docker retro && \
    # Create essential directories \
    mkdir -p /opt/gow/scripts /etc/xdg/autostart && \
    # Allow retro user sudo access \
    echo "retro ALL=(ALL) NOPASSWD: ALL" >> /etc/sudoers && \
    echo "ALL ALL=NOPASSWD: /opt/gow/startdbus" >> /etc/sudoers && \
    # Fix bwrap permissions for flatpaks \
    chmod u+s /usr/bin/bwrap

# Copy scripts and configs
COPY --chmod=755 scripts/launch-comp.sh /opt/gow/launch-comp.sh
COPY --chmod=755 scripts/startup.sh /opt/gow/startup-app.sh
COPY --chmod=755 scripts/startdbus.sh /opt/gow/startdbus
COPY --chmod=755 scripts/create-desktop-shortcuts.sh /opt/gow/scripts/create-desktop-shortcuts.sh
COPY --chmod=755 scripts/keyring-session-init.sh /opt/gow/scripts/keyring-session-init.sh
COPY --chmod=755 scripts/test-keyring.sh /opt/gow/scripts/test-keyring.sh
COPY --chmod=644 configs/autostart/keyring-session-init.desktop /etc/xdg/autostart/keyring-session-init.desktop
COPY --chmod=755 scripts/xfce4 /opt/gow/xfce4
COPY scripts/locale /etc/default/locale

# Set proper ownership
RUN chown -R retro:retro /opt/gow

# Wolf-compatible environment
ENV XDG_RUNTIME_DIR=/tmp/user/1000
ENV DESKTOP_SESSION=xfce
ENV XDG_CURRENT_DESKTOP=XFCE

ARG IMAGE_SOURCE
LABEL org.opencontainers.image.source=$IMAGE_SOURCE
LABEL org.opencontainers.image.title="XFCE Development Desktop with Essential Tools"
LABEL org.opencontainers.image.description="XFCE desktop with VS Code, Chrome, Docker, Unity Hub, Blender, Filezilla, and keyring support"
