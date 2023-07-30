#!/bin/bash

set -e

echo ''

# env
echo "node version: $(node -v)"
echo "npm version: $(npm -v)"

# Define variables.
GH_API="https://api.github.com"
GH_REPO="$GH_API/repos/$GITHUB_USERNAME/$GITHUB_REPO"
AUTH="Authorization: token $GITHUB_TOKEN"

# Mounted URL for get last release tag
GH_TAGS="$GH_REPO/releases/latest" 

# Get last release tag
GET_LAST_RELEASE_TAG=$(curl -sL "${GH_TAGS}" | jq -r ".tag_name")

echo GET_LAST_RELEASE_TAG

