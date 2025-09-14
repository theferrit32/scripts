#!/usr/bin/env bash

open-frames() {
    local lower=$1
    local upper=$2
    local step=${3:-1}

    # Validate inputs
    if [[ ! "$lower" =~ ^[0-9]+$ ]] || [[ ! "$upper" =~ ^[0-9]+$ ]] || [[ ! "$step" =~ ^[0-9]+$ ]]; then
        echo "Error: Arguments must be positive integers" >&2
        return 1
    fi

    if [[ $lower -gt $upper ]]; then
        echo "Error: Lower bound ($lower) cannot be greater than upper bound ($upper)" >&2
        return 1
    fi

    # Build regex pattern for the range with optional leading zeros
    local range_pattern=""
    for ((i=lower; i<=upper; i+=step)); do
        if [[ -n "$range_pattern" ]]; then
            range_pattern="${range_pattern}|"
        fi
        range_pattern="${range_pattern}0*${i}"
    done

    # Find matching files using ls and grep
    local files=($(ls frame_*.png 2>/dev/null | grep -E "frame_(${range_pattern})\.png$"))

    if [[ ${#files[@]} -gt 0 ]]; then
        echo "Opening ${#files[@]} files: ${files[*]}"
        open "${files[@]}"
    else
        echo "No matching frame files found for range $lower-$upper (step $step)"
        echo "Looking for files matching: frame_[0]*{$lower..$upper}.png"
        return 1
    fi
}

# If there are arguments, run it now, otherwise do nothing
if [[ $# -gt 0 ]]; then
    open-frames "$@"
fi
