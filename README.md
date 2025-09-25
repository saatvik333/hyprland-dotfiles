# Hyprland Configuration

A comprehensive, modern, rust-powered Hyprland 🍚 with a focus on featuring automated theme management, dynamic wallpaper integration, and seamless workflow optimization.

>[!NOTE]
>I've switched from Hyprland to Niri, so this repository will no longer be actively maintained.
>
>For people interested in trying out my Niri configuration: [niri-dotfiles](https://github.com/saatvik333/niri-dotfiles)
## Overview

This configuration provides a complete desktop environment built around Hyprland with intelligent automation systems. The setup includes dynamic theme synchronization across all applications, animated wallpaper support, and a modular script architecture for system management.

https://github.com/user-attachments/assets/d348e384-ef6b-4c0d-9aef-bea7f89104bc

|Swaync | Waybar |
|---------|-----------|
| <img width="1920" height="1080" alt="image" src="https://github.com/user-attachments/assets/c11ad43f-59d0-4dbf-b19f-f9a9a22727e3" /> | <img width="1920" height="1080" alt="image" src="https://github.com/user-attachments/assets/d101132d-b038-480f-8c3d-41a87a7c2952" />|

## Key Features

### Automated Theme Management

- **Dynamic Color Extraction**: Automatically generates color schemes from wallpapers using Wallust
- **System-wide Synchronization**: Updates GTK themes, terminal colors, Waybar, and application themes
- **GIF Wallpaper Support**: Seamless integration with animated wallpapers via waytrogen and swww
- **Intelligent Adaptation**: Adjusts interface elements based on wallpaper luminosity

### Modular Script Architecture

- **Theme Orchestration**: Centralized theme management with component-specific handlers
- **Media Controls**: Unified volume, brightness, and playback management with visual feedback
- **System Utilities**: Package update monitoring, git repository maintenance, and status displays
- **Error Handling**: Comprehensive logging, notifications, and recovery mechanisms

### Application Integration

- **Terminal**: Alacritty, Kitty with dynamic color schemes
- **Shell**: Zsh and Bash with unified environment configuration
- **Editor**: Neovim with theme synchronization
- **Browser**: Custom themes and integration
- **Development**: VSCode, various development tools

## Configuration Structure

```txt
~/.config/
├── hypr/           # Hyprland configuration
├── waybar/         # Status bar configuration
├── scripts/        # Automation and utility scripts
├── wallust/        # Color palette templates
├── themes/         # GTK and application themes
└── [applications]/ # Individual application configs
```

## Script System

The configuration includes a modular script system organized by functionality:

- **Theme Management**: Automated theme synchronization and wallpaper processing
- **Media Controls**: Volume, brightness, and playback management
- **System Utilities**: Package updates, git maintenance, status monitoring
- **Development Tools**: Project management and workflow automation

For detailed script documentation, see [`scripts/README.md`](scripts/README.md).

## License

This configuration is provided as-is for educational and personal use. Individual components may have their own licenses.

---

## Author

**Maintainer:** [saatvik333](https://github.com/saatvik333)

> If you find this project helpful, please consider starring the repository to show your support and help others discover it.
