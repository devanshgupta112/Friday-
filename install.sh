#!/usr/bin/env bash
set -e

echo "=== Installing FridayLang from Release ==="

# Detect OS
OS="$(uname -s)"
if [ "$OS" = "Darwin" ]; then
    BINARY="friday-macos"
elif [ "$OS" = "Linux" ]; then
    BINARY="friday-linux"
else
    echo "Unsupported OS: $OS"
    exit 1
fi

INSTALL_DIR="$HOME/.friday/bin"
mkdir -p "$INSTALL_DIR"

URL="https://github.com/devanshgupta112/Friday-/releases/latest/download/$BINARY"
echo "Downloading binary from $URL..."
curl -fsSL "$URL" -o "$INSTALL_DIR/friday"
chmod +x "$INSTALL_DIR/friday"

# Add to PATH in shell rc file
SHELL_RC=""
if [ -f "$HOME/.zshrc" ]; then
    SHELL_RC="$HOME/.zshrc"
elif [ -f "$HOME/.bashrc" ]; then
    SHELL_RC="$HOME/.bashrc"
elif [ -f "$HOME/.profile" ]; then
    SHELL_RC="$HOME/.profile"
fi

if [ -n "$SHELL_RC" ]; then
    if ! grep -q '\.friday/bin' "$SHELL_RC"; then
        echo -e '\n# FridayLang PATH config\nexport PATH="$HOME/.friday/bin:$PATH"' >> "$SHELL_RC"
        echo "Added $INSTALL_DIR to PATH in $SHELL_RC"
        echo "Please run: source $SHELL_RC to apply changes to current terminal."
    else
        echo "$INSTALL_DIR is already configured in $SHELL_RC"
    fi
else
    echo "Could not auto-detect shell config file."
    echo "Please add the following line manually to your shell rc file:"
    echo 'export PATH="$HOME/.friday/bin:$PATH"'
fi

echo "=== FridayLang Installation Successful! ==="
echo "Run 'friday' to start."
