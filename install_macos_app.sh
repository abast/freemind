#!/bin/bash

# FreeMind macOS Application Bundle Installer
# This script creates a macOS .app bundle that can be launched like any native application

set -e

echo "Creating FreeMind.app bundle..."

# Get the directory where this script is located
SCRIPT_DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"

# Define app bundle structure
APP_NAME="FreeMind"
APP_BUNDLE="/Applications/${APP_NAME}.app"
APP_CONTENTS="${APP_BUNDLE}/Contents"
APP_MACOS="${APP_CONTENTS}/MacOS"
APP_RESOURCES="${APP_CONTENTS}/Resources"

# Check if we need sudo
if [ ! -w "/Applications" ]; then
    echo "This script requires administrator privileges to install to /Applications."
    echo "You may be prompted for your password."
    SUDO="sudo"
else
    SUDO=""
fi

# Remove existing app if present
if [ -d "${APP_BUNDLE}" ]; then
    echo "Removing existing FreeMind.app..."
    ${SUDO} rm -rf "${APP_BUNDLE}"
fi

# Create directory structure
echo "Creating application bundle structure..."
${SUDO} mkdir -p "${APP_MACOS}"
${SUDO} mkdir -p "${APP_RESOURCES}"

# Create the launcher script
echo "Creating launcher script..."
${SUDO} tee "${APP_MACOS}/${APP_NAME}" > /dev/null << 'LAUNCHER_EOF'
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
${SUDO} chmod +x "${APP_MACOS}/${APP_NAME}"

# Create Info.plist
echo "Creating Info.plist..."
${SUDO} tee "${APP_CONTENTS}/Info.plist" > /dev/null << 'PLIST_EOF'
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

# Copy application icon
echo "Setting up application icon..."
if [ -f "${SCRIPT_DIR}/FreeMindWindowIconModern.icns" ]; then
    ${SUDO} cp "${SCRIPT_DIR}/FreeMindWindowIconModern.icns" "${APP_RESOURCES}/FreeMind.icns"
    echo "✓ Icon installed"
else
    echo "⚠ Warning: Icon file not found, app will use default icon"
fi

echo ""
echo "✓ FreeMind.app has been successfully installed!"
echo ""
echo "Location: ${APP_BUNDLE}"
echo ""
echo "You can now:"
echo "  1. Open FreeMind from Spotlight (⌘+Space, type 'FreeMind')"
echo "  2. Find it in Launchpad"
echo "  3. Add FreeMind to your Dock"
echo "  4. Open .mm files directly with FreeMind"
echo ""
echo "Note: If Spotlight doesn't find it immediately, wait a few seconds for indexing."
echo ""
