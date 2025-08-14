#!/bin/bash

# Wolf-Compatible XFCE Build Script
# This creates a minimal, working XFCE container for Wolf

set -e

echo "🐺 Building Wolf-Compatible XFCE Container..."
echo "============================================="

# Colors
GREEN='\033[0;32m'
BLUE='\033[0;34m'
RED='\033[0;31m'
NC='\033[0m' # No Color

# Check if Docker is available
if ! command -v docker &> /dev/null; then
    echo -e "${RED}❌ Docker is not installed or not in PATH${NC}"
    exit 1
fi

# Check if Docker daemon is running
if ! docker info &> /dev/null; then
    echo -e "${RED}❌ Docker daemon is not running${NC}"
    exit 1
fi

# Navigate to the xfce build directory
cd "$(dirname "$0")/apps/xfce"

echo -e "${BLUE}📦 Building minimal XFCE container for Wolf...${NC}"

# Build the container using the minimal Dockerfile
docker build \
    --build-arg BASE_APP_IMAGE=ghcr.io/games-on-whales/base-app:edge \
    --tag ghcr.io/games-on-whales/xfce:enhanced \
    --file build/Dockerfile.minimal \
    build/

if [ $? -eq 0 ]; then
    echo -e "${GREEN}✅ Wolf-compatible XFCE container built successfully!${NC}"
    echo -e "${GREEN}   Tagged as: ghcr.io/games-on-whales/xfce:enhanced${NC}"
    echo ""
    echo -e "${BLUE}🚀 Next steps:${NC}"
    echo "1. The wolf.config.toml has been fixed and should work now"
    echo "2. Start Wolf and test the 'Enhanced XFCE Desktop' app"
    echo "3. VS Code keyring and Chrome should work properly"
    echo ""
    echo -e "${BLUE}📋 Key fixes applied:${NC}"
    echo "- ✅ Resolved git merge conflicts in wolf.config.toml"
    echo "- ✅ Added required RUN_SWAY=true environment variable"
    echo "- ✅ Simplified container to essential packages only"
    echo "- ✅ Fixed XDG_RUNTIME_DIR setup for Wolf compatibility"
    echo "- ✅ Added proper gnome-keyring initialization"
    echo "- ✅ Created container-safe Chrome and VS Code shortcuts"
else
    echo -e "${RED}❌ Build failed. Check the output above for errors.${NC}"
    exit 1
fi
