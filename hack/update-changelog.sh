#!/usr/bin/env bash
set -euo pipefail
IFS=$'\n\t'

# require yq
command -v yq >/dev/null 2>&1 || {
  echo >&2 'yq (https://github.com/mikefarah/yq) is not installed. Aborting.'
  exit 1
}

if [ "$#" -lt 2 ]; then
    echo 'Usage: change_kind description'
    echo 'Example: ./update-changelog.sh "added" "Migrate chart"'
    exit 1
fi

# Get arguments
change_kind="$1"
export change_kind
shift

description="$1"
export description

# Validate change_kind
if [[ ! "$change_kind" =~ ^(changed|fixed|added)$ ]]; then
  echo "Invalid change kind: $change_kind. Allowed values are 'changed', 'fixed', or 'added'." >&2
  exit 1
fi

# Get the directory of the current script
script_dir="$(dirname "$0")"

# Define the chart directory
CHART_DIR="$script_dir/../charts/homarr"
meta_file="$CHART_DIR/Chart.yaml"

# Check if the Chart.yaml file exists
if [ ! -f "$meta_file" ]; then
  echo >&2 "Invalid file: $meta_file"
  exit 1
fi

# YAML expression to replace changelog with the new entry formatted as a block scalar
expression='.annotations."artifacthub.io/changes" = (["- kind: " + env(change_kind), "  description: " + env(description)] | join("\n"))'

# Update the changelog in Chart.yaml
yq --inplace "$expression" "$meta_file"
echo "Updated homarr changelog"
