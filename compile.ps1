$buildDir = "build"
$installDir = "katecopilot-install"

# Clean previous build
if (Test-Path $buildDir) {
    Write-Host "Removing existing '$buildDir' folder..."
    Remove-Item -Recurse -Force $buildDir
}

New-Item -ItemType Directory -Path $buildDir | Out-Null
Push-Location $buildDir

# Auto-detect ECM path
$ecmConfig = Get-ChildItem -Path "C:\CraftRoot" -Filter ECMConfig.cmake -Recurse -ErrorAction SilentlyContinue | Select-Object -First 1

if (-not $ecmConfig) {
    Write-Error "ECMConfig.cmake not found under C:\CraftRoot. Is ECM installed?"
    Pop-Location
    exit 1
}

# Set CMAKE_PREFIX_PATH to the parent of /share/ECM/cmake
$ecmPrefix = Split-Path -Path $ecmConfig.Directory.Parent.FullName
Write-Host "Using ECM path: $ecmPrefix"

$env:CMAKE_PREFIX_PATH = "$ecmPrefix;$env:CMAKE_PREFIX_PATH"

# Run CMake
cmake .. `
    -G "MinGW Makefiles" `
    -DCMAKE_BUILD_TYPE=Release `
    -DCMAKE_INSTALL_PREFIX="$PWD\..\$installDir"

if ($LASTEXITCODE -ne 0) {
    Write-Error "CMake configuration failed"
    Pop-Location
    exit 1
}

# Build and install
cmake --build . --target install
if ($LASTEXITCODE -ne 0) {
    Write-Error "Build failed"
    Pop-Location
    exit 1
}

Pop-Location
Write-Host "Build complete."
