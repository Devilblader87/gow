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

# Install development tools and programming languages
RUN apt-get update && \
    apt-get install -y --no-install-recommends \
        git \
        vim \
        nano \
        build-essential \
        cmake \
        make \
        gdb \
        valgrind \
        clang \
        llvm \
        python3 \
        python3-pip \
        python3-venv \
        nodejs \
        npm \
        yarn \
        openjdk-21-jdk \
        openjdk-11-jdk \
        maven \
        gradle \
        golang-go \
        rustc \
        cargo \
        php \
        composer \
        ruby \
        gem \
        gnome-keyring \
        libsecret-1-0 \
        libsecret-tools \
        && \
    apt-get clean && \
    rm -rf /var/lib/apt/lists/*

# Install gaming and multimedia libraries
RUN apt-get update && \
    apt-get install -y --no-install-recommends \
        mesa-utils \
        vulkan-utils \
        vulkan-tools \
        libvulkan1 \
        mesa-vulkan-drivers \
        libgl1-mesa-dri \
        libglx-mesa0 \
        libegl1-mesa \
        libgbm1 \
        libxss1 \
        libgconf-2-4 \
        libxrandr2 \
        libasound2-dev \
        libpulse-dev \
        libopenal1 \
        libvorbis0a \
        libtheora0 \
        libpng16-16 \
        libjpeg-turbo8 \
        libwebp7 \
        libfreetype6 \
        libfontconfig1 \
        libfribidi0 \
        libharfbuzz0b \
        libsdl2-2.0-0 \
        libsdl2-mixer-2.0-0 \
        libsdl2-image-2.0-0 \
        libsdl2-ttf-2.0-0 \
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

# Install Unity Hub
RUN wget -qO - https://hub.unity3d.com/linux/keys/public | gpg --dearmor | tee /usr/share/keyrings/unityhub-archive-keyring.gpg > /dev/null && \
    echo "deb [signed-by=/usr/share/keyrings/unityhub-archive-keyring.gpg] https://hub.unity3d.com/linux/repos/deb stable main" | tee /etc/apt/sources.list.d/unityhub.list && \
    apt-get update && \
    apt-get install -y --no-install-recommends unityhub && \
    apt-get clean && \
    rm -rf /var/lib/apt/lists/*

# Install Unity Editor dependencies and additional libraries for game development
RUN apt-get update && \
    apt-get install -y --no-install-recommends \
        libgconf-2-4 \
        libxss1 \
        libnss3-dev \
        libgconf2-dev \
        libxrandr2 \
        libasound2-dev \
        libpangocairo-1.0-0 \
        libatk1.0-dev \
        libcairo-gobject2 \
        libgtk-3-dev \
        libgdk-pixbuf2.0-dev \
        libxtst6 \
        libxcomposite1 \
        libxcursor1 \
        libxi6 \
        libxdamage1 \
        libxfixes3 \
        libxrender1 \
        libasound2 \
        libpulse0 \
        libdrm2 \
        libxkbcommon0 \
        libxkbcommon-x11-0 \
        && \
    apt-get clean && \
    rm -rf /var/lib/apt/lists/*

# Install Chrome
RUN wget -q -O - https://dl.google.com/linux/linux_signing_key.pub | gpg --dearmor -o /usr/share/keyrings/googlechrome-keyring.gpg && \
    echo "deb [arch=amd64 signed-by=/usr/share/keyrings/googlechrome-keyring.gpg] https://dl.google.com/linux/chrome/deb/ stable main" > /etc/apt/sources.list.d/google-chrome.list && \
    apt-get update && \
    apt-get install -y --no-install-recommends google-chrome-stable && \
    apt-get clean && \
    rm -rf /var/lib/apt/lists/*

# Install game development and design tools
RUN apt-get update && \
    apt-get install -y --no-install-recommends \
        blender \
        gimp \
        inkscape \
        kdenlive \
        audacity \
        obs-studio \
        wine \
        winetricks \
        gamemode \
        mangohud \
        steam-installer \
        && \
    apt-get clean && \
    rm -rf /var/lib/apt/lists/*

# Install additional development tools
RUN apt-get update && \
    apt-get install -y --no-install-recommends \
        qtcreator \
        qtbase5-dev \
        qttools5-dev \
        qttools5-dev-tools \
        android-tools-adb \
        android-tools-fastboot \
        filezilla \
        wireshark \
        && \
    apt-get clean && \
    rm -rf /var/lib/apt/lists/*

# Prevent firefox snap (after package installation)
COPY scripts/ff-unsnap /etc/apt/preferences.d/ff-unsnap

# Setup Flatpak for easy app installation (apps will be installed at runtime)
RUN apt-get update && \
    apt-get install -y --no-install-recommends flatpak && \
    flatpak remote-add --if-not-exists flathub https://flathub.org/repo/flathub.flatpakrepo && \
    apt-get clean && \
    rm -rf /var/lib/apt/lists/*

# Install Docker CE for container development
RUN curl -fsSL https://download.docker.com/linux/ubuntu/gpg | gpg --dearmor -o /usr/share/keyrings/docker-archive-keyring.gpg && \
    echo "deb [arch=amd64 signed-by=/usr/share/keyrings/docker-archive-keyring.gpg] https://download.docker.com/linux/ubuntu jammy stable" > /etc/apt/sources.list.d/docker.list && \
    apt-get update && \
    apt-get install -y --no-install-recommends docker-ce docker-ce-cli containerd.io docker-compose-plugin && \
    apt-get clean && \
    rm -rf /var/lib/apt/lists/*

# Note: Snap support not included due to container limitations
# Apps can be installed via Flatpak or apt instead

# Setup user and permissions
RUN \
    # Ensure retro user exists \
    id retro || useradd -m -s /bin/bash retro && \
    # Add retro user to important groups \
    usermod -aG docker,audio,video,input,plugdev,netdev,sudo retro && \
    # Create essential directories \
    mkdir -p /opt/gow/scripts /etc/xdg/autostart /home/retro/.config /home/retro/Games /home/retro/Projects && \
    # Allow retro user sudo access \
    echo "retro ALL=(ALL) NOPASSWD: ALL" >> /etc/sudoers && \
    echo "ALL ALL=NOPASSWD: /opt/gow/startdbus" >> /etc/sudoers && \
    # Fix flatpak permissions if bwrap exists \
    [ -f /usr/bin/bwrap ] && chmod u+s /usr/bin/bwrap || true && \
    # Set up gaming-specific permissions \
    chmod +s /usr/bin/gamemoderun || true

# Copy scripts and configs
COPY --chmod=755 scripts/launch-comp.sh /opt/gow/launch-comp.sh
COPY --chmod=755 scripts/startup.sh /opt/gow/startup-app.sh
COPY --chmod=755 scripts/startdbus.sh /opt/gow/startdbus
COPY --chmod=755 scripts/setup-desktop.sh /opt/gow/scripts/setup-desktop.sh
COPY --chmod=755 scripts/setup-gaming.sh /opt/gow/scripts/setup-gaming.sh
COPY --chmod=644 configs/plasma-config /opt/gow/configs/plasma-config
COPY scripts/locale /etc/default/locale

# Wolf-compatible environment
ENV XDG_RUNTIME_DIR=/tmp/user/1000
ENV DESKTOP_SESSION=plasma
ENV XDG_CURRENT_DESKTOP=KDE
ENV KDE_FULL_SESSION=true

ARG IMAGE_SOURCE
LABEL org.opencontainers.image.source=$IMAGE_SOURCE
LABEL org.opencontainers.image.title="KDE Gaming & Development Desktop"
LABEL org.opencontainers.image.description="Complete KDE Plasma desktop with gaming platforms (Steam, Lutris, Heroic), game development tools (Unity, Godot, Blender), full development stack (VS Code, Docker, multiple SDKs), and productivity applications"
