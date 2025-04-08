#!/bin/bash

set -e

if [ -z "$1" ] || [ -z "$2" ]; then
  echo "Usage: $0 <build_number> <destination>"
  exit 1
fi

if [ -z "$BUILDKITE_API_TOKEN" ] ; then
    echo "Env var BUILDKITE_API_TOKEN is not set"
    exit 1
fi

BUILD_NUMBER=$1
ORG_SLUG="talon-dot-one"
PIPELINE_SLUG="talon-service"
BUILDKITE_API_URL="https://api.buildkite.com/v2/organizations/$ORG_SLUG/pipelines/$PIPELINE_SLUG/builds/$BUILD_NUMBER/artifacts"
DOWNLOAD_DIR="$2"

mkdir -p "$DOWNLOAD_DIR"

function requestGetArtifacts() {
	curl -s -H "Authorization: Bearer $BUILDKITE_API_TOKEN" "$BUILDKITE_API_URL"
}

# Liists artifacts in 2 columns: download_url and filename
function listArtifacts() {
    requestGetArtifacts | jq -r '.[] | select(.filename | test("\\.coverage\\.out$")) | "\(.download_url) \(.filename)" '
}

listArtifacts | while read ARTIFACT_URL FILENAME; do
    echo "Downloading artifact from: $ARTIFACT_URL"
    curl -L -J -H "Authorization: Bearer $BUILDKITE_API_TOKEN" "$ARTIFACT_URL" -o "$DOWNLOAD_DIR/$FILENAME"
done

