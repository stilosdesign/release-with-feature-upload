#!/bin/bash

set -e

echo ''

# versions
echo "node version: $(node -v)"
echo "npm version: $(npm -v)"

# Define variables locales.
auth=$GITHUB_TOKEN
gh_api="https://api.github.com"
gh_repo="$gh_api/repos/$GITHUB_USERNAME/$GITHUB_REPO"
gh_releases="$gh_api/repos/$GITHUB_USERNAME/$GITHUB_REPO/releases?access_token=$auth"
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
    major=$(awk -F'.' '{print $1}' <<< "$last_release_tag")
    minor=$(awk -F'.' '{print $2}' <<< "$last_release_tag")
    patch=$(awk -F'.' '{print $3}' <<< "$last_release_tag")

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

# echo "my token: $GITHUB_TOKEN"
# Create new release
data_release=''
data_release+='{"tag_name":"'
data_release+=$next_release_tag
data_release+='","target_commitish":"main"}'

echo "data_release: $data_release"

response=$(curl -H "Authorization: token $GITHUB_TOKEN" --data $data_release $gh_releases)
response_data=$(echo $response | grep upload_url)

if [[ $? -eq 0 ]]; then
  echo "Release created"
  
else
  echo "Error creating release!"
  return
fi

# echo "new tag release: $next_release_tag"


