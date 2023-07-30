#!/bin/bash

set -e

echo ''

# versions
echo "node version: $(node -v)"
echo "npm version: $(npm -v)"

# Define variables locales.
auth="Authorization: token $GITHUB_TOKEN"
gh_api="https://api.github.com"
gh_repo="$gh_api/repos/$GITHUB_USERNAME/$GITHUB_REPO"
type_release=$GITHUB_TYPE_RELEASE
release_tag=$GITHUB_RELEASE_TAG

# Validate is filled tag name
if [[ "$release_tag" == "" ]]; then
  # Mounted URL for get last release tag
  gh_tags="$gh_repo/releases/latest" 

  # Get last release tag
  last_release_tag=$(curl -sL "${gh_tags}" | jq -r ".tag_name")

  # Validate tag an generate new tag
  if [[ "$last_release_tag" == 'null' ]]; then
    next_release_tag="v1.0.0"
  else
    major=$(awk -F'.' '{print $1}' <<< "$LAST_RELEASE_TAG")
    minor=$(awk -F'.' '{print $2}' <<< "$LAST_RELEASE_TAG")
    patch=$(awk -F'.' '{print $3}' <<< "$LAST_RELEASE_TAG")

    # Generate new tag [major, minor, patch]
    if [[ "$type_release" == "major" ]]; then
      cMajor=$(awk -F'v' '{print $2}' <<< "$major")
      major="v"$(($cMajor+1))
    fi
    if [[ "$type_release" == "minor" ]]; then
      minor=$(($minorr+1))
    fi
    if [[ "$type_release" == "patch" ]]; then
      patch=$(($patch+1))
    fi  
    next_release_tag="$major.$minor.$patch"
  fi
else
  next_release_tag=$release_tag
fi

echo "new tag release: $next_release_tag"

