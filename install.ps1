Write-Host "=== Installing FridayLang ===" -ForegroundColor Green

# Check for CMake
if (-not (Get-Command "cmake" -ErrorAction SilentlyContinue)) {
    Write-Error "Error: cmake is required but not installed."
    Exit 1
}

# Create build directory and compile
Write-Host "Configuring and building..." -ForegroundColor Cyan
New-Item -ItemType Directory -Force -Path "build" | Out-Null
cmake -B build -DCMAKE_BUILD_TYPE=Release
cmake --build build --config Release

Write-Host "=== FridayLang Build Successful! ===" -ForegroundColor Green
Write-Host "The binary is compiled at: build\Release\friday.exe" -ForegroundColor Green
Write-Host "Please copy it to your custom Path directory to run 'friday' globally." -ForegroundColor Cyan
