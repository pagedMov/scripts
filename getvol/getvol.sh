#!/run/current-system/sw/bin/bash


# Function to get the current volume
get_volume() {
    pactl list sinks | grep '^[[:space:]]Volume:' | tail -n 1 | awk '{print $5}' | tr -d '%'
}

# Initialize the previous volume
prev_volume=$(get_volume)

# Listen for volume change events
pactl subscribe | while read -r event; do
    # Get the current volume
    current_volume="$(get_volume)"
    
    # Check if the volume has changed
    if [ "$current_volume" != "$prev_volume" ]; then
        # Output the new volume
        echo "$current_volume"
        
        # Update the previous volume
        prev_volume=$current_volume
    fi
done
