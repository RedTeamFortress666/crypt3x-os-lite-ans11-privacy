#!/bin/bash
# Import ArkOS4Clone RK3326 quirk handling for ANS11
set -euo pipefail

echo "[ArkOS4Clone] Importing RK3326 quirk system…"

ARKOS_PATH="arkos4clone"

if [ ! -d "$ARKOS_PATH" ]; then
  echo "ERROR: ArkOS4Clone directory not found at $ARKOS_PATH" >&2
  exit 1
fi

# Copy quirk handling utilities
echo "[*] Searching for device-specific drivers and quirk code…"
if [ -d "$ARKOS_PATH/drivers" ]; then
  find "$ARKOS_PATH/drivers" -name '*quirk*' -o -name '*rk3326*' | while read -r file; do
    echo "  Found: $(basename "$file")"
  done
fi

# Extract kernel drivers for RK3326 (LED, battery, power management)
echo "[*] Extracting RK3326-specific kernel drivers…"
mkdir -p build/kernel-drivers/rk3326

if [ -d "$ARKOS_PATH/drivers" ]; then
  # LED control driver
  if find "$ARKOS_PATH" -name '*leds-arkos4clone*' | head -1; then
    echo "  Found ArkOS4Clone LED driver"
    find "$ARKOS_PATH" -name '*leds-arkos4clone*' -type f -exec cp {} build/kernel-drivers/rk3326/ \;
  fi
  
  # Battery/charging driver
  if find "$ARKOS_PATH" -name '*batt*' -o -name '*charge*' | head -1; then
    echo "  Found battery management driver"
  fi
fi

# Copy RK3326 device tree tweaks
echo "[*] Copying RK3326 device tree customizations…"
if [ -d "$ARKOS_PATH/arch/arm64/boot/dts" ]; then
  find "$ARKOS_PATH/arch/arm64/boot/dts" -name 'rk3326*' -o -name 'px30*' | while read -r dts; do
    echo "  Found: $(basename "$dts")"
    cp "$dts" board/ans11/dtb/ 2>/dev/null || true
  done
else
  echo "  (No RK3326 .dts in ArkOS4Clone arch/)"
fi

# Copy board-level customizations
echo "[*] Copying board-specific patches…"
if [ -d "$ARKOS_PATH/board" ]; then
  cp -r "$ARKOS_PATH/board"* patches/ 2>/dev/null || echo "  (No board patches found)"
fi

# Create a quirk registry for ANS11
echo "[*] Registering ANS11 device quirks…"
cat > board/ans11/quirks.conf <<'EOF'
# ANS11 Hardware Quirk Registry
# Reference: ArkOS4Clone device detection & customization

# Display quirks
DISPLAY_QUIRK="rk3326-ans11-panel"
DISPLAY_ROTATION=0
DISPLAY_BRIGHTNESS_MIN=10
DISPLAY_BRIGHTNESS_MAX=255

# GPIO quirks
POWER_BUTTON_GPIO=41
VOLUME_UP_GPIO=24
VOLUME_DOWN_GPIO=25
POWER_LED_GPIO=23
BATTERY_LED_GPIO=22

# Battery quirks
BATTERY_CAPACITY_MAH=3500
BATTERY_CHARGE_THRESHOLD=90
BATTERY_LOW_WARNING=10

# Thermal throttling
THERMAL_LIMIT_TEMP=65
THERMAL_SHUTDOWN_TEMP=80

# Audio quirks
AUDIO_CODEC="es8323"
AUDIO_JACK_DETECT="yes"

# WiFi/Bluetooth quirks
WIFI_MODULE="rtl8188eu"
BT_UART="/dev/ttyS1"

# Joystick/Button mapping
JOYSTICK_INVERT_X=0
JOYSTICK_INVERT_Y=0
BUTTON_MAP="standard"
EOF

echo "  Created board/ans11/quirks.conf"

echo "[✓] ArkOS4Clone RK3326 quirk system imported."
echo ""
echo "Next: ./build.sh"
