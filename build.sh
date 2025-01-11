#!/bin/sh

# Configuration
BUNDLE_ID="com.github.theherk.neovideproject"
APP_NAME="NeovideProject"
VERSION="1.0.0"
ARCH=${ARCH:-x86_64}

# Set target triple based on architecture
case $ARCH in
"x86_64")
	TARGET="x86_64-apple-macosx10.15"
	;;
"arm64")
	TARGET="arm64-apple-macosx11.0"
	;;
*)
	echo "Unsupported architecture: $ARCH"
	exit 1
	;;
esac

# Clean and create build directory structure
rm -rf "build"
mkdir -p "build/$APP_NAME.app/Contents/MacOS"
mkdir -p "build/$APP_NAME.app/Contents/Resources"

# Copy and update Info.plist with correct bundle ID
sed "s/com\.neovide\.project/$BUNDLE_ID/g" "src/Contents/Info.plist" >"build/$APP_NAME.app/Contents/Info.plist"

# Compile Swift launcher
swiftc "src/Contents/MacOS/neovide-project-launcher.swift" \
	-target $TARGET \
	-o "build/$APP_NAME.app/Contents/MacOS/neovide-project-launcher"

# Copy resources
cp "src/Contents/Resources/neovide-project" "build/$APP_NAME.app/Contents/Resources/"
cp "src/Contents/Resources/neovide.icns" "build/$APP_NAME.app/Contents/Resources/"
chmod +x "build/$APP_NAME.app/Contents/Resources/neovide-project"

# Verify architecture of built binary
echo "Verifying binary architecture..."
file "build/$APP_NAME.app/Contents/MacOS/$APP_NAME"

echo "Building DMG..."
hdiutil create -volname "$APP_NAME" -srcfolder "build/$APP_NAME.app" -ov -format UDZO "build/$APP_NAME.dmg"

echo "Build complete for $ARCH architecture:"
echo "  - build/$APP_NAME.app"
echo "  - build/$APP_NAME.dmg"
