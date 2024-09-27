#!/usr/bin/env bash
set -euo pipefail
IFS=$'\n\t'

# require yq
command -v yq >/dev/null 2>&1 || {
  echo >&2 'yq (https://github.com/mikefarah/yq) is not installed. Aborting.'
  exit 1
}

if [ "$#" -lt 3 ]; then
    echo 'Usage: change_kind description [chart...]'
    echo 'Example: ./update-changelog.sh "fixed" "hot fix" ../charts/homarr/Chart.yaml'
    exit 1
fi

# Get arguments

change_kind="$1"
export change_kind
shift

description="$1"
export description
shift

# Validate change_kind
if [[ ! "$change_kind" =~ ^(changed|fixed|added)$ ]]; then
  echo "Invalid change kind: $change_kind. Allowed values are 'changed', 'fixed', or 'added'." >&2
  exit 1
fi

CHARTS=()
if [ "$#" -gt 0 ]; then
  # Get changed dirs from params
  for file in "$@"; do
    CHARTS+=( "$(dirname "$file")" )
  done
else
  # Get changed dirs from uncommitted changes
  for file in $(git status --porcelain charts | grep '^M' | cut -c4-); do
    CHARTS+=( "$(dirname "$file")" )
  done
fi
CHARTS=( $(sort -u <<<"${CHARTS[*]}") )

# YAML expression to replace changelog with the new entry
expression='.annotations."artifacthub.io/changes" = ([{"kind": env(change_kind), "description": env(description)}] | @yaml | trim)'

for chart in "${CHARTS[@]}"; do (
  meta_file="$chart/Chart.yaml"
  if [ ! -f "$meta_file" ]; then echo >&2 "Invalid file: $meta_file"; exit 1; fi

  yq --inplace "$expression" "$meta_file"
  echo "Updated $(basename "$chart") changelog"
) done
