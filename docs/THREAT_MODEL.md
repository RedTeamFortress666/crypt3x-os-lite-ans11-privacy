# Threat Model and Security Notes

## Scope

This project targets a lightweight handheld Linux OS for the ANS11 platform. The primary goals are security, privacy, and low system complexity.

## Threat model

### In-scope risks
- Passive network eavesdropping
- DNS leakage
- Unencrypted credential exposure
- Wi‑Fi association spoofing
- Local tampering with system or credentials
- Casual forensic recovery from removable storage

### Out-of-scope risks
- Simultaneous nation-state physical compromise
- Evil-maid attacks against a fully unlocked device
- Hardware-level bus extraction from a live system
- Advanced malware persistence in a fully compromised firmware chain

## Core design assumptions

1. The device is a user-owned handheld with limited physical security.
2. The user expects privacy-first networking and locked-down defaults.
3. The system should fail closed, not open.
4. Network access must require a privacy stack and a clear user consent flow.

## Security controls

- Default-deny firewall until privacy stack is active
- DNS privacy required for internet access
- VPN or proxy required to access internet outside the local trust boundary
- Keystore is PIN-bound and encrypted at rest
- Duress PIN triggers a wipe path for user data
- Ghost / lock screen protects against casual shoulder surfing

## Hardening recommendations

- Use seccomp and AppArmor where feasible.
- Remove unneeded network daemons by default.
- Keep rootfs read-only except for verified updates.
- Sign OTA updates and enforce rollback checks.
- Prefer LUKS2 or sealed key storage when hardware permits.

## Residual risk

The OS is not designed to protect against a determined attacker with direct hardware access and tooling. It is designed for practical privacy, not absolute military-grade secrecy.
