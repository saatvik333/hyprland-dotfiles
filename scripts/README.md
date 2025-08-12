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
└── system/                # System utilities
    ├── package-updates.sh # Package update checker for Waybar
    └── battery-notify.sh  # CronJob to notify for low-battery
```

## 🎨 Theme Management

### `theme/theme-sync.sh` - Master Theme Controller
**Purpose**: Orchestrates system-wide theme updates based on current wallpaper

**Usage**:
```bash
./scripts/theme/theme-sync.sh
```

**Features**:
- Detects current wallpaper from swww
- Handles GIF wallpapers (extracts first frame)
- Updates hyprlock, waybar, GTK, and wofi themes
- Reloads system components (waybar, dunst, hyprswitch)
- Sends completion notifications

### `theme/waybar-detection.sh` - Waybar Theme Adjuster
**Purpose**: Adjusts waybar colors based on wallpaper luminosity

**Usage**:
```bash
./scripts/theme/waybar-detection.sh <wallpaper_path>
```

### `theme/gtk-colors.sh` - GTK Theme Manager
**Purpose**: Updates GTK themes based on wallpaper folder structure

### `theme/wofi-colors.sh` - Wofi Color Updater
**Purpose**: Generates wofi CSS from wallust color palette

## 🎵 Media Control

### `media/volume-brightness.sh` - System Controls
**Purpose**: Unified volume, brightness, and media playback control

**Usage**:
```bash
./scripts/media/volume-brightness.sh {volume_up|volume_down|volume_mute|mic_mute|brightness_up|brightness_down|next_track|prev_track|play_pause}
```

### `media/music-status.sh` - Music Display
**Purpose**: Shows current music status for widgets and lock screen

## 🔧 System Utilities

### `system/package-updates.sh` - Update Checker
**Purpose**: Checks for available package updates (Waybar integration)

**Usage**:
```bash
./scripts/system/package-updates.sh
```

**Output**: JSON format for Waybar consumption

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

## 🔄 Migration from Old Structure

The scripts have been reorganized for better maintainability:

**Old → New Mapping**:
- `check-package-updates.sh` → `system/package-updates.sh`
- `music-status.sh` → `media/music-status.sh`
- `volume-brightness.sh` → `media/volume-brightness.sh`
- `waybar-wallpaper-detection.sh` → `theme/waybar-detection.sh`
- `update-gtk-colors.sh` → `theme/gtk-colors.sh`
- `update-wofi-colors.sh` → `theme/wofi-colors.sh`
- `theme.sh` → `theme/theme-sync.sh`
- `git-cleanup.sh` → `git/cleanup.sh`
- `validate-gitignore.sh` → `git/validate-gitignore.sh`

Update your keybindings and automation scripts to use the new paths.
