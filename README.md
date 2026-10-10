# CRYPT3X OS Lite for ANS11 — Privacy-Focused Fork

**Privacy-optimized lightweight OS** built from dual bases:
- **ROCKNIX** (AveyondFly/distribution_rocknix) — RK3326 device support, DTB selection, immutable Linux
- **ArkOS4Clone** (lcdyk0517/arkos4clone) — RK3326 quirk handling, device tree overlays, boot optimization

Removed all non-essential apps. Includes **only**:
- **Brave** — privacy-focused web browser
- **DNS resolver** — stubby / dnscrypt-proxy (configurable)
- **VPN/Proxy** — Proton VPN, ReThink, or Portmaster for privacy routing
- **F-Droid** — open-source app store
- **Portmaster** — firewall & network monitor
- **Keystore** — secure credential vault (encrypted)

## Target Device
- **ANS11** (RK3326, RK3326S compatible)
- 32 GB microSD card (< 16 GB packed image)
- Linux 4.4 kernel (legacy BSP)

## Quick Start

### Build
```bash
git clone https://github.com/RedTeamFortress666/crypt3x-os-lite-ans11-privacy.git
cd crypt3x-os-lite-ans11-privacy

# Prepare environment
./scripts/setup-ans11.sh

# Build image
./build.sh rocknix arkos4clone

# Flash to SD (>= 32GB)
sudo dd if=out/crypt3x-ans11-lite-privacy.img of=/dev/sdX bs=4M status=progress conv=fsync
```

### Flash
1. Verify SHA-256 of `.img`
2. Use balenaEtcher, Raspberry Pi Imager, or `dd`
3. Boot ANS11 with card in **OS microSD slot** (not secondary ROM slot)
4. First boot ~2–3 minutes
5. Set vault PIN on first launch

## Architecture

