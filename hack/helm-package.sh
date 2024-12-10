#!/bin/bash

# Check if Helm is installed
if ! command -v helm &> /dev/null; then
    echo "Helm is not installed. Please install Helm before running this script."
    exit 1
fi

# Set the path to the charts directory
charts_directory="../charts"

# Check if the chart directory exists
if [ ! -d "$charts_directory/homarr" ]; then
    echo "Chart directory not found: $charts_directory/homarr"
    exit 1
fi

# Run the helm template command
helm package "$charts_directory/homarr" -d "$charts_directory/homarr"
