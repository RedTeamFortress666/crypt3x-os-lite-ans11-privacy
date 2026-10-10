#!/bin/bash
# CRYPT3X OS Lite for ANS11 — Build Script
# Combines ROCKNIX device tree + ArkOS4Clone quirks
set -euo pipefail

echo "╔════════════════════════════════════════════════════════╗"
echo "║  CRYPT3X OS Lite for ANS11 — Privacy-Focused Builder   ║"
echo "╚════════════════════════════════════════════════════════╝"
echo ""

# Load configuration
echo "[*] Loading board configuration…"
source board/ans11/board.conf
source board/ans11/quirks.conf 2>/dev/null || echo "  (quirks.conf not found yet)"

# Verify dependencies
echo "[*] Checking dependencies…"
command -v dd >/dev/null 2>&1 || { echo "ERROR: dd not found" >&2; exit 1; }
command -v mkfs.ext4 >/dev/null 2>&1 || { echo "ERROR: mkfs.ext4 not found" >&2; exit 1; }
command -v sha256sum >/dev/null 2>&1 || { echo "ERROR: sha256sum not found" >&2; exit 1; }

# Create output directory
mkdir -p "$OUT_DIR"
echo "[*] Output directory: $OUT_DIR"

# Calculate image size in bytes
IMAGE_SIZE_BYTES=$((IMAGE_SIZE_GIB * 1024 * 1024 * 1024))
echo "[*] Image size: ${IMAGE_SIZE_GIB}GB ($IMAGE_SIZE_BYTES bytes)"

# Build rootfs
echo "[*] Building rootfs…"
"${BASH_SOURCE%/*}/scripts/build-rootfs.sh" "$OUT_DIR"

# Build GPT image
echo "[*] Creating GPT disk image…"
"${BASH_SOURCE%/*}/scripts/build-image.sh" "$OUT_DIR" "$IMAGE_SIZE_BYTES"

# Sign & verify
echo "[*] Computing SHA-256…"
sha256sum "$OUT_DIR/crypt3x-ans11-lite-privacy.img" > "$OUT_DIR/SHA256SUMS"
cat "$OUT_DIR/SHA256SUMS"

echo ""
echo "[✓] Build complete!"
echo "  Image: $OUT_DIR/crypt3x-ans11-lite-privacy.img"
echo "  SHA256: $(cut -d' ' -f1 "$OUT_DIR/SHA256SUMS")"
echo ""
echo "To flash to microSD (>= 32GB):"
echo "  sudo dd if=$OUT_DIR/crypt3x-ans11-lite-privacy.img of=/dev/sdX bs=4M status=progress conv=fsync"
echo ""
