#!/bin/bash

# Enhanced XFCE Docker Build Script
# This script builds the XFCE container with keyring and Chrome fixes

set -e

echo "🚀 Building Enhanced XFCE Development Container..."
echo "=================================================="

# Colors for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m' # No Color

# Check if Docker is available
if ! command -v docker &> /dev/null; then
    echo -e "${RED}❌ Docker is not installed or not in PATH${NC}"
    echo -e "${YELLOW}Please install Docker first:${NC}"
    echo "  - Ubuntu/Debian: sudo apt install docker.io"
    echo "  - CentOS/RHEL: sudo yum install docker"
    echo "  - Arch Linux: sudo pacman -S docker"
    echo "  - Or visit: https://docs.docker.com/get-docker/"
    exit 1
fi

# Check if Docker daemon is running
if ! docker info &> /dev/null; then
    echo -e "${RED}❌ Docker daemon is not running${NC}"
    echo -e "${YELLOW}Please start Docker first:${NC}"
    echo "  sudo systemctl start docker"
    exit 1
fi

# Navigate to the build directory
cd "$(dirname "$0")/apps/xfce/build"

echo -e "${BLUE}📁 Building from directory: $(pwd)${NC}"
echo -e "${BLUE}📋 Dockerfile contents preview:${NC}"
head -20 Dockerfile

# Build the container
echo -e "${YELLOW}🔨 Building enhanced XFCE container...${NC}"
docker build \
    --build-arg BASE_APP_IMAGE=ghcr.io/games-on-whales/base-app:edge \
    --tag enhanced-xfce:latest \
    --tag enhanced-xfce:$(date +%Y%m%d) \
    .

if [ $? -eq 0 ]; then
    echo -e "${GREEN}✅ Build completed successfully!${NC}"
    echo -e "${GREEN}📦 Image tagged as: enhanced-xfce:latest${NC}"
    echo -e "${BLUE}📊 Image information:${NC}"
    docker images enhanced-xfce:latest
    
    echo -e "${YELLOW}🎯 Next steps:${NC}"
    echo "1. Update your Wolf configuration to use: enhanced-xfce:latest"
    echo "2. The image includes fixes for:"
    echo "   ✅ VS Code keyring error"
    echo "   ✅ Chrome startup issues"
    echo "   ✅ Proper desktop shortcuts"
    echo "   ✅ Session environment initialization"
else
    echo -e "${RED}❌ Build failed!${NC}"
    exit 1
fi
