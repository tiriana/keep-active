#!/bin/bash
# Script Name: keep-active.sh
# Description: This script simulates mouse movements to keep the system active. It prevents the computer from going into sleep mode or showing as inactive in communication tools.
# Dependencies: This script requires 'xprintidle' and 'xdotool' to function. Ensure these are installed on your system.
# Usage: Run the script with optional arguments: 
#        --silent            : Run in silent mode without echo outputs.
#        --mouse-distance=N  : Set mouse movement distance to N pixels (default: 10).
#        --idle-time=N       : Set idle time threshold to N seconds before activation (default: 2).
#        --sleep-duration=N  : Set sleep duration to N seconds between movements (default: 1).
#        -h, --help          : Display the help message.
# Author: Radomir Wojtera
# License: MIT License
# 
# MIT License
# 
# Copyright (c) 2023 Radomir Wojtera <radomir.wojtera@gmail.com>
# 
# Permission is hereby granted, free of charge, to any person obtaining a copy
# of this software and associated documentation files (the "Software"), to deal
# in the Software without restriction, including without limitation the rights
# to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
# copies of the Software, and to permit persons to whom the Software is
# furnished to do so, subject to the following conditions:
# 
# The above copyright notice and this permission notice shall be included in all
# copies or substantial portions of the Software.
# 
# THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
# IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
# FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
# AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
# LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
# OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
# SOFTWARE.


# Default values
idle_time_threshold=2000 # 2 seconds in milliseconds, default
mouse_distance=10        # Default mouse movement distance
silent_mode=false        # Silent mode flag
sleep_duration=1         # Default sleep duration in seconds
user_active=true         # Assume user is initially active to avoid immediate pausing
direction=1              # Initial direction for mouse movement
skip_first_check=true # Skip the first activity check

# Function to display help message
show_help() {
    echo "Usage: $(basename $0) [options]"
    echo "Options:"
    echo "  --silent            Run the script in silent mode without echo outputs."
    echo "  --mouse-distance=N  Set the mouse movement distance to N pixels (default: 10)."
    echo "  --idle-time=N       Set the idle time threshold to N seconds (default: 2)."
    echo "  --sleep-duration=N  Set the sleep duration to N seconds between movements (default: 1)."
    echo "  -h, --help          Display this help message."
    echo ""
    echo "If you find this tool helpful and you feel like it you can buy me a coffee here: https://www.buymeacoffee.com/tiriana"
}

# Parse command-line arguments
for arg in "$@"
do
    case $arg in
        --silent)
        silent_mode=true
        shift # Remove --silent from processing
        ;;
        --mouse-distance=*)
        mouse_distance="${arg#*=}"
        shift # Remove --mouse-distance=XX from processing
        ;;
        --idle-time=*)
        idle_time_threshold="${arg#*=}"
        idle_time_threshold=$((idle_time_threshold * 1000)) # Convert to milliseconds
        shift # Remove --idle-time=XX from processing
        ;;
        --sleep-duration=*)
        sleep_duration="${arg#*=}"
        shift # Remove --sleep-duration=XX from processing
        ;;
        -h|--help)
        show_help
        exit 0
        ;;
        *)
        # Unknown option
        echo "Unknown option: $arg"
        show_help
        exit 1
        ;;
    esac
done

post_move_delay=$((idle_time_threshold / 1000 + 1)) # +1 second to ensure it's longer

# Function to check if user is active
function is_user_active() {
    local idle_time=$(xprintidle)

    if (( idle_time < idle_time_threshold )); then
        if ! $silent_mode && [ "$user_active" = false ]; then
            echo -e "\nUser activity detected, pausing..."
            user_active=true
        fi
        return 0 # User is active
    else
        if ! $silent_mode && [ "$user_active" = true ]; then
            echo "Resuming auto mouse movement..."
            user_active=false
        fi
        return 1 # User is idle
    fi
}

# Main loop
while true; do
    if is_user_active; then
        sleep $sleep_duration
    else
        if ! $silent_mode; then
            echo -n "#"
        fi
        xdotool mousemove_relative --sync -- $((mouse_distance * direction)) 0
        direction=$((direction * -1)) # Change direction
        sleep $post_move_delay # Wait for a while after simulating movement
    fi
done
