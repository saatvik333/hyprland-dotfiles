#!/bin/bash

# Battery notification script
# Run this as a systemd user timer or cron job every minute

BAT_PATH="/sys/class/power_supply/BAT0"
CAPACITY=$(cat "$BAT_PATH/capacity")
STATUS=$(cat "$BAT_PATH/status")
CACHE_FILE="$HOME/.cache/battery-notified"

# Only notify when discharging
[[ "$STATUS" != "Discharging" ]] && { rm -f "$CACHE_FILE"; exit 0; }

# Check if already notified at this level
[[ -f "$CACHE_FILE" ]] && {
    LAST_LEVEL=$(cat "$CACHE_FILE")
    [[ "$CAPACITY" -ge "$LAST_LEVEL" ]] && exit 0
}

# Send notifications
case 1 in
    $((CAPACITY <= 5)))
        notify-send -u critical -i battery-empty "Battery Critical" "Battery: ${CAPACITY}% - Plug in now!"
        echo "$CAPACITY" > "$CACHE_FILE"
        ;;
    $((CAPACITY <= 10)))
        notify-send -u critical -i battery-low "Battery Critical" "Battery: ${CAPACITY}%"
        echo "$CAPACITY" > "$CACHE_FILE"
        ;;
    $((CAPACITY <= 20)))
        notify-send -u normal -i battery-caution "Battery Warning" "Battery: ${CAPACITY}%"
        echo "$CAPACITY" > "$CACHE_FILE"
        ;;
esac
