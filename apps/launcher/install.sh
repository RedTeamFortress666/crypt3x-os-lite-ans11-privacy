#!/bin/bash
# SPDX-License-Identifier: MIT
# Install the minimal CRYPT3X launcher.
set -euo pipefail

ROOT_DIR="$(cd "$(dirname "$0")/.." && pwd)"
TARGET="/usr/local/bin/crypt3x-launcher"

cp "$ROOT_DIR/apps/launcher/launcher.py" "$TARGET"
chmod 755 "$TARGET"

echo "Installed launcher: $TARGET"
