#!/bin/bash

# Streamlined XFCE Docker Build Script with Keyring Support
# This version removes the bloated packages that were causing crashes

set -e

echo "🐳 Building Streamlined XFCE Desktop Container..."
echo "================================================="

# Colors for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m' # No Color

# Check if Docker is available
if ! command -v docker &> /dev/null; then
    echo -e "${RED}❌ Docker is not installed or not in PATH${NC}"
    echo -e "${YELLOW}Please install Docker first and ensure it's running.${NC}"
    exit 1
fi

# Check if Docker daemon is running
if ! docker info &> /dev/null; then
    echo -e "${RED}❌ Docker daemon is not running${NC}"
    echo -e "${YELLOW}Please start Docker daemon first.${NC}"
    exit 1
fi

# Navigate to the xfce build directory
cd "$(dirname "$0")/apps/xfce"

echo -e "${BLUE}📦 Building streamlined XFCE container with keyring support...${NC}"
echo -e "${YELLOW}ℹ️  This version removes bloated packages that were causing crashes${NC}"

# Build the container
docker build \
    --build-arg BASE_APP_IMAGE=ghcr.io/games-on-whales/base-app:edge \
    --tag ghcr.io/games-on-whales/xfce:enhanced \
    --tag ghcr.io/games-on-whales/xfce:latest \
    --tag local/xfce-enhanced:latest \
    --file build/Dockerfile \
    build/

if [ $? -eq 0 ]; then
    echo -e "${GREEN}✅ XFCE container built successfully!${NC}"
    echo -e "${GREEN}   Tagged as: ghcr.io/games-on-whales/xfce:enhanced${NC}"
    echo -e "${GREEN}   Tagged as: local/xfce-enhanced:latest${NC}"
    echo ""
    echo -e "${BLUE}🧪 Testing keyring functionality...${NC}"
    echo "Run this command to test keyring in the container:"
    echo "docker run --rm -it local/xfce-enhanced:latest /opt/gow/scripts/test-keyring.sh"
    echo ""
    echo -e "${BLUE}🚀 Next steps:${NC}"
    echo "1. Update your Wolf configuration to use: local/xfce-enhanced:latest"
    echo "2. Restart your Wolf containers"
    echo "3. VS Code keyring errors should be resolved!"
    echo "4. Chrome should start properly with --no-sandbox"
else
    echo -e "${RED}❌ Build failed. Check the output above for errors.${NC}"
    exit 1
fi
