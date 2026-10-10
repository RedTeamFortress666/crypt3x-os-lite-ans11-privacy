#!/bin/bash
# SPDX-License-Identifier: MIT
# Copy ROCKNIX RK3326 DTB references into the ANS11 tree
set -euo pipefail

ROOT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
ROCKNIX_DIR="$ROOT_DIR/rocknix"
TARGET_DIR="$ROOT_DIR/board/ans11/dtb"
mkdir -p "$TARGET_DIR"

if [ ! -d "$ROCKNIX_DIR" ]; then
  echo "ROCKNIX repo not found. Run ./scripts/setup-ans11.sh first" >&2
  exit 1
fi

find "$ROCKNIX_DIR/projects/ROCKNIX/devices/RK3326" -type f \( -name '*.dtb' -o -name '*.dts' -o -name '*.dtso' \) | while read -r f; do
  cp "$f" "$TARGET_DIR/"
done

cat > "$ROOT_DIR/board/ans11/device-profile.json" <<'EOF'
{
  "board": "ANS11",
  "soc": "RK3326",
  "dtb": "rk3326-ans11.dtb",
  "bootloader": "u-boot",
  "kernel": "linux-4.4.y",
  "privacy_mode": "strict",
  "source": ["ROCKNIX", "ArkOS4Clone"]
}
EOF

echo "ROCKNIX DTB integration complete."
