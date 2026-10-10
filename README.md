# CRYPT3X OS Lite for ANS11

This repo is now structured as a real privacy-lite firmware scaffold for the ANS11 RK3326 class handheld, combining the build discipline of ROCKNIX with the hardware quirk handling of ArkOS4Clone and the compact privacy-first app posture of the CRYPT3X Lite design.

## Included now
- Real build scaffolding for a rootfs and GPT image build
- Explicit ANS11 board config and bootloader config
- Privacy package manifest with concrete package names
- Browser, DNS, VPN, F-Droid, and Portmaster configuration stubs
- A keystore and PIN flow implementation for encrypted secret storage
- Device-tree source stub for a generic ANS11 RK3326 profile

## Source basis
- ROCKNIX: https://github.com/AveyondFly/distribution_rocknix (branch: next)
- ArkOS4Clone: https://github.com/lcdyk0517/arkos4clone (branch: main)

## Build
```bash
./scripts/setup-ans11.sh
./scripts/apply-rocknix-dtb.sh
./scripts/apply-arkos4clone-quirks.sh
./build.sh
```

## Privacy essentials
- Brave browser
- DNSCrypt / Stubby
- WireGuard / OpenVPN / Portmaster
- F-Droid repo integration
- Vault / keystore with PIN lock flow

## Keystore usage
```bash
./keystore/vaultctl.sh init
./keystore/vaultctl.sh set gmail myuser mypass
./keystore/vaultctl.sh get gmail
./keystore/vaultctl.sh lock
```

## Notes
- This is still a firmware scaffold and not a final image artifact; it is the reproducible starting point for the ANS11 privacy-lite port.
- The repo intentionally strips nonessential entertainment software and leaves the user-facing surface small and privacy first.
