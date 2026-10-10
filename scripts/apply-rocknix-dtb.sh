#!/bin/bash
# SPDX-License-Identifier: MIT
# Setup CRYPT3X OS Lite ANS11 toolchain and dependency scaffold
set -euo pipefail

ROOT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"

export DEBIAN_FRONTEND=noninteractive

which git >/dev/null 2>&1 || { echo "ERROR: git is required" >&2; exit 1; }
which make >/dev/null 2>&1 || { echo "ERROR: make is required" >&2; exit 1; }
which gcc >/dev/null 2>&1 || { echo "ERROR: gcc is required" >&2; exit 1; }

mkdir -p "$ROOT_DIR/out" "$ROOT_DIR/build" "$ROOT_DIR/downloads"

if [ ! -d "$ROOT_DIR/rocknix" ]; then
  git clone --depth=1 -b next https://github.com/AveyondFly/distribution_rocknix.git "$ROOT_DIR/rocknix"
fi

if [ ! -d "$ROOT_DIR/arkos4clone" ]; then
  git clone --depth=1 -b main https://github.com/lcdyk0517/arkos4clone.git "$ROOT_DIR/arkos4clone"
fi

mkdir -p "$ROOT_DIR/board/ans11/dtb" "$ROOT_DIR/board/ans11/overlays" "$ROOT_DIR/board/ans11/uboot"

echo "ANS11 setup complete."
echo "Next: ./scripts/apply-rocknix-dtb.sh && ./scripts/apply-arkos4clone-quirks.sh"
