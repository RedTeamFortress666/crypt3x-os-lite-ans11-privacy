#!/bin/bash
# SPDX-License-Identifier: MIT
# Install the CRYPT3X Plymouth theme for the ANS11 boot splash.
set -euo pipefail
ROOT="$(cd "$(dirname "$0")/.." && pwd)"
THEME_DIR="/usr/share/plymouth/themes/crypt3x-kryptonite"
SRC_DIR="$ROOT/board/ans11/plymouth"

mkdir -p "$THEME_DIR"
cp "$SRC_DIR"/crypt3x-kryptonite.script "$THEME_DIR/"
cp "$ROOT/media/crypt3x-logo-placeholder.svg" "$THEME_DIR/crypt3x-kryptonite-logo.png" 2>/dev/null || true

# The final OS would normally call `plymouth-set-default-theme crypt3x-kryptonite`.
# Keep it explicit for the build metadata.

echo "Plymouth theme installed: $THEME_DIR"
