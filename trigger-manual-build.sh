#!/bin/bash

# Script to trigger the manual XFCE build workflow
# You'll need to provide a GitHub Personal Access Token

echo "GitHub Manual Workflow Trigger for XFCE Container"
echo "================================================="
echo
echo "Repository: Devilblader87/gow"
echo "Workflow: Build XFCE Container (Manual)"
echo
echo "To run this script, you need a GitHub Personal Access Token with 'actions:write' permission."
echo "Get one at: https://github.com/settings/tokens"
echo
read -p "Enter your GitHub Personal Access Token: " -s GITHUB_TOKEN
echo

if [ -z "$GITHUB_TOKEN" ]; then
    echo "Error: No token provided"
    exit 1
fi

echo "Triggering workflow with enhanced settings..."

curl -X POST \
  -H "Accept: application/vnd.github.v3+json" \
  -H "Authorization: token $GITHUB_TOKEN" \
  https://api.github.com/repos/Devilblader87/gow/actions/workflows/build-xfce-manual.yml/dispatches \
  -d '{
    "ref": "main",
    "inputs": {
      "push_to_registry": "true",
      "image_tag": "enhanced",
      "use_existing_base": "true",
      "base_app_image": "ghcr.io/games-on-whales/base-app:edge",
      "no_cache": "false"
    }
  }'

echo
echo "Workflow triggered! Check progress at:"
echo "https://github.com/Devilblader87/gow/actions"
