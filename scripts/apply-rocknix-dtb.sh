#!/bin/bash
# Import ROCKNIX RK3326 device trees for ANS11
set -euo pipefail

echo "[ROCKNIX] Extracting RK3326 device trees…"

ROCKNIX_DTB_PATH="rocknix/projects/ROCKNIX/devices/RK3326"

if [ ! -d "$ROCKNIX_DTB_PATH" ]; then
  echo "ERROR: ROCKNIX device tree directory not found at $ROCKNIX_DTB_PATH" >&2
  exit 1
fi

# Create target DTB directory
mkdir -p board/ans11/dtb

# Copy generic RK3326 device tree sources (if available)
echo "[*] Searching for RK3326 .dts files…"
if [ -d "$ROCKNIX_DTB_PATH/sources" ]; then
  find "$ROCKNIX_DTB_PATH/sources" -name '*.dts' -o -name '*.dtsi' | while read -r dts; do
    echo "  Found: $(basename "$dts")"
    cp "$dts" board/ans11/dtb/
  done
else
  echo "  (No .dts sources found; using prebuilt .dtb)"
fi

# Copy compiled DTBs
echo "[*] Copying prebuilt .dtb files…"
find "$ROCKNIX_DTB_PATH" -name 'rk3326*.dtb' | while read -r dtb; do
  filename=$(basename "$dtb")
  echo "  Copying: $filename"
  cp "$dtb" board/ans11/dtb/
done

# List DTB device tree selector config
echo "[*] Device tree selector mappings:…"
if [ -f "$ROCKNIX_DTB_PATH/packages/rk3326-dtb-select/dtb_selector.py" ]; then
  echo "  (Reference Python selector for ANS11 variant mapping)"
  grep -i "rk3326.*dtb" "$ROCKNIX_DTB_PATH/packages/rk3326-dtb-select/dtb_selector.py" | head -5
fi

# Copy device tree overlays
echo "[*] Copying device tree overlays…"
mkdir -p board/ans11/overlays
if [ -d "$ROCKNIX_DTB_PATH/config/overlays" ]; then
  cp "$ROCKNIX_DTB_PATH/config/overlays"/*.dtso board/ans11/overlays/ 2>/dev/null || echo "  (No .dtso overlays found)"
fi

echo "[✓] ROCKNIX RK3326 device trees imported to board/ans11/dtb/"
echo ""
echo "Next: ./scripts/apply-arkos4clone-quirks.sh"
