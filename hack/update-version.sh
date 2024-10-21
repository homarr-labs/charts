#!/usr/bin/env bash
set -euo pipefail
IFS=$'\n\t'

# require yq
command -v yq >/dev/null 2>&1 || {
  echo >&2 'yq (https://github.com/mikefarah/yq) is not installed. Aborting.'
  exit 1
}

function _print_usage() {
  echo 'Usage: {major|minor|patch}'
  exit "${1:-0}"
}

if [ "$#" -eq 0 ]; then
  _print_usage
fi

UPDATE_TYPE="$(tr '[:upper:]' '[:lower:]' <<<"$1")"
case "$UPDATE_TYPE" in
  major) SCRIPT='[(.0 | tonumber + 1), 0, 0]' ;;
  minor) SCRIPT='[.0, (.1 | tonumber + 1), 0]' ;;
  patch) SCRIPT='[.0, .1, (.2 | tonumber + 1)]' ;;
  *) echo >&2 "Invalid update type: $UPDATE_TYPE"; _print_usage 1 ;;
esac

echo "Performing $UPDATE_TYPE version bump"

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

# Get the current version, update it, and show the change
current="$(yq '.version' "$meta_file")"
yq -i '.version |= (split(".") | '"$SCRIPT"' | join("."))' "$meta_file"
new="$(yq '.version' "$meta_file")"
echo "Updated homarr from v$current to v$new"