```
crypt3x-os-lite-ans11-privacy/
├── README.md                    # This file
├── LICENSE                      # MIT
├── Makefile
├── build.sh                     # Main build entry point
│
├── board/ans11/
│   ├── board.conf              # ANS11 hardware profile
│   ├── kernel.config           # Linux 4.4 defconfig
│   ├── dtb/                    # Device trees
│   │   ├── rk3326-ans11.dtb
│   │   └── rk3326-ans11-quirks.dtb
│   ├── overlays/
│   │   ├── 99-ans11-privacy.rules    # udev rules (no telemetry)
│   │   └── mipi-panel.dtbo          # Display config
│   └── uboot/
│       ├── boot.ini                 # U-Boot bootloader config
│       └── extlinux.conf            # Extlinux fallback
│
├── rootfs/
│   ├── etc/
│   │   ├── fstab                   # Filesystem mount table
│   │   ├── os-release              # OS metadata
│   │   ├── hostname
│   │   ├── locale.conf
│   │   ├── modules                 # Kernel modules to load
│   │   ├── security/
│   │   │   ├── pam.d/              # PAM auth config
│   │   │   └── sudo                # Sudo config (limited)
│   │   ├── systemd/
│   │   │   ├── system/
│   │   │   │   ├── crypt3x-privacy-init.service
│   │   │   │   ├── vault-lock.service
│   │   │   │   ├── dns-resolver.service
│   │   │   │   ├── vpn-proxy.service
│   │   │   │   ├── portmaster.service
│   │   │   │   └── keystore.service
│   │   │   └── logind.conf         # Session management
│   │   ├── dnsmasq.conf            # Local DNS resolver config
│   │   ├── wireguard/              # VPN configs (if using WireGuard)
│   │   └── dnscrypt-proxy2/        # DNSCrypt resolver
│   │
│   ├── usr/
│   │   ├── local/bin/
│   │   │   ├── vault-cli           # Keystore CLI tool
│   │   │   ├── vpn-switch          # VPN selection script
│   │   │   ├── dns-check           # DNS privacy verifier
│   │   │   └── privacy-audit       # Privacy audit tool
│   │   ├── share/
│   │   │   ├── applications/       # .desktop files (minimal)
│   │   │   ├── icons/              # Icon set
│   │   │   └── doc/
│   │   │       └── PRIVACY.md      # Privacy policy & design
│   │   └── lib/
│   │       ├── systemd/            # Systemd modules
│   │       └── pkgconfig/
│   │
│   ├── opt/
│   │   ├── crypt3x/
│   │   │   ├── launcher            # Minimal launcher binary
│   │   │   ├── brave-config/       # Brave privacy preset
│   │   │   ├── fdroid-repos.conf
│   │   │   ├── portmaster.conf
│   │   │   └── keystore/
│   │   │       ├── vault.db        # Encrypted credential store
│   │   │       └── keys/           # Signing/encryption keys
│   │   ├── brave/                  # Brave browser
│   │   ├── fdroid/                 # F-Droid app store
│   │   └── proton-vpn/             # Proton VPN CLI
│   │
│   ├── boot/
│   │   ├── cmdline.txt             # Kernel command line
│   │   └── config.txt              # Boot partition config
│   │
│   └── root/
│       └── .bashrc                 # Root shell (minimal)
│
├── packages/
│   ├── base.list                   # Core system packages
│   ├── privacy.list                # Privacy-essential packages
│   ├── network.list                # Network/VPN packages
│   └── firmware.list               # Device firmware files
│
├── apps/
│   ├── brave/
│   │   ├── build.sh
│   │   ├── privacy-policy.conf     # Hardened Brave config
│   │   └── extensions.json         # Privacy extensions
│   ├── fdroid/
│   │   ├── build.sh
│   │   └── repos.json              # F-Droid repo list
│   ├── portmaster/
│   │   ├── build.sh
│   │   └── firewall-rules.conf
│   └── launcher/
│       ├── launcher.c
│       ├── Makefile
│       └── config.json             # UI config
│
├── vpn/
│   ├── wireguard-setup.sh          # WireGuard tunnel config
│   ├── proton-vpn-config.sh        # Proton VPN setup
│   ├── rethink-setup.sh            # ReThink proxy setup
│   └── dns-privacy-check.sh        # DNS leak detection
│
├── keystore/
│   ├── vault.c                     # Encrypted credential store (LUKS2)
│   ├── vault-cli.sh                # Vault CLI tool
│   ├── Makefile
│   └── keyring.conf                # Key derivation config
│
├── scripts/
│   ├── setup-ans11.sh              # ANS11 environment setup
│   ├── trim-rootfs.sh              # Remove bloat
│   ├── apply-rocknix-dtb.sh        # Import ROCKNIX RK3326 device trees
│   ├── apply-arkos4clone-quirks.sh # Import ArkOS4Clone quirk handling
│   ├── build-image.sh              # GPT/ext4 image builder
│   ├── sign-image.sh               # SHA-256 verification
│   └── privacy-audit.sh            # Telemetry/security check
│
├── patches/
│   ├── 0001-ans11-lite-boot.patch
│   ├── 0002-privacy-kernel-cmdline.patch
│   ├── 0003-remove-telemetry-services.patch
│   ├── 0004-hardened-systemd.patch
│   └── 0005-rocknix-device-tree-ans11.patch
│
├── config/
│   ├── defconfig                   # Kernel defconfig
│   ├── minimal-boot.conf           # Boot config (no bloat)
│   ├── privacy.conf                # Privacy kernel params
│   ├── dns-privacy.conf            # DNS hardening
│   ├── vpn-routes.conf             # VPN routing rules
│   └── env.conf                    # Build environment
│
└── .gitignore
```

## Key Design Principles

### 1. **Privacy-First**
- No telemetry services enabled
- DNS-over-HTTPS (DoH) or DNSCrypt by default
- All network traffic routes through VPN/proxy by default
- Encrypted keystore for credentials
- No cloud sync without explicit opt-in

