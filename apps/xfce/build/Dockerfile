# syntax=docker/dockerfile:1.4
ARG BASE_APP_IMAGE

# hadolint ignore=DL3006
FROM ${BASE_APP_IMAGE}

# Debug: Check what users exist in base image
RUN echo "=== Base Image Debug Info ===" && \
    echo "Users in base image:" && \
    cat /etc/passwd && \
    echo "Groups in base image:" && \
    cat /etc/group && \
    echo "==# Install development version managers and tools
RUN 
    # Install NVM (Node Version Manager) 
    curl -o- https://raw.githubusercontent.com/nvm-sh/nvm/v0.39.0/install.sh | bash && 
    # Install Pyenv (Python Version Manager) 
    git clone https://github.com/pyenv/pyenv.git /opt/pyenv && 
    # Install SDKMAN (Java/Scala/Kotlin Version Manager) 
    curl -s "https://get.sdkman.io" | bash && 
    # Install Rustup (Rust toolchain installer) 
    curl --proto '=https' --tlsv1.2 -sSf https://sh.rustup.rs | sh -s -- -y && 
    # Install Snap (if not already available) 
    (apt-get install -y snapd || echo "Snap already available") && 
    # Install Flatpak applications 
    flatpak remote-add --if-not-exists flathub https://flathub.org/repo/flathub.flatpakrepo========"

ARG CORE_PACKAGES=" \
    lsb-release \
    wget \
    curl \
    gnupg2 \
    dbus-x11 \
    firefox \
    flatpak \
    sudo \
    software-properties-common \
    apt-transport-https \
    ca-certificates \
    gdebi-core \
    gnome-keyring \
    libsecret-1-0 \
    seahorse \
    "

ARG DE_PACKAGES=" \
    xfce4 \
    xfce4-settings \
    xubuntu-default-settings \
    xubuntu-icon-theme \
    papirus-icon-theme arc-theme \
    at-spi2-core \
    thunar \
    thunar-volman \
    thunar-archive-plugin \
    thunar-media-tags-plugin \
    "

ARG ADDITIONAL_PACKAGES=" \
    xfce4-terminal \
    xfce4-taskmanager \
    xfce4-whiskermenu-plugin \
    xfce4-docklike-plugin \
    xfce4-panel-profiles \
    xfce4-places-plugin \
    xarchiver \
    mousepad \
    zip unzip p7zip-full \
    gnome-software gnome-software-plugin-flatpak \
    file-roller \
    gvfs \
    gvfs-backends \
    gvfs-fuse \
    ntfs-3g \
    exfat-fuse \
    fuse \
    git \
    git-lfs \
    vim \
    nano \
    htop \
    tree \
    neofetch \
    curl \
    wget \
    ssh \
    rsync \
    jq \
    yq \
    screen \
    tmux \
    zsh \
    fish \
    bat \
    eza \
    ripgrep \
    fd-find \
    fzf \
    tldr \
    duf \
    ncdu \
    lsof \
    net-tools \
    iputils-ping \
    traceroute \
    nmap \
    wireshark \
    filezilla \
    remmina \
    meld \
    gimp \
    inkscape \
    blender \
    obs-studio \
    vlc \
    audacity \
    keepassxc \
    thunderbird \
    libreoffice \
    "

ARG DEV_PACKAGES=" \
    build-essential \
    cmake \
    python3 \
    python3-pip \
    python3-venv \
    nodejs \
    npm \
    yarn \
    default-jdk \
    openjdk-17-jdk \
    maven \
    gradle \
    mono-complete \
    dotnet-sdk-8.0 \
    golang-go \
    rustc \
    cargo \
    php \
    composer \
    ruby \
    ruby-dev \
    libnss3-dev \
    libatk-bridge2.0-dev \
    libdrm2 \
    libxkbcommon-dev \
    libxcomposite1 \
    libxdamage1 \
    libxrandr2 \
    libgbm1 \
    libxss1 \
    libasound2t64 \
    libatspi2.0-0 \
    libgtk-3-0 \
    libxshmfence1 \
    "
# 
# Prevent firefox snap
COPY scripts/ff-unsnap /etc/apt/preferences.d/ff-unsnap

