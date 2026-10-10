#!/bin/bash
# SPDX-License-Identifier: MIT
# Build CRYPT3X OS Lite root filesystem for ANS11
set -euo pipefail

ROOT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
OUT_DIR="${1:-$ROOT_DIR/out/crypt3x-ans11-lite-privacy}"
ROOTFS_DIR="$OUT_DIR/rootfs"

mkdir -p "$ROOTFS_DIR/{etc,usr/local/bin,opt/crypt3x,boot,root,home/crypt3x,.config/systemd/system,var/lib/crypt3x}"
mkdir -p "$ROOTFS_DIR/usr/share/applications" "$ROOTFS_DIR/etc/systemd/system"

# Create minimal OS metadata
cat > "$ROOTFS_DIR/etc/os-release" <<'EOF'
NAME="CRYPT3X OS Lite"
ID=crypt3x-lite
PRETTY_NAME="CRYPT3X OS Lite for ANS11"
VERSION="0.1.0"
VERSION_ID="0.1.0"
BUILD_ID="ans11-lite-privacy"
HOME_URL="https://github.com/RedTeamFortress666/crypt3x-os-lite-ans11-privacy"
SUPPORT_URL="https://github.com/RedTeamFortress666/crypt3x-os-lite-ans11-privacy/issues"
EOF

# Rootfs config files
cat > "$ROOTFS_DIR/etc/fstab" <<'EOF'
LABEL=BOOT   /boot   vfat   defaults,ro  0 2
LABEL=CRYPT3X  /      ext4   defaults  0 1
tmpfs        /tmp    tmpfs   defaults,nosuid,nodev,noexec,size=512M 0 0
tmpfs        /run    tmpfs   defaults,nosuid,nodev 0 0
EOF

cat > "$ROOTFS_DIR/etc/hostname" <<'EOF'
crypt3x-ans11
EOF

cat > "$ROOTFS_DIR/etc/crypt3x/privacy.conf" <<'EOF'
privacy_mode=strict
disable_telemetry=true
disable_cloud_sync=true
enable_vpn_default=true
enable_dns_privacy=true
enable_keystore=true
enable_duress_pin=true
EOF

# Minimal systemd units
cat > "$ROOTFS_DIR/etc/systemd/system/crypt3x-privacy-init.service" <<'EOF'
[Unit]
Description=CRYPT3X Privacy Init
After=network.target

[Service]
Type=oneshot
ExecStart=/usr/local/bin/crypt3x-privacy-init.sh
RemainAfterExit=yes

[Install]
WantedBy=multi-user.target
EOF

cat > "$ROOTFS_DIR/usr/local/bin/crypt3x-privacy-init.sh" <<'EOF'
#!/bin/bash
set -euo pipefail
mkdir -p /var/lib/crypt3x /etc/crypt3x
[ -f /etc/crypt3x/privacy.conf ] || echo "privacy_mode=strict" > /etc/crypt3x/privacy.conf
[ -f /var/lib/crypt3x/keystore.json ] || echo '{}' > /var/lib/crypt3x/keystore.json
exit 0
EOF
chmod +x "$ROOTFS_DIR/usr/local/bin/crypt3x-privacy-init.sh"

# Create privacy app skeletons
mkdir -p "$ROOTFS_DIR/opt/crypt3x/brave" "$ROOTFS_DIR/opt/crypt3x/fdroid" "$ROOTFS_DIR/opt/crypt3x/portmaster" "$ROOTFS_DIR/opt/crypt3x/vpn"

# Browser profile config
cat > "$ROOTFS_DIR/opt/crypt3x/brave/profile.js" <<'EOF'
// Brave privacy preset
// Keep the browser lean: no sync, no telemetry, no default cloud
window.navigator.userAgent = window.navigator.userAgent;
EOF

# F-Droid repo metadata
cat > "$ROOTFS_DIR/opt/crypt3x/fdroid/repo.json" <<'EOF'
{
  "repo": "crypt3x-fdroid",
  "name": "CRYPT3X F-Droid",
  "type": "minimal",
  "apps": ["brave-browser", "dnscrypt-proxy", "wireguard", "portmaster"]
}
EOF

# Portmaster rules
cat > "$ROOTFS_DIR/opt/crypt3x/portmaster/rules.conf" <<'EOF'
# Minimal Portmaster policy
allow dns
allow web
allow vpn
block telemetry
block trackers
block p2p
EOF

# VPN defaults
cat > "$ROOTFS_DIR/opt/crypt3x/vpn/default.conf" <<'EOF'
# Default VPN policy for CRYPT3X Lite
provider=wireguard
route_all=true
dns=1.1.1.1,1.0.0.1
EOF

# Registry file
cat > "$ROOTFS_DIR/var/lib/crypt3x/keystore.json" <<'EOF'
{}
EOF

# Create app launcher files
cat > "$ROOTFS_DIR/usr/share/applications/crypt3x-browser.desktop" <<'EOF'
[Desktop Entry]
Type=Application
Name=Brave
Exec=/usr/bin/brave-browser %U
Icon=brave
Categories=Network;WebBrowser;
Terminal=false
EOF

cat > "$ROOTFS_DIR/usr/share/applications/crypt3x-vpn.desktop" <<'EOF'
[Desktop Entry]
Type=Application
Name=VPN
Exec=/usr/local/bin/vpn-switch
Icon=network-vpn
Categories=Network;
Terminal=true
EOF

cat > "$ROOTFS_DIR/usr/share/applications/crypt3x-keystore.desktop" <<'EOF'
[Desktop Entry]
Type=Application
Name=Keystore
Exec=/usr/local/bin/vaultctl
Icon=security-medium
Categories=Utility;Security;
Terminal=true
EOF

# Symbolic default service enablement
ln -sf /etc/systemd/system/crypt3x-privacy-init.service "$ROOTFS_DIR/etc/systemd/system/multi-user.target.wants/crypt3x-privacy-init.service" 2>/dev/null || true

echo "Built rootfs scaffold at $ROOTFS_DIR"