### 2. **Minimal & Lightweight**
- < 16 GB packed image (fits 32 GB card)
- Only essential services running
- Shell launcher (no heavy UI)
- Single-user vault desk mode

### 3. **Dual-Base Compatibility**
- ROCKNIX device tree + DTB selector for ANS11 variants
- ArkOS4Clone quirk system for hardware compatibility
- Shared bootloader & kernel (Linux 4.4)
- Merged udev rules & device detection

### 4. **Security**
- Mandatory vault PIN on boot
- Duress PIN factory-resets on entry
- Read-only /flash partition (except updates)
- Encrypted /etc/crypt3x/credentials
- SELinux or AppArmor profiles (minimal)

## Essential Apps

### Browser: Brave
```bash
/opt/brave/brave --user-data-dir=/opt/crypt3x/brave-profile
```
- Privacy-by-default settings
- No Google sync
- uBlock Origin pre-configured

### DNS: DNSCrypt or Stubby
```bash
# DNSCrypt (resolves to encrypted DNS)
sudo systemctl start dnscrypt-proxy2

# Stubby (DoH via getdns)
sudo systemctl start stubby
```

### VPN/Proxy Options
1. **Proton VPN CLI**
   ```bash
   proton-vpn-cli connect
   ```
2. **ReThink (Android-style proxy)**
   ```bash
   systemctl start rethink-proxy
   ```
3. **Portmaster (firewall monitor)**
   ```bash
   portmaster --start
   ```

### F-Droid
```bash
/opt/fdroid/fdroid update
```
- Open-source app repository
- Privacy-focused app filtering

### Keystore: Encrypted Vault
```bash
# Store credential
vault-cli set service_name username password

# Retrieve credential
vault-cli get service_name

# Lock vault
vault-cli lock
```

## Boot Flow

1. **U-Boot** (RK3326 miniloader)
   - Load kernel & DTB
   - Apply device-specific DTB overlay
   - Hand off to Linux

2. **Kernel** (Linux 4.4 legacy BSP)
   - Mount /flash (read-only)
   - Mount /root (ext4, encrypted)
   - Execute /sbin/init

3. **Systemd**
   - Load privacy services (DNS, VPN, Portmaster)
   - Initialize keystore (lock until PIN entry)
   - Start minimal launcher

4. **Launcher**
   - Show vault lock screen
   - Prompt for PIN
   - Display home desk (Mail / F-Droid / Brave / Portmaster)

## Network Stack

```
[Application]
    ↓
[Portmaster] ← Monitor & filter
    ↓
[DNSCrypt] ← Encrypted DNS
    ↓
[VPN Client] ← Privacy tunnel
    ↓
[WAN]
```

## Build Variables

```bash
# Device board
BOARD=ans11

# Image size (GiB)
IMAGE_SIZE_GIB=8

# Base OS (rocknix or arkos4clone)
BASE_OS=rocknix

# Privacy mode (strict, standard, minimal)
PRIVACY_MODE=strict

# Build output
OUT_DIR=out/crypt3x-ans11-lite-privacy
```

## Supported Devices (ANS11 Variants)

- ANS11 (base RK3326)
- Similar RK3326 handhelds (requires DTB tuning)

## Known Limitations

- No WiFi UI (command-line only for privacy)
- Minimal Bluetooth support (privacy concern)
- No cloud sync by default
- Single-user system

## Contributing

Pull requests welcome. Please include:
- Privacy justification for any new packages
- DTB device tree changes (reference ROCKNIX/ArkOS4Clone)
- Security audit for new services

## License

MIT — See `LICENSE`

## Sources

- **ROCKNIX**: https://github.com/AveyondFly/distribution_rocknix (branch: `next`)
- **ArkOS4Clone**: https://github.com/lcdyk0517/arkos4clone (branch: `main`)
- **Original CRYPT3X OS Lite (R36S)**: https://github.com/RedTeamFortress666/Main
