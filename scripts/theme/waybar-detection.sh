#!/bin/bash

#===============================================================================
# Waybar Wallpaper Detection
# ~/.config/scripts/theme/waybar-detection.sh
# Description: Updates waybar styles based on wallpaper luminosity analysis
# Author: saatvik333
# Version: 2.0
# Dependencies: magick, sed, bc
#===============================================================================

set -euo pipefail

# Source common utilities
source "$(dirname "${BASH_SOURCE[0]}")/../lib/common.sh"
source "$(dirname "${BASH_SOURCE[0]}")/../lib/color-utils.sh"

# --- Configuration ---
readonly LUMINANCE_THRESHOLD=100
readonly CROP_PERCENTAGE=5
readonly WAYBAR_TEMPLATE="$HOME/.config/wallust/templates/waybar.css"
readonly WAYBAR_STYLE="$HOME/.config/waybar/style.css"

# --- Style Update Functions ---
update_waybar_template_for_light() {
    validate_file "$WAYBAR_TEMPLATE" "Waybar template"
    
    sed -i.bak \
        -e 's/@define-color background {{background}};/@define-color background {{foreground}};/' \
        -e 's/@define-color foreground {{foreground}};/@define-color foreground {{background}};/' \
        "$WAYBAR_TEMPLATE" || die "Failed to update waybar template for light wallpaper"
}

update_waybar_template_for_dark() {
    validate_file "$WAYBAR_TEMPLATE" "Waybar template"
    
    sed -i.bak \
        -e 's/@define-color background {{foreground}};/@define-color background {{background}};/' \
        -e 's/@define-color foreground {{background}};/@define-color foreground {{foreground}};/' \
        "$WAYBAR_TEMPLATE" || die "Failed to update waybar template for dark wallpaper"
}

update_waybar_style_for_light() {
    validate_file "$WAYBAR_STYLE" "Waybar style"
    
    sed -i \
        -e 's/background: rgba(255, 255, 255, 0\.1)/background: rgba(0, 0, 0, 0.1)/g' \
        "$WAYBAR_STYLE" || die "Failed to update waybar style for light wallpaper"
}

update_waybar_style_for_dark() {
    validate_file "$WAYBAR_STYLE" "Waybar style"
    
    sed -i \
        -e 's/background: rgba(0, 0, 0, 0\.1)/background: rgba(255, 255, 255, 0.1)/g' \
        "$WAYBAR_STYLE" || die "Failed to update waybar style for dark wallpaper"
}

apply_theme_adjustments() {
    local -r r="$1"
    local -r g="$2"
    local -r b="$3"
    local -r luminance="$4"
    
    if (( $(echo "$luminance > $LUMINANCE_THRESHOLD" | bc -l) )); then
        # Light wallpaper - use dark backgrounds
        update_waybar_template_for_light
        update_waybar_style_for_light
        
        log_info "RGB: $r $g $b, Luminance: $luminance (Light wallpaper - using dark backgrounds)"
    else
        # Dark wallpaper - use light backgrounds
        update_waybar_template_for_dark
        update_waybar_style_for_dark
        
        log_info "RGB: $r $g $b, Luminance: $luminance (Dark wallpaper - using light backgrounds)"
    fi
}

analyze_wallpaper() {
    local -r wallpaper="$1"
    local img_info img_w img_h crop_h rgb_values r g b luminance
    
    # Get image dimensions
    img_info=$(get_image_dimensions "$wallpaper")
    read -r img_w img_h <<< "$img_info"
    
    # Calculate crop region (top 5% of image)
    crop_h=$((img_h * CROP_PERCENTAGE / 100))
    
    # Extract RGB values from top region
    rgb_values=$(extract_region_rgb "$wallpaper" "$img_w" "$crop_h")
    read -r r g b <<< "$rgb_values"
    
    # Calculate luminance
    luminance=$(calculate_luminance "$r" "$g" "$b")
    
    echo "$r $g $b $luminance"
}

main() {
    [[ $# -eq 1 ]] || die "Usage: $0 <wallpaper_path>"
    
    local -r wallpaper="$1"
    validate_file "$wallpaper" "Wallpaper file"
    
    validate_dependencies "magick" "sed" "bc"
    
    log_info "Analyzing wallpaper: $wallpaper"
    
    local analysis_result r g b luminance
    analysis_result=$(analyze_wallpaper "$wallpaper")
    read -r r g b luminance <<< "$analysis_result"
    
    apply_theme_adjustments "$r" "$g" "$b" "$luminance"
    
    log_success "Waybar theme adjustment completed"
}

# --- Script Entry Point ---
if [[ "${BASH_SOURCE[0]}" == "${0}" ]]; then
    main "$@"
fi