#!/bin/bash

# Check if Helm is installed
if ! command -v helm &> /dev/null; then
    echo "Helm is not installed. Please install Helm before running this script."
    exit 1
fi

# Get the directory of the current script
script_dir="$(dirname "$0")"

# Set the path to the charts directory relative to the repository root
charts_directory="$script_dir/../charts"

# Check if the chart directory exists
if [ ! -d "$charts_directory/homarr" ]; then
    echo "Chart directory not found: $charts_directory/homarr"
    exit 1
fi

# Run the helm lint command
helm lint "$charts_directory/homarr"
