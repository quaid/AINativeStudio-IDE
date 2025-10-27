#!/usr/bin/env bash
# Determinism test for AI Native Studio IDE
# Validates that builds are reproducible (bit-for-bit identical)

set -euo pipefail

echo "=== AI Native Studio IDE Determinism Test ==="
echo

BUILD_EXPR="${1:-.#ainative-studio-ide}"
TEMP_DIR=$(mktemp -d)

cleanup() {
  echo "Cleaning up temporary directory..."
  rm -rf "$TEMP_DIR"
}
trap cleanup EXIT

echo "Building first instance..."
nix build "$BUILD_EXPR" -o "$TEMP_DIR/build1"
BUILD1_HASH=$(nix-hash --type sha256 "$TEMP_DIR/build1")
echo "Build 1 hash: $BUILD1_HASH"
echo

echo "Building second instance..."
nix build "$BUILD_EXPR" -o "$TEMP_DIR/build2" --rebuild
BUILD2_HASH=$(nix-hash --type sha256 "$TEMP_DIR/build2")
echo "Build 2 hash: $BUILD2_HASH"
echo

echo "Comparing builds..."
if [ "$BUILD1_HASH" = "$BUILD2_HASH" ]; then
  echo "✓ Builds are identical (deterministic)"

  # Detailed comparison
  if diff -qr "$TEMP_DIR/build1" "$TEMP_DIR/build2" > /dev/null; then
    echo "✓ Bit-for-bit comparison passed"
  else
    echo "⚠ Hash match but files differ (investigate timestamps)"
    diff -r "$TEMP_DIR/build1" "$TEMP_DIR/build2" || true
  fi

  exit 0
else
  echo "✗ Builds are NOT identical (non-deterministic)"
  echo
  echo "Build 1: $BUILD1_HASH"
  echo "Build 2: $BUILD2_HASH"
  echo
  echo "Detailed diff:"
  diff -r "$TEMP_DIR/build1" "$TEMP_DIR/build2" || true
  exit 1
fi
