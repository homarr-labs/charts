#!/bin/bash

# Check if Helm is installed
if ! command -v helm &> /dev/null; then
    echo "Helm is not installed. Please install Helm before running this script."
    exit 1
fi

# Check if the correct number of arguments is provided
if [ "$#" -ne 3 ]; then
    echo "Usage: $0 <chart_name> <namespace> <chart_version>"
    exit 1
fi

# Set the path to the charts directory
charts_directory="../charts"

# Set the chart name and namespace from the command line arguments
chart_name="$1"
namespace="$2"
chart_version="$3"

# Check if the chart directory exists
if [ ! -d "$charts_directory/$chart_name" ]; then
    echo "Chart directory not found: $charts_directory/$chart_name"
    exit 1
fi

echo "$chart_version"
# Set the Helm chart path
chart_path="$charts_directory/$chart_name/$chart_name-$chart_version.tgz"

# Check if the Helm chart file exists
if [ ! -f "$chart_path" ]; then
    echo "Helm chart file not found: $chart_path"
    exit 1
fi

# Run the helm install command
helm install "$chart_name" "$chart_path" --namespace "$namespace" --create-namespace
