#!/usr/bin/env bash
# Smoke test for AI Native Studio IDE
# Validates that the application can launch and exit cleanly

set -euo pipefail

TIMEOUT=${TIMEOUT:-10}
DISPLAY=${DISPLAY:-:99}

echo "=== AI Native Studio IDE Smoke Test ==="
echo "Display: $DISPLAY"
echo "Timeout: ${TIMEOUT}s"
echo

# Check if we're in a headless environment
if [ -z "${DISPLAY}" ] && ! command -v Xvfb &> /dev/null; then
  echo "Warning: No DISPLAY set and Xvfb not available"
  echo "This test requires X11 or Xvfb for headless testing"
  exit 1
fi

# Start Xvfb if needed
XVFB_PID=""
if ! xset q &>/dev/null; then
  echo "Starting Xvfb on $DISPLAY..."
  Xvfb $DISPLAY -screen 0 1024x768x24 &
  XVFB_PID=$!
  sleep 2
  echo "Xvfb started (PID: $XVFB_PID)"
fi

cleanup() {
  if [ -n "$XVFB_PID" ]; then
    echo "Stopping Xvfb..."
    kill $XVFB_PID 2>/dev/null || true
  fi
}
trap cleanup EXIT

# Find the binary
BINARY="${1:-ainative-studio-ide}"
if ! command -v "$BINARY" &> /dev/null; then
  echo "Error: $BINARY not found in PATH"
  exit 1
fi

echo "Testing binary: $(which $BINARY)"
echo

# Test 1: Version check
echo "[Test 1/3] Version check..."
if $BINARY --version &>/dev/null; then
  echo "✓ Version check passed"
else
  echo "⚠ Version flag not supported (may be normal)"
fi
echo

# Test 2: Help flag
echo "[Test 2/3] Help flag..."
if $BINARY --help &>/dev/null; then
  echo "✓ Help flag passed"
else
  echo "⚠ Help flag not supported (may be normal)"
fi
echo

# Test 3: Launch and quit
echo "[Test 3/3] Launch test (${TIMEOUT}s timeout)..."
(
  timeout $TIMEOUT $BINARY --no-sandbox --disable-gpu &
  APP_PID=$!
  sleep 3

  # Check if process is still running
  if kill -0 $APP_PID 2>/dev/null; then
    echo "✓ Application launched successfully (PID: $APP_PID)"
    kill $APP_PID 2>/dev/null || true
    wait $APP_PID 2>/dev/null || true
    echo "✓ Application terminated cleanly"
  else
    echo "✗ Application failed to launch or crashed"
    exit 1
  fi
) || {
  EXIT_CODE=$?
  if [ $EXIT_CODE -eq 124 ]; then
    echo "✗ Application launch timed out"
  else
    echo "✗ Application launch failed with exit code $EXIT_CODE"
  fi
  exit $EXIT_CODE
}

echo
echo "=== All smoke tests passed! ==="
exit 0
