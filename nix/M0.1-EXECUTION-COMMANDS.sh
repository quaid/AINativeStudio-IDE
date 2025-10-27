#!/usr/bin/env bash
# M0.1 Hash Generation - Execution Commands
# Run these commands on a system with Nix installed

set -euo pipefail

echo "=== M0.1: Hash Generation for v1.1.0 ==="
echo

# Navigate to package directory
cd "$(dirname "$0")/pkgs/applications/editors/ainative-studio-ide"

echo "[Step 1/6] Verifying tag v1.1.0 exists..."
TAG_INFO=$(curl -s https://api.github.com/repos/AINative-Studio/AINativeStudio-IDE/git/refs/tags/v1.1.0)
if echo "$TAG_INFO" | grep -q "v1.1.0"; then
  COMMIT_SHA=$(echo "$TAG_INFO" | jq -r '.object.sha')
  echo "✓ Tag v1.1.0 exists (commit: $COMMIT_SHA)"
else
  echo "✗ Tag v1.1.0 not found!"
  exit 1
fi
echo

echo "[Step 2/6] Generating source hash with nix-prefetch-github..."
# Option 1: If nix-prefetch-github is installed
if command -v nix-prefetch-github &> /dev/null; then
  nix-prefetch-github AINative-Studio AINativeStudio-IDE --rev v1.1.0 > prefetch-output.json
  SOURCE_HASH=$(cat prefetch-output.json | jq -r .hash)
  echo "✓ Source hash generated: $SOURCE_HASH"
else
  # Option 2: Manual prefetch using nix-prefetch-url
  echo "nix-prefetch-github not found, using nix-prefetch-url..."
  SOURCE_HASH=$(nix-prefetch-url --unpack "https://github.com/AINative-Studio/AINativeStudio-IDE/archive/refs/tags/v1.1.0.tar.gz" --type sha256)
  # Convert to SRI format
  SOURCE_HASH="sha256-$(nix-hash --to-sri --type sha256 $SOURCE_HASH | cut -d: -f2)"
  echo "✓ Source hash generated: $SOURCE_HASH"
fi
echo

echo "[Step 3/6] Updating default.nix with source hash..."
# Backup original
cp default.nix default.nix.backup

# Replace placeholder hash
sed -i "s|hash = \"sha256-AAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAA=\"|hash = \"$SOURCE_HASH\"|g" default.nix
echo "✓ Updated fetchFromGitHub hash in default.nix"
echo

echo "[Step 4/6] Attempting build to extract npmDepsHash..."
echo "Note: This will fail with hash mismatch - that's expected!"
echo

# Try to build - this will fail, which is what we want
if nix-build -E 'with import <nixpkgs> {}; callPackage ./default.nix {}' 2>&1 | tee build-output.txt; then
  echo "⚠ Build succeeded unexpectedly (wrong placeholder hash?)"
else
  # Extract the npmDepsHash from error message
  if grep -q "got:" build-output.txt; then
    NPM_HASH=$(grep "got:" build-output.txt | head -1 | awk '{print $2}')
    echo
    echo "✓ Extracted npmDepsHash from error: $NPM_HASH"
  else
    echo
    echo "✗ Could not extract hash from build output"
    echo "Check build-output.txt for details"
    exit 1
  fi
fi
echo

echo "[Step 5/6] Updating default.nix with npmDepsHash..."
sed -i "s|npmDepsHash = \"sha256-AAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAA=\"|npmDepsHash = \"$NPM_HASH\"|g" default.nix
echo "✓ Updated npmDepsHash in default.nix"
echo

echo "[Step 6/6] Verifying hashes with clean build..."
rm -rf result build-output.txt

if nix-build -E 'with import <nixpkgs> {}; callPackage ./default.nix {}'; then
  echo
  echo "✓ Build succeeded! Hashes are correct."
  echo
  echo "Generated hashes:"
  echo "  Source:     $SOURCE_HASH"
  echo "  npmDepsHash: $NPM_HASH"
  echo
  echo "Result: $(readlink result)"
else
  echo
  echo "✗ Build failed. Check output for errors."
  echo "This may be due to other issues in the derivation."
  exit 1
fi

# Summary
cat > M0.1-RESULTS.txt << EOF
M0.1 Hash Generation Results
============================

Version: v1.1.0
Commit:  $COMMIT_SHA
Date:    $(date -u +"%Y-%m-%d %H:%M:%S UTC")

Hashes Generated:
-----------------
fetchFromGitHub.hash: $SOURCE_HASH
npmDepsHash:          $NPM_HASH

Files Modified:
--------------
- default.nix (both hashes updated)

Verification:
------------
✓ Tag v1.1.0 exists in upstream repository
✓ Source hash validated
✓ npmDepsHash extracted from build
✓ Clean build validates both hashes

Next Steps:
----------
1. Review default.nix changes
2. Commit changes to feature branch
3. Store results in ZeroDB
4. Notify AI Build Agent (M1.1 unblocked)

Status: M0.1 COMPLETE ✓
EOF

echo
echo "=== M0.1 COMPLETE ==="
cat M0.1-RESULTS.txt
