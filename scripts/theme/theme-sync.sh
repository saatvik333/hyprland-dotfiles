#!/bin/bash

#===============================================================================
# Theme Synchronization Master Script
# ~/.config/scripts/theme/theme-sync.sh
# Description: Orchestrates system-wide theme updates based on current wallpaper
# Author: saatvik333
# Version: 3.0
# Dependencies: swww, wallust, hyprctl, waybar, dunst, hyprswitch, imagemagick
#===============================================================================

set -euo pipefail

# Source common utilities
source "$(dirname "${BASH_SOURCE[0]}")/../lib/common.sh"
source "$(dirname "${BASH_SOURCE[0]}")/../lib/color-utils.sh"

# Short delay to ensure clean startup
sleep 1

# --- Configuration ---
readonly SCRIPT_NAME="${0##*/}"
readonly CONFIG_DIR="$HOME/.config"
readonly CACHE_DIR="$HOME/.cache"

# File paths
readonly HYPRLOCK_CONF="$CONFIG_DIR/hypr/hyprlock.conf"
readonly WALLPAPER_CACHE="$CONFIG_DIR/waytrogen/wallpaper.txt"
readonly GIF_FRAME="$CONFIG_DIR/waytrogen/gif-frame.jpg"
readonly LOG_FILE="$CACHE_DIR/${SCRIPT_NAME%.sh}.log"
readonly LOCK_FILE="/tmp/${SCRIPT_NAME%.sh}.lock"

# Script paths
readonly WOFI_SCRIPT="$CONFIG_DIR/scripts/theme/wofi-colors.sh"
readonly WAYBAR_SCRIPT="$CONFIG_DIR/scripts/theme/waybar-detection.sh"
readonly GTK_SCRIPT="$CONFIG_DIR/scripts/theme/gtk-colors.sh"

# Hyprswitch configuration
readonly HYPRSWITCH_CSS="$CONFIG_DIR/hypr/config/hyprswitch.css"

# Global state
declare -g SKIP_WAYBAR_DETECTION=0

# --- Wallpaper Management Functions ---
get_current_wallpaper() {
    log_debug "Retrieving current wallpaper from swww"
    
    local wallpaper
    wallpaper=$(swww query 2>/dev/null | grep -oP '(?<=image: ).*' | head -n1 | tr -d '\n\r')
    
    if [[ -z "$wallpaper" ]]; then
        die "No wallpaper detected from swww query"
    fi
    
    if [[ ! -f "$wallpaper" ]]; then
        die "Wallpaper file does not exist: $wallpaper"
    fi
    
    log_debug "Found wallpaper: $wallpaper"
    echo "$wallpaper"
}

cache_wallpaper_path() {
    local -r wallpaper="$1"
    
    ensure_directory "$(dirname "$WALLPAPER_CACHE")"
    
    echo "$wallpaper" >"$WALLPAPER_CACHE" || die "Failed to cache wallpaper path"
    
    log_debug "Cached wallpaper path: $wallpaper"
}

process_wallpaper() {
    local wallpaper
    wallpaper=$(get_current_wallpaper)
    
    # Cache the original wallpaper path
    cache_wallpaper_path "$wallpaper"
    
    # Handle GIF wallpapers
    if [[ "$wallpaper" =~ \.(gif|GIF)$ ]]; then
        log_info "Detected GIF wallpaper, extracting frame for color processing"
        wallpaper=$(extract_gif_frame "$wallpaper" "$GIF_FRAME")
        SKIP_WAYBAR_DETECTION=1
        log_debug "Will skip waybar detection for GIF wallpaper"
    else
        SKIP_WAYBAR_DETECTION=0
        log_debug "Static wallpaper detected, will run full processing"
    fi
    
    log_info "Using wallpaper for color processing: $wallpaper"
    echo "$wallpaper"
}

