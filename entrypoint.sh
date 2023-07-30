#!/bin/bash

set -e

echo ''

# env
echo "node version: $(node -v)"
echo "npm version: $(npm -v)"

# Define variables.
AUTH="Authorization: token $GITHUB_TOKEN"
GH_API="https://api.github.com"
GH_REPO="$GH_API/repos/$GITHUB_USERNAME/$GITHUB_REPO"
TYPE_RELEASE=$GITHUB_TYPE_RELEASE
RELEASE_TAG=$GITHUB_RELEASE_TAG

# Validate is filled tag name
if [[ "$RELEASE_TAG" == ""]]; then
  # Mounted URL for get last release tag
  GH_TAGS="$GH_REPO/releases/latest" 

  # Get last release tag
  LAST_RELEASE_TAG=$(curl -sL "${GH_TAGS}" | jq -r ".tag_name")

  # Validate tag an generate new tag
  if [[ "$LAST_RELEASE_TAG" == 'null' ]]; then
    NEXT_RELEASE_TAG="v1.0.0"
  else
    major=$(awk -F'.' '{print $1}' <<< "$GET_LAST_RELEASE_TAG")
    minor=$(awk -F'.' '{print $2}' <<< "$GET_LAST_RELEASE_TAG")
    patch=$(awk -F'.' '{print $3}' <<< "$GET_LAST_RELEASE_TAG")

    # Generate new tag [major, minor, patch]
    if [[ "$TYPE_RELEASE" == "major" ]]; then
      cMajor=$(awk -F'v' '{print $2}' <<< "$major")
      major="v"$(($cMajor+1))
    fi
    if [[ "$TYPE_RELEASE" == "minor" ]]; then
      minor=$(($minorr+1))
    fi
    if [[ "$TYPE_RELEASE" == "patch" ]]; then
      patch=$(($patch+1))
    fi  
    NEXT_RELEASE_TAG+="$major.$minor.$patch"
  fi
else
  NEXT_RELEASE_TAG = RELEASE_TAG
fi

echo "new tag release: $NEXT_RELEASE_TAG"

