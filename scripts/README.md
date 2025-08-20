# System Scripts Collection

A modular collection of scripts for system theme management, media control, and maintenance tasks.

## 📁 Directory Structure

```
scripts/
├── lib/                    # Shared utility libraries
│   ├── common.sh           # Common functions (logging, file ops, notifications)
│   └── color-utils.sh      # Color processing and image analysis
├── theme/                  # Theme management scripts
│   ├── theme-sync.sh       # Master theme synchronization script
│   ├── waybar-detection.sh # Waybar theme adjustment based on wallpaper
│   ├── gtk-colors.sh       # GTK theme updates
│   └── wofi-colors.sh      # Wofi color scheme updates
├── media/                  # Media and system control
│   ├── music-status.sh     # Music player status display
│   └── volume-brightness.sh # Volume, brightness, and media controls
├── git/                     # Git repository utilities
│   ├── cleanup.sh           # Remove ignored files from git tracking
│   └── validate-gitignore.sh # Validate .gitignore effectiveness
├── system/                # System utilities
│   ├── package-updates.sh # Package update checker for Waybar
│   ├── battery-notify.sh  # CronJob to notify for low-battery
│   └── floating-run.sh    # Launch floating terminal applications
└── utils/                 # Utility launchers and tools
    ├── util-launcher.sh   # Wofi-based emoji picker and utility launcher
    ├── screenshot.sh      # Advanced screenshot tool with grim/slurp
    └── ss                 # Simple screenshot wrapper
```

## 🎨 Theme Management

### `theme/theme-sync.sh` - Master Theme Controller

**Purpose**: Orchestrates system-wide theme updates based on current wallpaper

**Features**:

- Detects current wallpaper from swww
- Handles GIF wallpapers (extracts first frame)
- Updates hyprlock, waybar, GTK, and wofi themes
- Reloads system components (waybar, dunst, hyprswitch)
- Sends completion notifications

### `theme/waybar-detection.sh` - Waybar Theme Adjuster

**Purpose**: Adjusts waybar colors based on wallpaper luminosity

### `theme/gtk-colors.sh` - GTK Theme Manager

**Purpose**: Updates GTK themes based on wallpaper folder structure

### `theme/wofi-colors.sh` - Wofi Color Updater

**Purpose**: Generates wofi CSS from wallust color palette

## 🎵 Media Control

### `media/volume-brightness.sh` - System Controls

**Purpose**: Unified volume, brightness, and media playbook control

**Usage**:

```bash
./scripts/media/volume-brightness.sh {volume_up|volume_down|volume_mute|mic_mute|brightness_up|brightness_down|next_track|prev_track|play_pause}
```

### `media/music-status.sh` - Music Display

**Purpose**: Shows current music status for widgets and lock screen

## 🔧 System Utilities

### `system/package-updates.sh` - Update Checker

**Purpose**: Checks for available package updates (Waybar integration)

**Output**: JSON format for Waybar consumption

### `system/floating-run.sh` - Floating Terminal Launcher

**Purpose**: Launch applications in floating terminal windows with custom dimensions

**Usage**:

```bash
./scripts/system/floating-run.sh <width> <height> <application_name>
./scripts/system/floating-run.sh <application_name>  # Uses default 800x450
```

**Examples**:

```bash
./scripts/system/floating-run.sh 1000 600 htop
./scripts/system/floating-run.sh btop
```

**Features**:

- Automatically detects terminal from Hyprland config
- Fallback to kitty if no terminal configured
- Launches applications in centered floating windows

## 📦 Git Utilities

### `git/cleanup.sh` - Repository Cleanup

**Purpose**: Remove files from git tracking that should be ignored according to .gitignore

**Usage**:

```bash
./scripts/git/cleanup.sh
```

**Features**:

- Scans for files currently tracked in git that match .gitignore patterns
- Shows you a list of files that will be removed from tracking
- Asks for confirmation before making changes
- Removes files from git tracking (files remain on disk)
- Shows staged changes ready to commit

### `git/validate-gitignore.sh` - GitIgnore Validator

**Purpose**: Validate and analyze your .gitignore file effectiveness

**Usage**:

```bash
./scripts/git/validate-gitignore.sh
```

**Features**:

- Files currently tracked that should be ignored
- Common ignore patterns that might be missing
- Large files that might need to be ignored
- Potentially sensitive files
- .gitignore statistics

## 🔨 Utilities

### `utils/util-launcher.sh` - Utility Launcher

**Purpose**: Wofi-based launcher with emoji picker and various utility functions

**Usage**:

```bash
./scripts/utils/util-launcher.sh
```

**Features**:

- Comprehensive emoji picker with search functionality
- Thousands of emojis organized by category
- Easy copy-to-clipboard functionality
- Wofi integration for smooth user experience

### `utils/screenshot.sh` - Advanced Screenshot Tool

**Purpose**: Feature-rich screenshot utility using grim and slurp

**Usage**:

```bash
./scripts/utils/screenshot.sh [OPTIONS]
./scripts/utils/ss [OPTIONS]  # Short wrapper
```

**Options**:

- `-r, --region [fullscreen|workspace|selection]` - Screenshot region (default: selection)
- `-h, --help` - Show help message

**Features**:

- Multiple capture modes (fullscreen, workspace, selection)
- Automatic save to `~/Pictures/Screenshots/`
- Clipboard integration (wl-copy/xclip)
- Desktop notifications with preview and action buttons
- Dependency checking
- Error handling and validation
- Fixed slurp overlay issue with proper timing

**Examples**:

```bash
# Selection screenshot (default)
./scripts/utils/ss

# Fullscreen screenshot
./scripts/utils/ss -r fullscreen

# Current workspace screenshot
./scripts/utils/ss -r workspace
```

## 📚 Libraries

### `lib/common.sh` - Shared Utilities

- Logging functions (info, error, success, warn, debug)
- File system operations
- Process management (locking)
- Dependency validation
- Notification helpers

### `lib/color-utils.sh` - Color Processing

- Hex to RGB conversion
- Color lightening/darkening
- Luminance calculation
- CSS color extraction
- Image analysis functions
- GIF frame extraction

## 🚀 Quick Start

1. **Theme synchronization** (run after wallpaper changes):

   ```bash
   ./scripts/theme/theme-sync.sh
   ```

2. **Volume control** (bind to media keys):

   ```bash
   ./scripts/media/volume-brightness.sh volume_up
   ```

3. **Music status** (for widgets):

   ```bash
   ./scripts/media/music-status.sh
   ```

4. **Take screenshots**:

   ```bash
   ./scripts/utils/ss                    # Selection
   ./scripts/utils/ss -r fullscreen      # Fullscreen
   ./scripts/utils/ss -r workspace       # Current workspace
   ```

## 🔧 Configuration

All scripts follow consistent patterns:

- **Notifications**: Important updates send desktop notifications
- **Logging**: Comprehensive logging with timestamps
- **Error handling**: Robust error checking and recovery
- **Modularity**: Shared code in libraries, focused script responsibilities

## 📋 Dependencies

- **Core**: bash, notify-send
- **Theme**: swww, wallust, hyprctl, gsettings
- **Media**: pactl, brightnessctl, playerctl
- **Image**: imagemagick (for GIF support)
- **System**: checkupdates-with-aur (for package updates)

> [!NOTE]
> Some dependencies might not be listed.
