#!/bin/bash
# Keyring diagnostic script for testing container functionality

echo "🔐 GNOME Keyring Diagnostic Script"
echo "=================================="

# Check if packages are installed
echo "📦 Checking required packages..."
dpkg -l | grep -E "gnome-keyring|libsecret-1-0|seahorse" || echo "⚠️  Some keyring packages may be missing"

# Check if keyring daemon is available
echo "🔍 Checking keyring daemon availability..."
which gnome-keyring-daemon || echo "❌ gnome-keyring-daemon not found"

# Check XDG_RUNTIME_DIR
echo "📁 Checking XDG_RUNTIME_DIR..."
echo "XDG_RUNTIME_DIR: ${XDG_RUNTIME_DIR:-'Not set'}"
if [ -n "${XDG_RUNTIME_DIR:-}" ] && [ -d "$XDG_RUNTIME_DIR" ]; then
    echo "✅ XDG_RUNTIME_DIR exists and is accessible"
    ls -la "$XDG_RUNTIME_DIR" 2>/dev/null || echo "⚠️  Cannot list XDG_RUNTIME_DIR contents"
else
    echo "❌ XDG_RUNTIME_DIR not properly set"
fi

# Check if keyring is running
echo "🔄 Checking if keyring daemon is running..."
if pgrep -u "$(id -u)" -x gnome-keyring-d >/dev/null 2>&1; then
    echo "✅ GNOME keyring daemon is running"
    echo "SSH_AUTH_SOCK: ${SSH_AUTH_SOCK:-'Not set'}"
else
    echo "❌ GNOME keyring daemon is not running"
fi

# Test keyring functionality
echo "🧪 Testing keyring functionality..."
if command -v secret-tool >/dev/null 2>&1; then
    echo "secret-tool is available for testing"
    # Try to store and retrieve a test secret
    if secret-tool store --label="test" service test username test 2>/dev/null <<< "testpassword"; then
        if retrieved=$(secret-tool lookup service test username test 2>/dev/null); then
            if [ "$retrieved" = "testpassword" ]; then
                echo "✅ Keyring store/retrieve test successful"
            else
                echo "❌ Keyring retrieve returned wrong value"
            fi
        else
            echo "❌ Keyring retrieve failed"
        fi
        # Clean up test secret
        secret-tool clear service test username test 2>/dev/null || true
    else
        echo "❌ Keyring store failed"
    fi
else
    echo "⚠️  secret-tool not available for testing"
fi

echo ""
echo "🏁 Diagnostic complete!"
echo "If you see errors above, the keyring may not be properly initialized."
echo "Try running: /opt/gow/scripts/keyring-session-init.sh"
