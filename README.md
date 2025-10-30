# FreeMind for macOS

FreeMind 1.0.1 configured to run properly on macOS. This repository contains a working FreeMind installation with a launcher script that addresses rendering issues on modern macOS systems.

## About

FreeMind is a free mind mapping application written in Java. This setup uses Java 8 to ensure compatibility and proper rendering on macOS.

## Requirements

- Java 8 (Java SE Runtime Environment 1.8.0 or later)
- macOS (tested on macOS Ventura and later)

## Installation

### Option 1: Terminal-based Installation

1. Clone this repository:
   ```bash
   git clone https://github.com/abast/freemind.git ~/project_src/freemind
   ```

2. Make the launcher script executable:
   ```bash
   chmod +x ~/project_src/freemind/freemind.sh
   ```

3. Add an alias to your shell configuration (`~/.bashrc` or `~/.zshrc`):
   ```bash
   echo 'alias freemind="cd ~/project_src/freemind && bash freemind.sh"' >> ~/.bashrc
   ```

   Or for zsh:
   ```bash
   echo 'alias freemind="cd ~/project_src/freemind && bash freemind.sh"' >> ~/.zshrc
   ```

4. Reload your shell configuration:
   ```bash
   source ~/.bashrc  # or source ~/.zshrc
   ```

5. Run FreeMind:
   ```bash
   freemind
   ```

### Option 2: macOS Application Bundle (Recommended)

To run FreeMind without keeping a terminal window open, create an Application bundle:

1. Follow steps 1-2 from Option 1

2. Run the installation script:
   ```bash
   cd ~/project_src/freemind
   ./install_macos_app.sh
   ```

3. This will create `FreeMind.app` in your Applications folder

4. Launch FreeMind from Spotlight, Launchpad, or Applications folder

## macOS Rendering Fix

This setup addresses common rendering issues with Java Swing applications on macOS:

- Uses Java 8 for optimal compatibility
- Properly configured classpath and Java system properties
- Memory allocation set to 256MB (`-Xmx256M`)
- Correct base directory configuration for plugins and resources

## Usage

### Terminal Method
Simply type `freemind` in your terminal to launch the application.

### Application Bundle Method
Double-click the FreeMind icon in your Applications folder or launch via Spotlight.

## Auto-save Files

FreeMind automatically saves temporary files to `~/.freemind/`. If FreeMind crashes, check this directory for auto-saved files:
```bash
ls -la ~/.freemind/
```

Temporary files are named like `FM_unnamed[numbers].mm`.

## Troubleshooting

### Java not found
If you get "java: command not found", install Java 8:
```bash
brew install --cask adoptopenjdk8
```

### Rendering issues
Make sure you're using Java 8. Check your Java version:
```bash
java -version
```

Should output something like: `java version "1.8.0_xxx"`

### Permission denied
Make sure the script is executable:
```bash
chmod +x ~/project_src/freemind/freemind.sh
```

## File Locations

- **Application files**: `~/project_src/freemind/`
- **User preferences**: `~/.freemind/auto.properties`
- **Auto-save files**: `~/.freemind/FM_unnamed*.mm`
- **Recent files**: Listed in `~/.freemind/auto.properties`

## License

FreeMind is licensed under the GNU GPL. See the `license` file for details.

## Version

FreeMind 1.0.1 (released April 12, 2014)
