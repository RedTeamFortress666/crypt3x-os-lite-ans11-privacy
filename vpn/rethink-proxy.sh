#!/bin/bash
# SPDX-License-Identifier: MIT
# Minimal Proton VPN bootstrap stub for CRYPT3X Lite
set -euo pipefail

if command -v protonvpn >/dev/null 2>&1; then
  protonvpn connect
else
  echo "Proton VPN client not installed; install via package manager or F-Droid repo."
fi
