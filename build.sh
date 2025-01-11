#!/bin/sh

# Configuration
BUNDLE_ID="com.github.theherk.neovideproject"
APP_NAME="NeovideProject"
VERSION="1.0.0"

# Clean and create build directory structure
rm -rf "build"
mkdir -p "build/$APP_NAME.app/Contents/MacOS"
mkdir -p "build/$APP_NAME.app/Contents/Resources"

# Copy and update Info.plist with correct bundle ID
sed "s/com\.neovide\.project/$BUNDLE_ID/g" "src/Contents/Info.plist" >"build/$APP_NAME.app/Contents/Info.plist"

# Compile Swift launcher
swiftc "src/Contents/MacOS/neovide-project-launcher.swift" -o "build/$APP_NAME.app/Contents/MacOS/neovide-project-launcher"

# Copy resources
cp "src/Contents/Resources/neovide-project" "build/$APP_NAME.app/Contents/Resources/"
cp "src/Contents/Resources/neovide.icns" "build/$APP_NAME.app/Contents/Resources/"
chmod +x "build/$APP_NAME.app/Contents/Resources/neovide-project"

echo "Building DMG..."
hdiutil create -volname "$APP_NAME" -srcfolder "build/$APP_NAME.app" -ov -format UDZO "build/$APP_NAME.dmg"

echo "Build complete: build/$APP_NAME.app and build/$APP_NAME.dmg"
