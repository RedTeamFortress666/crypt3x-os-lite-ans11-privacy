#!/bin/bash
# SPDX-License-Identifier: MIT
# Copy ArkOS4Clone quirk handling into the ANS11 tree
set -euo pipefail

ROOT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
ARKOS_DIR="$ROOT_DIR/arkos4clone"
TARGET_DIR="$ROOT_DIR/board/ans11"
mkdir -p "$TARGET_DIR"

if [ ! -d "$ARKOS_DIR" ]; then
  echo "ArkOS4Clone repo not found. Run ./scripts/setup-ans11.sh first" >&2
  exit 1
fi

# Copy quirk and device customization artifacts from ArkOS4Clone if present
find "$ARKOS_DIR" -type f \( -iname '*quirk*' -o -iname '*battery*' -o -iname '*led*' -o -iname '*power*' \) | while read -r f; do
  cp "$f" "$TARGET_DIR/"
done

cat > "$ROOT_DIR/board/ans11/quirks.conf" <<'EOF'
DISPLAY_QUIRK=rk3326-ans11-panel
POWER_BUTTON_GPIO=41
VOLUME_UP_GPIO=24
VOLUME_DOWN_GPIO=25
POWER_LED_GPIO=23
BATTERY_CAPACITY_MAH=3500
BATTERY_CHARGE_THRESHOLD=90
BATTERY_LOW_WARNING=10
THERMAL_LIMIT_TEMP=65
THERMAL_SHUTDOWN_TEMP=80
AUDIO_CODEC=es8323
WIFI_MODULE=rtl8188eu
BT_UART=/dev/ttyS1
EOF

echo "ArkOS4Clone quirk integration complete."
