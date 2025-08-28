# Hyprland Configuration

A modular and professional Hyprland configuration with clean organization and reduced code repetition.

## Structure

### Core Configuration (`config/`)

- `variables.conf` - Global variables and constants
- `environment.conf` - Environment variables
- `colors.conf` - Color definitions and border styling (wallust compatible)
- `autostart.conf` - Startup applications
- `appearance.conf` - Visual styling and effects
- `animations.conf` - Animation settings
- `layouts.conf` - Window layout configurations
- `input.conf` - Keyboard, mouse, and touchpad settings
- `plugins.conf` - Third-party plugin configurations

### Keybindings (`keybinds/`)

- `applications.conf` - Application launchers and utilities
- `windows.conf` - Window management
- `workspaces.conf` - Workspace navigation and management
- `media.conf` - Media controls, screenshots, and system bindings

### Window Rules (`rules/`)

- `general.conf` - Basic window behavior and system fixes
- `floating.conf` - Applications that should float by default
- `dialogs.conf` - Modal dialogs, Picture-in-Picture and file choosers
- `opacity.conf` - Transparency settings for applications
- `layers.conf` - Layer-specific visual effects and behavior

### System-Specific

- `monitors.conf` - Display configuration
- `workspaces.conf` - Workspace rules
- `hyprrules.conf` - Main window rules (imports all rule modules)
- `hypridle.conf` - Idle management
- `hyprlock.conf` - Screen lock configuration

## Customization

Edit `config/variables.conf` to customize:

- Applications and paths
- Theme colors and fonts
- Layout settings
- Animation timing
- Timeout values