# --- Configuration Update Functions ---
update_hyprlock_config() {
    local -r wallpaper="$1"
    
    log_debug "Updating hyprlock configuration"
    
    validate_file "$HYPRLOCK_CONF" "Hyprlock config"
    
    # Create timestamped backup
    local -r backup="${HYPRLOCK_CONF}.backup.$(date +%s)"
    if ! cp "$HYPRLOCK_CONF" "$backup"; then
        die "Failed to create backup of hyprlock config"
    fi
    
    # Update wallpaper path using awk
    local -r temp_file="${HYPRLOCK_CONF}.tmp"
    
    if ! awk -v new_path="$wallpaper" '
        /^background {/ { in_bg = 1 }
        in_bg && /^[ \t]*path[ \t]*=/ {
            print "    path = " new_path
            next
        }
        /^}/ && in_bg { in_bg = 0 }
        { print }
    ' "$HYPRLOCK_CONF" >"$temp_file"; then
        log_error "Failed to process hyprlock config with awk"
        rm -f "$temp_file"
        mv "$backup" "$HYPRLOCK_CONF"
        die "Hyprlock config update failed"
    fi
    
    # Replace original with updated version
    if ! mv "$temp_file" "$HYPRLOCK_CONF"; then
        log_error "Failed to replace hyprlock config"
        rm -f "$temp_file"
        mv "$backup" "$HYPRLOCK_CONF"
        die "Hyprlock config replacement failed"
    fi
    
    # Clean up backup on success
    rm -f "$backup"
    log_success "Updated hyprlock background configuration"
}

# --- Theme Script Execution Functions ---
execute_waybar_detection() {
    local -r wallpaper="$1"
    
    if [[ $SKIP_WAYBAR_DETECTION -eq 1 ]]; then
        log_info "Skipping waybar wallpaper detection for GIF"
        return 0
    fi
    
    validate_executable "$WAYBAR_SCRIPT" "Waybar wallpaper detection script"
    
    log_debug "Executing waybar wallpaper detection"
    if ! "$WAYBAR_SCRIPT" "$wallpaper"; then
        die "Waybar wallpaper detection script failed"
    fi
    
    log_success "Waybar wallpaper detection completed"
}

execute_gtk_theme_update() {
    validate_executable "$GTK_SCRIPT" "GTK theme script"
    
    log_debug "Executing GTK theme update"
    if ! "$GTK_SCRIPT"; then
        die "GTK theme script failed"
    fi
    
    log_success "GTK theme update completed"
}

execute_wallust_generation() {
    local -r wallpaper="$1"
    
    log_debug "Executing wallust theme generation"
    
    # Verify wallpaper accessibility
    if [[ ! -r "$wallpaper" ]]; then
        die "Wallpaper file not readable: $wallpaper"
    fi
    
    # Get absolute path for wallust
    local abs_wallpaper
    abs_wallpaper=$(realpath "$wallpaper" 2>/dev/null) || die "Failed to resolve absolute path for: $wallpaper"
    
    log_debug "Using absolute wallpaper path: $abs_wallpaper"
    
    # Run wallust with dynamic threshold
    if ! wallust run "$abs_wallpaper" --dynamic-threshold 2>/dev/null; then
        die "Wallust theme generation failed for: $abs_wallpaper"
    fi
    
    log_success "Wallust theme generation completed"
}

execute_wofi_color_update() {
    validate_executable "$WOFI_SCRIPT" "Wofi color script"
    
    log_debug "Executing wofi color update"
    if ! "$WOFI_SCRIPT"; then
        die "Wofi color script failed"
    fi
    
    log_success "Wofi color update completed"
}

execute_theme_scripts() {
    local -r wallpaper="$1"
    
    log_info "Executing theme update scripts"
    
    # Execute scripts in order
    execute_waybar_detection "$wallpaper"
    execute_gtk_theme_update
    execute_wallust_generation "$wallpaper"
    execute_wofi_color_update
    
    log_success "All theme scripts executed successfully"
}

# --- System Component Reload Functions ---
reload_hyprland() {
    log_debug "Reloading Hyprland configuration"
    
    if ! hyprctl reload 2>/dev/null; then
        die "Failed to reload Hyprland configuration"
    fi
    
    log_success "Hyprland configuration reloaded"
}

reload_waybar() {
    log_debug "Reloading Waybar"
    
    # Stop existing waybar processes
    pkill waybar 2>/dev/null || true
    sleep 0.5
    
    # Start waybar in background
    if command -v waybar >/dev/null 2>&1; then
        waybar &>/dev/null &
        log_success "Waybar reloaded"
    else
        die "Waybar command not found"
    fi
}

