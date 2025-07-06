#!/usr/bin/env bash

set -e

buildDir="build"
installDir="katecopilot-install"

# Add CraftRoot/bin to PATH for tools like msgmerge, msgfmt, etc.
export PATH="$HOME/CraftRoot/bin:$PATH"

# Clean previous build
if [ -d "$buildDir" ]; then
    echo "Removing existing '$buildDir' folder..."
    rm -rf "$buildDir"
fi

mkdir "$buildDir"
pushd "$buildDir" > /dev/null

# Auto-detect ECM path (KDE Extra CMake Modules)
ecmConfig=$(find "$HOME/CraftRoot" /opt/craftroot /usr/local "$HOME" -type f -name ECMConfig.cmake 2>/dev/null | head -n 1)
if [ -z "$ecmConfig" ]; then
    echo "ECMConfig.cmake not found. Is ECM installed?" >&2
    popd > /dev/null
    exit 1
fi
ecmPrefix=$(dirname "$(dirname "$(dirname "$ecmConfig")")")
echo "Using ECM path: $ecmPrefix"
export CMAKE_PREFIX_PATH="$ecmPrefix:$CMAKE_PREFIX_PATH"

# Auto-detect Qt6 path
qt6Config=$(find "$HOME/CraftRoot" /opt/craftroot /usr/local "$HOME" -type f -name Qt6Config.cmake 2>/dev/null | head -n 1)
if [ -n "$qt6Config" ]; then
    qt6Prefix=$(dirname "$(dirname "$qt6Config")")
    echo "Using Qt6 path: $qt6Prefix"
    export CMAKE_PREFIX_PATH="$qt6Prefix:$CMAKE_PREFIX_PATH"
else
    echo "Warning: Qt6Config.cmake not found. Qt6 may not be installed, or CMAKE_PREFIX_PATH may be incomplete."
fi

# Auto-detect KF6TextEditor path (try both KF6TextEditorConfig.cmake and kf6texteditor-config.cmake)
kf6TextEditorConfig=$(find "$HOME/CraftRoot" /opt/craftroot /usr/local "$HOME" -type f \( -name KF6TextEditorConfig.cmake -o -name kf6texteditor-config.cmake \) 2>/dev/null | head -n 1)
if [ -n "$kf6TextEditorConfig" ]; then
    kf6TextEditorPrefix=$(dirname "$(dirname "$kf6TextEditorConfig")")
    echo "Using KF6TextEditor path: $kf6TextEditorPrefix"
    export CMAKE_PREFIX_PATH="$kf6TextEditorPrefix:$CMAKE_PREFIX_PATH"
else
    echo "Warning: Neither KF6TextEditorConfig.cmake nor kf6texteditor-config.cmake found. KF6TextEditor may not be installed."
fi

# Use Craft's cmake if available
if [ -x "$HOME/CraftRoot/bin/cmake" ]; then
    CMAKE="$HOME/CraftRoot/bin/cmake"
elif [ -x "$HOME/CraftRoot/dev-utils/bin/cmake" ]; then
    CMAKE="$HOME/CraftRoot/dev-utils/bin/cmake"
else
    CMAKE=$(command -v cmake)
fi

if [ -z "$CMAKE" ]; then
    echo "CMake not found. Please ensure CMake is installed or available in CraftRoot." >&2
    popd > /dev/null
    exit 1
fi

echo "Using CMake: $CMAKE"

# Run CMake
"$CMAKE" .. \
    -G "Unix Makefiles" \
    -DCMAKE_BUILD_TYPE=Release \
    -DCMAKE_INSTALL_PREFIX="$(pwd)/../$installDir"

if [ $? -ne 0 ]; then
    echo "CMake configuration failed" >&2
    popd > /dev/null
    exit 1
fi

# Build and install
"$CMAKE" --build . --target install
if [ $? -ne 0 ]; then
    echo "Build failed" >&2
    popd > /dev/null
    exit 1
fi

popd > /dev/null
echo "Build complete."

# Adjust these variables as needed:
BUILD_DIR="$(pwd)/build"         # Where your .so was built
PLUGIN_NAME="katecopilot.so"
PLUGIN_JSON="CopilotPlugin.json"
PLUGIN_XML="CopilotPlugin.xml"

QTVER="qt6"  # Change to qt6 if needed

PLUGIN_DEST="$HOME/.local/lib/$QTVER/plugins/ktexteditor/"
XML_DEST="$HOME/.local/share/kxmlgui5/kate/"

# Create destination directories if they don't exist
mkdir -p "$PLUGIN_DEST"
mkdir -p "$XML_DEST"

# Copy the plugin and metadata
cp "$BUILD_DIR/$PLUGIN_NAME" "$PLUGIN_DEST"
cp "$BUILD_DIR/$PLUGIN_JSON" "$PLUGIN_DEST" 2>/dev/null || cp "$PLUGIN_JSON" "$PLUGIN_DEST" 2>/dev/null || true
cp "$BUILD_DIR/$PLUGIN_XML" "$XML_DEST" 2>/dev/null || cp "$PLUGIN_XML" "$XML_DEST" 2>/dev/null || true

echo "✅ Copied $PLUGIN_NAME to $PLUGIN_DEST"
echo "✅ Copied $PLUGIN_JSON to $PLUGIN_DEST (if present)"
echo "✅ Copied $PLUGIN_XML to $XML_DEST (if present)"
echo "Restart Kate and enable the plugin if necessary."
