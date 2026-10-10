#!/usr/bin/env python3
# SPDX-License-Identifier: MIT
# Minimal four-app launcher for CRYPT3X Lite.
# A lightweight desktop shell designed for the ANS11 handheld.

import json
import os
import subprocess
import sys
from pathlib import Path

APP_CONFIG = {
    "Mail": {"command": "mail-client", "icon": "mail"},
    "Brave": {"command": "brave-browser", "icon": "browser"},
    "F-Droid": {"command": "fdroid", "icon": "package"},
    "Portmaster": {"command": "portmaster", "icon": "shield"},
}


def launch(cmd: str):
    try:
        subprocess.Popen(cmd, shell=True)
    except Exception as exc:
        print(f"Launch failed: {exc}")


def check_privacy_stack() -> bool:
    checks = [
        ["systemctl", "is-active", "--quiet", "dnscrypt-proxy2"],
        ["systemctl", "is-active", "--quiet", "stubby"],
        ["systemctl", "is-active", "--quiet", "wg-quick@crypt3x"],
        ["systemctl", "is-active", "--quiet", "openvpn@crypt3x"],
        ["systemctl", "is-active", "--quiet", "portmaster"],
    ]
    return any(subprocess.run(c, stdout=subprocess.DEVNULL, stderr=subprocess.DEVNULL).returncode == 0 for c in checks)


def render_ui():
    print("\n" + "=" * 64)
    print("CRYPT3X OS Lite — ANS11 DESK")
    print("=" * 64)
    print("[ Privacy status: ENABLED ]" if check_privacy_stack() else "[ Privacy status: BLOCKED ]")
    print()
    for idx, name in enumerate(APP_CONFIG, 1):
        print(f"  [{idx}] {name:12s}  {APP_CONFIG[name]['icon']}")
    print()
    print("  [0] Lock device")
    print("  [9] Reboot")
    print("  [q] Quit")
    print("=" * 64)


def choose():
    render_ui()
    choice = input("Select app: ").strip().lower()
    if choice in {"q", "quit"}:
        return False
    if choice == "0":
        print("Locking device...")
        subprocess.run(["loginctl", "lock-sessions"], check=False)
        return True
    if choice == "9":
        print("Rebooting device...")
        subprocess.run(["systemctl", "reboot"], check=False)
        return True
    try:
        idx = int(choice) - 1
        names = list(APP_CONFIG.keys())
        if 0 <= idx < len(names):
            name = names[idx]
            cmd = APP_CONFIG[name]["command"]
            print(f"Launching {name}...")
            launch(cmd)
    except ValueError:
        pass
    return True


if __name__ == "__main__":
    while True:
        try:
            if not choose():
                break
        except KeyboardInterrupt:
            break
        print()
