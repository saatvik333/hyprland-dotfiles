#!/bin/bash

# Script to open a floating terminal and run an application
# Usage: floating-run.sh <width> <height> <application_name>
# Usage: floating-run.sh <application_name> (uses default 800x450)

if [ $# -eq 0 ]; then
    echo "Usage: $0 <width> <height> <application_name>"
    echo "   or: $0 <application_name> (uses default 800x450)"
    echo "Examples:"
    echo "  $0 1000 600 htop"
    echo "  $0 htop"
    exit 1
fi

# Check if we have 3 parameters (width, height, app) or 1 parameter (just app)
if [ $# -eq 3 ]; then
    WIDTH="$1"
    HEIGHT="$2"
    APP_NAME="$3"
elif [ $# -eq 1 ]; then
    WIDTH="800"
    HEIGHT="450"
    APP_NAME="$1"
else
    echo "Error: Invalid number of parameters"
    echo "Usage: $0 <width> <height> <application_name>"
    echo "   or: $0 <application_name>"
    exit 1
fi

# Get the terminal from Hyprland variables or use a default
TERMINAL=$(hyprctl getoption general:terminal | grep -o '"[^"]*"' | tr -d '"' 2>/dev/null || echo "kitty")

# If terminal is not set or empty, use kitty as default
if [ -z "$TERMINAL" ]; then
    TERMINAL="kitty"
fi

# Launch the floating terminal with the specified application
hyprctl dispatch exec "[float; size $WIDTH $HEIGHT; center] $TERMINAL -e $APP_NAME"