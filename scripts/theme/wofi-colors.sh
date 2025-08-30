#!/bin/bash

#===============================================================================
# Wofi Color Update
# ~/.config/scripts/theme/wofi-colors.sh
# Description: Updates wofi style.css based on colors defined in colors.css
# Author: saatvik333
# Version: 2.0
# Dependencies: sed, grep
#===============================================================================

set -euo pipefail

# Source common utilities
source "$(dirname "${BASH_SOURCE[0]}")/../lib/common.sh"
source "$(dirname "${BASH_SOURCE[0]}")/../lib/color-utils.sh"

# --- Configuration ---
readonly CONFIG_DIR="$HOME/.config"
readonly WOFI_DIR="$CONFIG_DIR/wofi"
readonly COLORS_FILE="$WOFI_DIR/colors.css"
readonly STYLE_FILE="$WOFI_DIR/style.css"
readonly FONT_FAMILY="Liga SFMono Nerd Font"

# Default fallback colors
declare -rA DEFAULT_COLORS=(
    ["BG"]="2A2D2E"
    ["FG"]="FFD3FF"
    ["C0"]="4F5253"
    ["C1"]="573B71"
    ["C3"]="8B4AAB"
    ["C4"]="AE57CE"
    ["C5"]="DC6FF3"
)

# --- Functions ---
extract_colors() {
    validate_file "$COLORS_FILE" "Colors file"

    declare -gA COLORS

    # Extract colors with fallbacks
    local bg fg c0 c1 c3 c4 c5
    bg=$(extract_css_color "$COLORS_FILE" "background")
    fg=$(extract_css_color "$COLORS_FILE" "foreground")
    c0=$(extract_css_color "$COLORS_FILE" "color0")
    c1=$(extract_css_color "$COLORS_FILE" "color1")
    c3=$(extract_css_color "$COLORS_FILE" "color3")
    c4=$(extract_css_color "$COLORS_FILE" "color4")
    c5=$(extract_css_color "$COLORS_FILE" "color5")

    # Set colors with fallbacks
    COLORS[BG]="${bg:-${DEFAULT_COLORS[BG]}}"
    COLORS[FG]="${fg:-${DEFAULT_COLORS[FG]}}"
    COLORS[C0]="${c0:-${DEFAULT_COLORS[C0]}}"
    COLORS[C1]="${c1:-${DEFAULT_COLORS[C1]}}"
    COLORS[C3]="${c3:-${DEFAULT_COLORS[C3]}}"
    COLORS[C4]="${c4:-${DEFAULT_COLORS[C4]}}"
    COLORS[C5]="${c5:-${DEFAULT_COLORS[C5]}}"
}

generate_derived_colors() {
    declare -gA DERIVED_COLORS

    local accent selection
    accent=$(lighten_hex "${COLORS[C4]}" 10)
    selection=$(lighten_hex "${COLORS[C3]}" 15)

    DERIVED_COLORS[ACCENT]="$accent"
    DERIVED_COLORS[SELECTION]="$selection"

    # Convert to RGB for rgba usage
    DERIVED_COLORS[BG_RGB]=$(hex_to_rgb "${COLORS[BG]}")
    DERIVED_COLORS[C0_RGB]=$(hex_to_rgb "${COLORS[C0]}")
    DERIVED_COLORS[C1_RGB]=$(hex_to_rgb "${COLORS[C1]}")
    DERIVED_COLORS[SELECTION_RGB]=$(hex_to_rgb "$selection")
}

log_color_info() {
    log_info "Extracted colors:"
    log_info "BG: ${COLORS[BG]}"
    log_info "FG: ${COLORS[FG]}"
    log_info "C0: ${COLORS[C0]}"
    log_info "C1: ${COLORS[C1]}"
    log_info "C3: ${COLORS[C3]}"
    log_info "C4: ${COLORS[C4]}"
    log_info "C5: ${COLORS[C5]}"
    log_info ""
    log_info "Generated colors:"
    log_info "Background: #${COLORS[BG]} -> rgba(${DERIVED_COLORS[BG_RGB]})"
    log_info "Accent: #${DERIVED_COLORS[ACCENT]}"
    log_info "Selection: #${DERIVED_COLORS[SELECTION]} -> rgba(${DERIVED_COLORS[SELECTION_RGB]})"
}

generate_wofi_style() {
    cat >"$STYLE_FILE" <<EOL
/* ~/.config/wofi/style.css - Auto-generated from colors.css */

* {
    border-radius: 0px;
}

window {
    border: 2px solid #${DERIVED_COLORS[SELECTION]};
    margin: 5px;
    background-color: rgba(${DERIVED_COLORS[BG_RGB]}, 1);
    font-family: "${FONT_FAMILY}", monospace;
}

#input {
    margin: 8px;
    padding: 10px 12px;
    border: 2px solid #${DERIVED_COLORS[ACCENT]};
    color: #${COLORS[FG]};
    background-color: rgba(${DERIVED_COLORS[C0_RGB]}, 0.8);
    outline: none;
    caret-color: #${COLORS[C5]};
    font-size: 14px;
}

#input:focus {
    border-color: #${COLORS[C5]};
    box-shadow: 0 0 8px rgba(${DERIVED_COLORS[SELECTION_RGB]}, 0.3);
}

#inner-box {
    margin: 8px;
    padding-top: 5px;
    background-color: transparent;
}

#outer-box {
    margin: 0;
    padding: 5px;
    background-color: transparent;
}

#scroll {
    margin: 0;
    padding: 5px;
}

#text {
    margin: 3px;
    padding: 3px;
    color: #${COLORS[FG]};
    font-size: 13px;
}

#text:selected {
    color: #${COLORS[C5]};
    font-weight: bold;
}

#entry {
    padding: 8px;
    margin: 2px 5px;
    transition: all 0.2s ease;
}

#entry:hover {
    background-color: rgba(${DERIVED_COLORS[SELECTION_RGB]}, 0.2);
}

#entry:selected {
    background-color: rgba(${DERIVED_COLORS[SELECTION_RGB]}, 0.4);
    box-shadow: 0 2px 6px rgba(${DERIVED_COLORS[SELECTION_RGB]}, 0.2);
}

#img {
    margin-right: 10px;
    margin-left: 5px;
}

#unselected {
    opacity: 0.85;
}

#urgent {
    background-color: rgba(${DERIVED_COLORS[C1_RGB]}, 0.3);
    color: #${COLORS[C1]};
    border-left: 3px solid #${COLORS[C1]};
}
EOL
}

main() {
    ensure_directory "$WOFI_DIR"
    extract_colors
    generate_derived_colors
    log_color_info
    generate_wofi_style

    log_success "Wofi theme updated successfully"
}

# --- Script Entry Point ---
if [[ "${BASH_SOURCE[0]}" == "${0}" ]]; then
    main "$@"
fi