RUN \
    # \
    # Setup repositories \
    apt-get update && \
    apt-get install -y --no-install-recommends software-properties-common gpg-agent && \
    # \
    # Add Firefox PPA \
    add-apt-repository -y ppa:mozillateam/ppa && \
    # \
    # Add Microsoft GPG key and repository for VS Code \
    wget -qO- https://packages.microsoft.com/keys/microsoft.asc | gpg --dearmor > packages.microsoft.gpg && \
    install -o root -g root -m 644 packages.microsoft.gpg /etc/apt/trusted.gpg.d/ && \
    echo "deb [arch=amd64,arm64,armhf signed-by=/etc/apt/trusted.gpg.d/packages.microsoft.gpg] https://packages.microsoft.com/repos/code stable main" > /etc/apt/sources.list.d/vscode.list && \
    # \
    # Add Google Chrome repository \
    wget -q -O - https://dl.google.com/linux/linux_signing_key.pub | gpg --dearmor -o /usr/share/keyrings/googlechrome-keyring.gpg && \
    echo "deb [arch=amd64 signed-by=/usr/share/keyrings/googlechrome-keyring.gpg] https://dl.google.com/linux/chrome/deb/ stable main" > /etc/apt/sources.list.d/google-chrome.list && \
    # \
    # Add Microsoft .NET repository \
    wget -qO- https://packages.microsoft.com/config/ubuntu/$(lsb_release -rs)/packages-microsoft-prod.deb -O packages-microsoft-prod.deb && \
    dpkg -i packages-microsoft-prod.deb && \
    rm packages-microsoft-prod.deb && \
    # \
    # Update package lists \
    apt-get update && \
    # \
    # Install core packages \
    apt-get install -y $CORE_PACKAGES && \
    # \
    # Install desktop environment \
    apt-get install -y $DE_PACKAGES

# Install additional packages in separate layer for better caching
RUN apt-get install -y --no-install-recommends $ADDITIONAL_PACKAGES

# Install development packages
RUN apt-get install -y --no-install-recommends \
        build-essential \
        cmake \
        python3 \
        python3-pip \
        nodejs \
        npm \
        default-jdk \
        mono-complete \
        libnss3-dev \
        libatk-bridge2.0-dev \
        libdrm2 \
        libxkbcommon-dev \
        libxcomposite1 \
        libxdamage1 \
        libxrandr2 \
        libgbm1 \
        libxss1 \
        libatspi2.0-0 \
        libgtk-3-0 \
        libxshmfence1 && \
    # Try to install .NET SDK (may fail on some Ubuntu versions) \
    (apt-get install -y dotnet-sdk-8.0 || apt-get install -y dotnet-sdk-6.0 || echo ".NET SDK not available - continuing") && \
    # Try both package names for libasound2 \
    (apt-get install -y libasound2t64 || apt-get install -y libasound2 || echo "Audio library package not found - continuing")

# Install applications
RUN \
    # Install Visual Studio Code \
    apt-get install -y code && \
    # \
    # Install Google Chrome \
    apt-get install -y google-chrome-stable && \
    # \
    # Install Steam \
    dpkg --add-architecture i386 && \
    apt-get update && \
    apt-get install -y steam-installer

# Install Docker and container tools
RUN \
    # Add Docker's official GPG key \
    curl -fsSL https://download.docker.com/linux/ubuntu/gpg | gpg --dearmor -o /usr/share/keyrings/docker-archive-keyring.gpg && \
    # Add Docker repository \
    echo "deb [arch=amd64 signed-by=/usr/share/keyrings/docker-archive-keyring.gpg] https://download.docker.com/linux/ubuntu $(lsb_release -cs) stable" > /etc/apt/sources.list.d/docker.list && \
    # Update package lists \
    apt-get update && \
    # Install Docker CE \
    apt-get install -y docker-ce docker-ce-cli containerd.io docker-buildx-plugin docker-compose-plugin && \
    # Add retro user to docker group \
    usermod -aG docker retro || true

# Install additional development tools
RUN \
    # Install Kubernetes tools \
    curl -LO "https://dl.k8s.io/release/$(curl -L -s https://dl.k8s.io/release/stable.txt)/bin/linux/amd64/kubectl" && \
    chmod +x kubectl && \
    mv kubectl /usr/local/bin/ && \
    # Install Helm \
    curl https://raw.githubusercontent.com/helm/helm/main/scripts/get-helm-3 | bash && \
    # Install Terraform \
    wget -O- https://apt.releases.hashicorp.com/gpg | gpg --dearmor | tee /usr/share/keyrings/hashicorp-archive-keyring.gpg && \
    echo "deb [signed-by=/usr/share/keyrings/hashicorp-archive-keyring.gpg] https://apt.releases.hashicorp.com $(lsb_release -cs) main" | tee /etc/apt/sources.list.d/hashicorp.list && \
    apt-get update && \
    apt-get install -y terraform && \
    # Install AWS CLI \
    curl "https://awscli.amazonaws.com/awscli-exe-linux-x86_64.zip" -o "awscliv2.zip" && \
    unzip awscliv2.zip && \
    ./aws/install && \
    rm -rf aws awscliv2.zip && \
    # Install Azure CLI \
    curl -sL https://aka.ms/InstallAzureCLIDeb | bash && \
    # Install Google Cloud CLI \
    curl https://packages.cloud.google.com/apt/doc/apt-key.gpg | gpg --dearmor -o /usr/share/keyrings/cloud.google.gpg && \
    echo "deb [signed-by=/usr/share/keyrings/cloud.google.gpg] https://packages.cloud.google.com/apt cloud-sdk main" | tee -a /etc/apt/sources.list.d/google-cloud-sdk.list && \
    apt-get update && \
    apt-get install -y google-cloud-cli

