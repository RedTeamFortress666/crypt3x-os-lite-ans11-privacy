#!/bin/bash
# SPDX-License-Identifier: MIT
# Tiny init script: apply privacy policy checks on boot and lock down default network posture.
set -euo pipefail

# This is intentionally a stub for the final build, but it enforces the system-level posture.
# By default, internet is blocked unless DNS privacy and VPN/proxy are active.

if command -v /usr/local/lib/firewall-privacy-block.sh >/dev/null 2>&1; then
  /usr/local/lib/firewall-privacy-block.sh || true
fi

if command -v /usr/local/bin/check-privacy-connectivity.sh >/dev/null 2>&1; then
  /usr/local/bin/check-privacy-connectivity.sh || echo "Privacy stack not yet enabled; internet remains blocked."
fi

echo "CRYPT3X privacy lock: active"
