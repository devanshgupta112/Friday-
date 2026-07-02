#!/usr/bin/env bash
set -e

echo "=== Installing FridayLang ==="

# Check for CMake
if ! command -v cmake &> /dev/null; then
    echo "Error: cmake is required but not installed."
    exit 1
fi

# Create build directory and compile
echo "Configuring and building..."
mkdir -p build
cmake -B build -DCMAKE_BUILD_TYPE=Release
cmake --build build --config Release

# Copy binary to global path
echo "Installing binary to /usr/local/bin/friday..."
if [ -w /usr/local/bin ]; then
    cp build/friday /usr/local/bin/friday
else
    echo "Requires administrator privileges to copy to /usr/local/bin/friday."
    sudo cp build/friday /usr/local/bin/friday
fi

echo "=== FridayLang Installation Successful! ==="
echo "You can now run FridayLang scripts using: friday <script.fry>"