# Install Unity Hub and modern development tools
RUN \
    # Download and install Unity Hub \
    wget -qO unity-hub.AppImage https://public-cdn.cloud.unity3d.com/hub/prod/UnityHub.AppImage && \
    chmod +x unity-hub.AppImage && \
    mv unity-hub.AppImage /opt/unity-hub && \
    # \
    # Install Postman \
    wget -qO postman.tar.gz https://dl.pstmn.io/download/latest/linux64 && \
    tar -xzf postman.tar.gz -C /opt/ && \
    ln -sf /opt/Postman/Postman /usr/local/bin/postman && \
    rm postman.tar.gz && \
    # \
    # Install Discord \
    wget -qO discord.deb "https://discord.com/api/download?platform=linux&format=deb" && \
    apt-get install -y ./discord.deb && \
    rm discord.deb && \
    # \
    # Install Slack \
    wget -qO slack.deb https://downloads.slack-edge.com/releases/linux/4.38.125/prod/x64/slack-desktop-4.38.125-amd64.deb && \
    apt-get install -y ./slack.deb && \
    rm slack.deb && \
    # \
    # Install JetBrains Toolbox \
    wget -qO jetbrains-toolbox.tar.gz https://download.jetbrains.com/toolbox/jetbrains-toolbox-2.4.2.32922.tar.gz && \
    tar -xzf jetbrains-toolbox.tar.gz -C /opt/ && \
    mv /opt/jetbrains-toolbox-* /opt/jetbrains-toolbox && \
    ln -sf /opt/jetbrains-toolbox/jetbrains-toolbox /usr/local/bin/jetbrains-toolbox && \
    rm jetbrains-toolbox.tar.gz && \
    # \
    # Create Unity Hub desktop entry \
    mkdir -p /usr/share/applications && \
    echo '[Desktop Entry]\n\
Name=Unity Hub\n\
Comment=Unity development environment\n\
Exec=/opt/unity-hub\n\
Icon=unity-hub\n\
Terminal=false\n\
Type=Application\n\
Categories=Development;' > /usr/share/applications/unity-hub.desktop && \
    # \
    # Create Postman desktop entry \
    echo '[Desktop Entry]\n\
Name=Postman\n\
Comment=API Development Environment\n\
Exec=/usr/local/bin/postman\n\
Icon=postman\n\
Terminal=false\n\
Type=Application\n\
Categories=Development;' > /usr/share/applications/postman.desktop && \
    # \
    # Create JetBrains Toolbox desktop entry \
    echo '[Desktop Entry]\n\
Name=JetBrains Toolbox\n\
Comment=JetBrains IDE Manager\n\
Exec=/usr/local/bin/jetbrains-toolbox\n\
Icon=jetbrains-toolbox\n\
Terminal=false\n\
Type=Application\n\
Categories=Development;' > /usr/share/applications/jetbrains-toolbox.desktop && \
    # \
    # Download Unity Hub icon (allow failure) \
    wget -qO /usr/share/pixmaps/unity-hub.png https://unity.com/favicon.ico || echo "Icon download failed"

# Install version managers and package managers (as root, then switch to retro)
RUN \
    # Install NVM (Node Version Manager) \
    curl -o- https://raw.githubusercontent.com/nvm-sh/nvm/v0.39.0/install.sh | bash && \
    # Install Pyenv (Python Version Manager) \
    git clone https://github.com/pyenv/pyenv.git /opt/pyenv && \
    # Install SDKMAN (Java/Scala/Kotlin Version Manager) \
    curl -s "https://get.sdkman.io" | bash && \
    # Install Rustup (Rust toolchain installer) \
    curl --proto '=https' --tlsv1.2 -sSf https://sh.rustup.rs | sh -s -- -y && \
    # Install Oh My Zsh \
    sh -c "$(curl -fsSL https://raw.github.com/ohmyzsh/ohmyzsh/master/tools/install.sh)" "" --unattended && \
    # Install Homebrew (Linux) \
    /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)" && \
    # Install Snap (if not already available) \
    (apt-get install -y snapd || echo "Snap already available") && \
    # Install Flatpak applications \
    flatpak remote-add --if-not-exists flathub https://flathub.org/repo/flathub.flatpakrepo

