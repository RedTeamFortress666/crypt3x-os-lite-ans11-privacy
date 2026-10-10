#!/bin/bash
# Setup CRYPT3X OS Lite build environment for ANS11
set -euo pipefail

echo "[CRYPT3X] ANS11 Privacy-Lite OS — Build Setup"

# Check prerequisites
command -v git >/dev/null 2>&1 || { echo "ERROR: git not found" >&2; exit 1; }
command -v make >/dev/null 2>&1 || { echo "ERROR: make not found" >&2; exit 1; }
command -v sudo >/dev/null 2>&1 || { echo "ERROR: sudo not found" >&2; exit 1; }

# Create build directories
echo "[*] Creating build directories…"
mkdir -p out/crypt3x-ans11-lite-privacy/{boot,rootfs,overlay}
mkdir -p build/{kernel,uboot,dtb}
mkdir -p downloads

# Import ROCKNIX device trees
echo "[*] Importing ROCKNIX RK3326 device trees…"
if [ ! -d rocknix ]; then
  git clone --depth=1 -b next https://github.com/AveyondFly/distribution_rocknix.git rocknix
fi

# Import ArkOS4Clone quirk handling
echo "[*] Importing ArkOS4Clone RK3326 support…"
if [ ! -d arkos4clone ]; then
  git clone --depth=1 -b main https://github.com/lcdyk0517/arkos4clone.git arkos4clone
fi

# Copy device trees
echo "[*] Extracting RK3326 device trees…"
if [ -d rocknix/projects/ROCKNIX/devices/RK3326 ]; then
  find rocknix/projects/ROCKNIX/devices/RK3326 -name '*.dtb' -o -name '*.dts' | head -10
  echo "  Found ROCKNIX RK3326 device tree sources"
fi

# Setup kernel config
echo "[*] Preparing Linux 4.4 kernel configuration…"
mkdir -p board/ans11/kernel
if [ -f "arkos4clone/kernel.config" ]; then
  cp arkos4clone/kernel.config board/ans11/kernel.config
else
  echo "# RK3326 Linux 4.4 defconfig (stub)" > board/ans11/kernel.config
  echo "CONFIG_ARM=y" >> board/ans11/kernel.config
  echo "CONFIG_ARM64=y" >> board/ans11/kernel.config
  echo "CONFIG_ARCH_ROCKCHIP=y" >> board/ans11/kernel.config
fi

# Load board configuration
echo "[*] Loading ANS11 board profile…"
source board/ans11/board.conf
echo "  Board: $BOARD_NAME ($SOC)"
echo "  Privacy Mode: $PRIVACY_MODE"
echo "  Target Image: ${IMAGE_SIZE_GIB}GB"
echo "  Vault Lock: $VAULT_LOCK_ON_BOOT"

echo ""
echo "[✓] Setup complete. Ready to build."
echo ""
echo "Next steps:"
echo "  1. ./scripts/apply-rocknix-dtb.sh      # Apply ROCKNIX DTB"
echo "  2. ./scripts/apply-arkos4clone-quirks.sh # Apply ArkOS4Clone quirks"
echo "  3. ./build.sh                          # Build image"
