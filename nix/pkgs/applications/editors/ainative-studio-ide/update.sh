#!/usr/bin/env bash
# Update script for r-ryantm automation
# This script fetches the latest release and updates the derivation

set -euo pipefail

# Fetch latest release info from GitHub
latest_tag=$(curl -s https://api.github.com/repos/AINative-Studio/AINativeStudio-IDE/releases/latest | jq -r .tag_name)
latest_version="${latest_tag#v}" # Remove 'v' prefix if present

echo "Latest version: $latest_version"

# Prefetch the source tarball
src_hash=$(nix-prefetch-url --unpack "https://github.com/AINative-Studio/AINativeStudio-IDE/archive/${latest_tag}.tar.gz")

echo "Source hash: $src_hash"

# Update the version in the derivation
# This requires the update-source-version tool from nixpkgs
if command -v update-source-version &> /dev/null; then
  update-source-version ainative-studio-ide "$latest_version" "$src_hash"
  echo "Updated to version $latest_version"
else
  echo "Warning: update-source-version not found. Manual update required."
  echo "Version: $latest_version"
  echo "Hash: $src_hash"
fi