# Setup user and groups (simplified approach)
RUN \
    # Ensure retro user exists (create if needed) \
    id retro || useradd -m -s /bin/bash retro && \
    # Ensure fuse group exists \
    getent group fuse || groupadd fuse && \
    # Add user to group \
    usermod -a -G fuse retro || true

# Setup directories
RUN \
    # Set up Wolf directories with proper permissions \
    mkdir -p /mnt/Wolf/Projects /mnt/Wolf/Unity /mnt/Wolf/Steam /mnt/Wolf/VSCode /mnt/Wolf/Downloads /mnt/Wolf/Documents && \
    mkdir -p /home/retro/Projects /home/retro/Unity /home/retro/Downloads /home/retro/Documents && \
    mkdir -p /shared/projects /shared/unity /shared/downloads /shared/documents && \
    mkdir -p /opt/gow/scripts

# Setup symlinks and permissions
RUN \
    # Ensure retro user exists before setting permissions \
    id retro || useradd -m -s /bin/bash retro && \
    # Create symlinks to Wolf directories (remove existing first if they exist) \
    rm -rf /home/retro/Projects /home/retro/Unity /home/retro/Downloads /home/retro/Documents && \
    ln -sf /mnt/Wolf/Projects /home/retro/Projects && \
    ln -sf /mnt/Wolf/Unity /home/retro/Unity && \
    ln -sf /mnt/Wolf/Downloads /home/retro/Downloads && \
    ln -sf /mnt/Wolf/Documents /home/retro/Documents && \
    # Set permissions (with fallback) \
    chown -R retro:retro /mnt/Wolf 2>/dev/null || true && \
    chown -R retro:retro /home/retro 2>/dev/null || true && \
    chown -R retro:retro /shared 2>/dev/null || true

# Cleanup
RUN \
    # Fixes \
    rm -f /etc/xdg/autostart/xscreensaver.desktop && \
    # \
    # Clean up \
    apt-get remove -y foot software-properties-common gpg-agent && \
    apt-get autoremove -y && \
    apt-get clean && \
    rm -rf \
        /config/.cache \
        /var/lib/apt/lists/* \
        /var/tmp/* \
        /tmp/* \
        packages.microsoft.gpg

# 
# Replace launch scripts
COPY --chmod=777 scripts/launch-comp.sh /opt/gow/launch-comp.sh
COPY --chmod=777 scripts/startup.sh /opt/gow/startup-app.sh
COPY --chmod=777 scripts/startdbus.sh /opt/gow/startdbus
COPY --chmod=755 scripts/root-shell.sh /usr/local/bin/root-shell
COPY --chmod=755 scripts/create-desktop-shortcuts.sh /opt/gow/scripts/create-desktop-shortcuts.sh
COPY --chmod=755 scripts/keyring-session-init.sh /opt/gow/scripts/keyring-session-init.sh

# Copy autostart configuration
COPY --chmod=644 configs/autostart/keyring-session-init.desktop /etc/xdg/autostart/keyring-session-init.desktop

# 
# Replace launch scripts
COPY --chmod=777 scripts/launch-comp.sh /opt/gow/launch-comp.sh
COPY --chmod=777 scripts/startup.sh /opt/gow/startup-app.sh
COPY --chmod=777 scripts/startdbus.sh /opt/gow/startdbus
COPY --chmod=755 scripts/root-shell.sh /usr/local/bin/root-shell

#
# Include default xfce config
COPY --chmod=777 scripts/xfce4 /opt/gow/xfce4

# Fix ownership after copy
RUN chown -R retro:retro /opt/gow/xfce4 2>/dev/null || true

# 
# Fix locals
COPY scripts/locale /etc/default/locale

# 
# Allow retro user full sudo access without password
RUN echo "\nretro ALL=(ALL) NOPASSWD: ALL" >> /etc/sudoers && \
    echo "\nALL ALL=NOPASSWD: /opt/gow/startdbus" >> /etc/sudoers

# 
# Fix bwarp perms for flatpaks
RUN chmod u+s /usr/bin/bwrap

ENV XDG_RUNTIME_DIR=/tmp/.X11-unix

# Enhanced XFCE Development Environment - Build $(date +%Y%m%d)
# Includes Unity Hub, VS Code, Chrome, Steam, and development tools

ARG IMAGE_SOURCE
LABEL org.opencontainers.image.source=$IMAGE_SOURCE
LABEL org.opencontainers.image.title="Enhanced XFCE Development Environment"
LABEL org.opencontainers.image.description="XFCE desktop with Unity Hub, VS Code, Chrome, Steam, and development tools"
