#!/bin/bash

# Screenshot script using grim and slurp
# Usage: screenshot.sh [OPTIONS]
# Options:
#   -r, --region [fullscreen|workspace|selection]  Screenshot region (default: selection)
#   -h, --help                                     Show this help message

SCREENSHOT_DIR="$HOME/Pictures/Screenshots"
REGION="selection"

# Check dependencies
check_dependencies() {
    local missing_deps=()

    if ! command -v grim >/dev/null 2>&1; then
        missing_deps+=("grim")
    fi

    if ! command -v slurp >/dev/null 2>&1; then
        missing_deps+=("slurp")
    fi

    if [[ ${#missing_deps[@]} -gt 0 ]]; then
        echo "Error: Missing required dependencies: ${missing_deps[*]}"
        echo "Please install them using your package manager"
        exit 1
    fi
}

# Check dependencies first
check_dependencies

# Create screenshot directory if it doesn't exist
mkdir -p "$SCREENSHOT_DIR"

# Parse command line arguments
while [[ $# -gt 0 ]]; do
    case $1 in
        -r|--region)
            REGION="$2"
            shift 2
            ;;
        -h|--help)
            echo "Usage: $0 [OPTIONS]"
            echo "Options:"
            echo "  -r, --region [fullscreen|workspace|selection]  Screenshot region (default: selection)"
            echo "  -h, --help                                     Show this help message"
            exit 0
            ;;
        *)
            echo "Unknown option: $1"
            exit 1
            ;;
    esac
done

# Validate region parameter
if [[ ! "$REGION" =~ ^(fullscreen|workspace|selection)$ ]]; then
    echo "Error: Invalid region '$REGION'. Must be one of: fullscreen, workspace, selection"
    exit 1
fi

# Generate filename with timestamp
TIMESTAMP=$(date +"%Y-%m-%d_%H-%M-%S")
FILENAME="screenshot_${TIMESTAMP}.png"
FILEPATH="$SCREENSHOT_DIR/$FILENAME"

# Function to send notification with preview and action buttons
send_notification() {
    local filepath="$1"
    local success="$2"

    if [[ "$success" == "true" ]]; then
        local filename=$(basename "$filepath")

        # Use notify-send with actions and handle responses
        {
            action=$(notify-send \
                --icon="$filepath" \
                --app-name="Screenshot" \
                --urgency=normal \
                --expire-time=10000 \
                --wait \
                --action="open=📖 Open Screenshot" \
                --action="folder=📁 Open Folder" \
                "📸 Screenshot Saved" \
                "$filename\n✅ Copied to clipboard")

            # Handle the action response
            case "$action" in
                "open")
                    xdg-open "$filepath" 2>/dev/null &
                    ;;
                "folder")
                    xdg-open "$(dirname "$filepath")" 2>/dev/null &
                    ;;
            esac
        } &
    fi
}

# Function to take screenshot based on region
take_screenshot() {
    local region="$1"
    local output_file="$2"

    case "$region" in
        "fullscreen")
            grim "$output_file"
            ;;
        "workspace")
            # Get current workspace/monitor
            grim -o "$(hyprctl monitors -j | jq -r '.[] | select(.focused) | .name')" "$output_file" 2>/dev/null || \
            grim -o "$(swaymsg -t get_outputs | jq -r '.[] | select(.focused) | .name')" "$output_file" 2>/dev/null || \
            grim "$output_file"  # Fallback to fullscreen if workspace detection fails
            ;;
        "selection")
            # Get selection coordinates first, then capture with delay
            SELECTION=$(slurp 2>/dev/null)
            if [[ -n "$SELECTION" ]]; then
                # Small delay to ensure slurp overlay is completely gone
                sleep 0.1
                grim -g "$SELECTION" "$output_file"
            else
                return 1
            fi
            ;;
    esac
}

# Take the screenshot
echo "Taking $REGION screenshot..."

if take_screenshot "$REGION" "$FILEPATH"; then
    # Check if file was actually created and has content
    if [[ -f "$FILEPATH" && -s "$FILEPATH" ]]; then
        # Copy to clipboard
        if command -v wl-copy >/dev/null 2>&1; then
            wl-copy < "$FILEPATH"
            CLIPBOARD_SUCCESS=true
        elif command -v xclip >/dev/null 2>&1; then
            xclip -selection clipboard -t image/png < "$FILEPATH"
            CLIPBOARD_SUCCESS=true
        else
            echo "Warning: No clipboard utility found (wl-copy or xclip)"
            CLIPBOARD_SUCCESS=false
        fi

        echo "󰹑 Screenshot saved: $FILEPATH"
        if [[ "$CLIPBOARD_SUCCESS" == "true" ]]; then
            echo "Copied to clipboard"
        fi

        # Send notification with preview
        send_notification "$FILEPATH" "true"

        exit 0
    else
        echo "Error: Screenshot file was not created or is empty"
        exit 1
    fi
else
    echo "Error: Failed to take screenshot"
    exit 1
fi