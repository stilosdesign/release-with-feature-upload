#!/bin/bash

set -e

echo ''

# env
echo "node version: $(node -v)"
echo "npm version: $(npm -v)"

# Define variables.
GH_API="https://api.github.com"
GH_REPO="$GH_API/repos/$GITHUB_USERNAME/$GITHUB_REPO"
GH_TAGS="$GH_REPO/releases/tags/$RELEASE_TAG"
AUTH="Authorization: token $GITHUB_TOKEN"
WGET_ARGS="--content-disposition --auth-no-challenge --no-cookie"
CURL_ARGS="-LJO#"

if [[ "$RELEASE_TAG" == 'LATEST' ]]; then
  GH_TAGS="$GH_REPO/releases/latest"
fi

# Validate token.
#curl -o /dev/null -sH "$AUTH" $GH_REPO || { echo "Error: Invalid repo, token or network issue!";  exit 1; }

# Read asset tags.
#response=$(curl -sH "$AUTH" $GH_TAGS)

LAST_RELEASE_TAG=$(curl  $GH_TAGS 2>/dev/null | jq .name | sed 's/"//g')

echo "teste: $LAST_RELEASE_TAG"
