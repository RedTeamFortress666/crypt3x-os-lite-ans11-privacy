#!/bin/bash
# SPDX-License-Identifier: MIT
# Render the boot sequence and package it for an ANS11 build.
set -euo pipefail
ROOT="$(cd "$(dirname "$0")/.." && pwd)"
PY="$ROOT/media/render_crypt3x_boot.py"

if [ ! -f "$PY" ]; then
  echo "render_crypt3x_boot.py is missing" >&2
  exit 1
fi

python3 "$PY"
mkdir -p "$ROOT/media/bootpack"
cp -r "$ROOT/media/build" "$ROOT/media/bootpack/frames"
cat > "$ROOT/media/bootpack/boot.json" <<'EOF'
{
  "title": "C R Y P 7 E X - OS",
  "tagline": "GHO57... YOUR.... M4CH1N3",
  "palette": ["#000000", "#00D962", "#EAFEF0"],
  "frames": 132
}
EOF

echo "Boot animation frames rendered and packaged."