restart_dunst() {
    log_debug "Restarting Dunst notification daemon"
    
    # Stop existing dunst processes
    if pgrep -x dunst >/dev/null; then
        killall dunst 2>/dev/null || true
        sleep 0.1
    fi
    
    # Validate dunst availability
    if ! command -v dunst >/dev/null 2>&1; then
        die "Dunst command not found in PATH"
    fi
    
    # Start dunst daemon
    if dunst &>/dev/null & then
        local -r dunst_pid=$!
        sleep 0.1
        
        # Verify dunst is running
        if kill -0 "$dunst_pid" 2>/dev/null; then
            log_success "Dunst restarted successfully (PID: $dunst_pid)"
        else
            die "Dunst process died immediately after start"
        fi
    else
        die "Failed to execute dunst command"
    fi
}

restart_hyprswitch() {
    log_debug "Restarting Hyprswitch"
    
    # Stop existing hyprswitch processes
    if pgrep -x hyprswitch >/dev/null; then
        killall hyprswitch 2>/dev/null || true
        sleep 0.1
    fi
    
    # Validate hyprswitch availability
    if ! command -v hyprswitch >/dev/null 2>&1; then
        die "Hyprswitch command not found in PATH"
    fi
    
    # Build hyprswitch command
    local hyprswitch_cmd="hyprswitch init --show-title --size-factor 5 --workspaces-per-row 4"
    if [[ -f "$HYPRSWITCH_CSS" ]]; then
        hyprswitch_cmd+=" --custom-css $HYPRSWITCH_CSS"
        log_debug "Using custom CSS: $HYPRSWITCH_CSS"
    fi
    
    # Start hyprswitch daemon
    if $hyprswitch_cmd &>/dev/null & then
        local -r hyprswitch_pid=$!
        sleep 0.1
        
        # Verify hyprswitch is running
        if kill -0 "$hyprswitch_pid" 2>/dev/null; then
            log_success "Hyprswitch restarted successfully (PID: $hyprswitch_pid)"
        else
            die "Hyprswitch process died immediately after start"
        fi
    else
        die "Failed to execute hyprswitch command: $hyprswitch_cmd"
    fi
}

reload_hyprland_plugins() {
    log_debug "Reloading Hyprland plugins"
    
    if hyprpm reload 2>/dev/null; then
        log_success "Hyprland plugins reloaded successfully"
    else
        die "Failed to reload Hyprland plugins"
    fi
}

reload_swaync() {
    swaync-client -rs
}

reload_system_components() {
    log_info "Reloading system components"
    
    # Reload components in order
    reload_hyprland
    # reload_waybar
    # restart_dunst
    reload_swaync
    restart_hyprswitch
    reload_hyprland_plugins
    
    log_success "All system components reloaded successfully"
}

# --- Main Function ---
main() {
    log_info "Starting theme synchronization"
    
    # Initialize script environment
    acquire_lock "$LOCK_FILE" "$SCRIPT_NAME"
    
    # Create necessary directories
    ensure_directory "$(dirname "$LOG_FILE")"
    ensure_directory "$(dirname "$WALLPAPER_CACHE")"
    
    # Validate system dependencies
    validate_dependencies "swww" "wallust" "hyprctl"
    
    # Process current wallpaper (handles GIF extraction)
    local wallpaper
    wallpaper=$(process_wallpaper)
    
    # Get original wallpaper path for hyprlock
    local original_wallpaper hyprlock_wallpaper
    original_wallpaper=$(cat "$WALLPAPER_CACHE" 2>/dev/null) || die "Failed to read cached wallpaper path"
    
    # Determine appropriate wallpaper for hyprlock
    if [[ "$original_wallpaper" =~ \.(gif|GIF)$ ]]; then
        hyprlock_wallpaper="$GIF_FRAME"
        log_debug "Using extracted GIF frame for hyprlock: $hyprlock_wallpaper"
    else
        hyprlock_wallpaper="$original_wallpaper"
        log_debug "Using original wallpaper for hyprlock: $hyprlock_wallpaper"
    fi
    
    # Execute theme update pipeline
    log_info "Executing theme update pipeline"
    update_hyprlock_config "$hyprlock_wallpaper"
    execute_theme_scripts "$wallpaper"
    reload_system_components

    
    # Send completion notification
    send_notification "Theme Manager" "Theme Synchronization Complete" \
        "🎨 All system components updated successfully" "normal" "preferences-desktop-theme"
    
    log_success "Theme synchronization completed successfully"
    
    # Close waytrogen after successful theme synchronization
    log_debug "Closing waytrogen wallpaper selector"
    pkill waytrogen 2>/dev/null || true
}

# --- Script Entry Point ---
if [[ "${BASH_SOURCE[0]}" == "${0}" ]]; then
    main "$@"
fi