# CRYPT3X OS Lite — Development Blueprint

This builds the next layer of the ANS11 privacy-lite OS beyond the bootstrap scaffold.

## Strategic direction

1. Boot identity
   - Mechanical rotor splash with emerald glow
   - CRYPT3X phrase and machine tagline
   - Plymouth theme and boot animation package

2. System hardening
   - Firewall default deny until privacy stack is operational
   - DNS privacy required before internet access is allowed
   - VPN/proxy enforcement and validation checks

3. User interface
   - Wi-Fi UI for everyday connection without CLI
   - Minimal 4-app launcher for Mail, Brave, F-Droid, Portmaster
   - Simple, black-and-emerald desktop shell

4. Security and trust
   - Vault PIN lock and duress handling
   - Encrypted keystore with PIN-sealed storage
   - Threat model documentation and audit checklist

5. Firmware readiness
   - ANS11 compatibility profile based on ROCKNIX + ArkOS4Clone
   - OTA-safe image and rollback plan
   - Hardware quirk detection and low-level tuning

## Development order

### Milestone 1 — Boot and brand identity
- Rendered boot animation with rotor spell-out
- Plymouth theme + boot splash fallback
- Boot logo and splash metadata

### Milestone 2 — Network and privacy enforcement
- Wi-Fi manager UI
- DNS/VPN/Proxy gating rules
- Firewall defaults and connectivity checks

### Milestone 3 — Desktop shell
- Minimal launcher and app grid
- Settings pane for Wi-Fi, VPN, and privacy mode
- Accessibility and menu flow

### Milestone 4 — Security hardening
- Encrypted vault, duress flows, data wipe triggers
- Hardened systemd services
- Network audit and logging under privacy mode

### Milestone 5 — Productionization
- OTA and image signing
- Hardware detection and quirk registry
- Release automation and documentation

## Non-negotiables

- No internet without privacy stack enabled
- No analytics or telemetry by default
- No cloud sync without explicit opt-in
- No default Google/commercial services
- Minimal attack surface for the handheld form factor

## Current status

Boot splash identity and privacy enforcement scaffolding are in place. The next pass is focused on usability and production readiness.
