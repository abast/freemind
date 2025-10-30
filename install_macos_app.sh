#!/bin/bash

# FreeMind macOS Application Bundle Installer
# This script creates a macOS .app bundle that can be launched like any native application

set -e

echo "Creating FreeMind.app bundle..."

# Get the directory where this script is located
SCRIPT_DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"

# Define app bundle structure
APP_NAME="FreeMind"
APP_BUNDLE="$HOME/Applications/${APP_NAME}.app"
APP_CONTENTS="${APP_BUNDLE}/Contents"
APP_MACOS="${APP_CONTENTS}/MacOS"
APP_RESOURCES="${APP_CONTENTS}/Resources"

# Create directory structure
echo "Creating application bundle structure..."
mkdir -p "${APP_MACOS}"
mkdir -p "${APP_RESOURCES}"

# Create the launcher script
echo "Creating launcher script..."
cat > "${APP_MACOS}/${APP_NAME}" << 'LAUNCHER_EOF'
#!/bin/bash

# Get the directory where FreeMind is installed
FREEMIND_DIR="$HOME/project_src/freemind"

# Check if FreeMind directory exists
if [ ! -d "${FREEMIND_DIR}" ]; then
    osascript -e 'display dialog "FreeMind not found at '"${FREEMIND_DIR}"'\n\nPlease ensure FreeMind is installed at this location." buttons {"OK"} default button "OK" with icon stop with title "FreeMind Error"'
    exit 1
fi

# Check if Java is available
if ! command -v java &> /dev/null; then
    osascript -e 'display dialog "Java is not installed or not found in PATH.\n\nPlease install Java 8 to run FreeMind." buttons {"OK"} default button "OK" with icon stop with title "Java Not Found"'
    exit 1
fi

# Change to FreeMind directory and run
cd "${FREEMIND_DIR}"
exec bash freemind.sh "$@"
LAUNCHER_EOF

# Make the launcher executable
chmod +x "${APP_MACOS}/${APP_NAME}"

# Create Info.plist
echo "Creating Info.plist..."
cat > "${APP_CONTENTS}/Info.plist" << 'PLIST_EOF'
<?xml version="1.0" encoding="UTF-8"?>
<!DOCTYPE plist PUBLIC "-//Apple//DTD PLIST 1.0//EN" "http://www.apple.com/DTDs/PropertyList-1.0.dtd">
<plist version="1.0">
<dict>
    <key>CFBundleExecutable</key>
    <string>FreeMind</string>
    <key>CFBundleIconFile</key>
    <string>FreeMind.icns</string>
    <key>CFBundleIdentifier</key>
    <string>org.freemind.FreeMind</string>
    <key>CFBundleName</key>
    <string>FreeMind</string>
    <key>CFBundlePackageType</key>
    <string>APPL</string>
    <key>CFBundleShortVersionString</key>
    <string>1.0.1</string>
    <key>CFBundleVersion</key>
    <string>1.0.1</string>
    <key>CFBundleSignature</key>
    <string>FMND</string>
    <key>LSMinimumSystemVersion</key>
    <string>10.9</string>
    <key>NSHighResolutionCapable</key>
    <true/>
    <key>CFBundleDocumentTypes</key>
    <array>
        <dict>
            <key>CFBundleTypeExtensions</key>
            <array>
                <string>mm</string>
            </array>
            <key>CFBundleTypeName</key>
            <string>FreeMind Mind Map</string>
            <key>CFBundleTypeRole</key>
            <string>Editor</string>
            <key>LSItemContentTypes</key>
            <array>
                <string>org.freemind.mindmap</string>
            </array>
        </dict>
    </array>
</dict>
</plist>
PLIST_EOF

# Try to extract or create an icon
# For now, we'll create a simple text-based icon placeholder
echo "Setting up application icon..."
# If you have an icon file, copy it here:
# cp /path/to/icon.icns "${APP_RESOURCES}/FreeMind.icns"

echo ""
echo "✓ FreeMind.app has been created at: ${APP_BUNDLE}"
echo ""
echo "You can now:"
echo "  1. Open FreeMind from Spotlight (search for 'FreeMind')"
echo "  2. Add FreeMind to your Dock"
echo "  3. Open .mm files directly with FreeMind"
echo ""
echo "Note: On first launch, you may need to right-click the app and select 'Open'"
echo "      to bypass macOS Gatekeeper security."
echo ""
