# Modifications for macOS

This document explains the modifications made to FreeMind 1.0.1 for proper operation on macOS.

## Problem

The standard FreeMind 1.0.1 binary distribution from SourceForge has severe font rendering issues on macOS:
- Text appears blurry or pixelated
- Font sizes are incorrect
- UI elements don't render properly with macOS's Retina displays
- Overall poor visual quality makes the application difficult to use

## Solution

The FreeMind team released an official macOS-specific DMG bundle that includes patches to fix these rendering issues. This repository uses the patched version from that DMG.

## Modified Files

### `lib/freemind.jar`

**Standard version:** 11,712,137 bytes (MD5: `0ff11aab57ff24382fd6f8fe37535f56`)
**macOS-patched version:** 12,954,599 bytes (MD5: `7cec4a4076937c1431587d8d81b7ed53`)

The patched JAR includes fixes for:
- Font rendering on macOS Retina displays
- Swing component rendering with macOS Look and Feel
- Proper anti-aliasing for text and graphics
- High-DPI display support

## Source

The patched `freemind.jar` was extracted from:
- **File:** `FreeMind_1.0.1.dmg`
- **Source:** Official FreeMind macOS distribution
- **Location in DMG:** `FreeMind.app/Contents/Java/freemind.jar`
- **Release date:** April 12, 2014

## Additional Configuration

The official macOS app bundle also includes these Java options in its `Info.plist`:
```xml
<key>JVMOptions</key>
<array>
    <string>-Xms64m</string>
    <string>-Xmx512m</string>
    <string>-Xss8M</string>
    <string>-Dapple.laf.useScreenMenuBar=true</string>
</array>
```

The included `freemind.sh` launcher script is the standard Unix launcher and works well with the patched JAR.

## Verification

To verify you have the correct patched version:

```bash
md5 lib/freemind.jar
```

Should output: `7cec4a4076937c1431587d8d81b7ed53`

Or check the file size:
```bash
ls -lh lib/freemind.jar
```

Should show approximately **12.9 MB** (not 11 MB).

## License

All modifications are part of the official FreeMind distribution and fall under the same GNU GPL license as FreeMind itself.
