Write-Host "=== Installing FridayLang from Release ===" -ForegroundColor Green

$InstallDir = Join-Path $HOME ".friday\bin"
If (-not (Test-Path $InstallDir)) {
    New-Item -ItemType Directory -Force -Path $InstallDir | Out-Null
}

$BinaryPath = Join-Path $InstallDir "friday.exe"
$Url = "https://github.com/devanshgupta112/Friday-/releases/latest/download/friday-windows.exe"

Write-Host "Downloading FridayLang from $Url..." -ForegroundColor Cyan
Invoke-WebRequest -Uri $Url -OutFile $BinaryPath

# Add to user PATH variable
$UserPath = [Environment]::GetEnvironmentVariable("Path", "User")
if ($UserPath -notlike "*\.friday\bin*") {
    $Delimiter = ";"
    if ($UserPath.EndsWith($Delimiter)) {
        $NewPath = $UserPath + $InstallDir
    } else {
        $NewPath = $UserPath + $Delimiter + $InstallDir
    }
    [Environment]::SetEnvironmentVariable("Path", $NewPath, "User")
    Write-Host "Added $InstallDir to user PATH variable." -ForegroundColor Green
    Write-Host "Please restart your PowerShell window to apply changes." -ForegroundColor Cyan
} else {
    Write-Host "$InstallDir is already present in PATH." -ForegroundColor Green
}

Write-Host "=== FridayLang Installation Successful! ===" -ForegroundColor Green
