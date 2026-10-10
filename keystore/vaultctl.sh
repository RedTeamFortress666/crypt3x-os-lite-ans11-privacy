#!/usr/bin/env python3
# SPDX-License-Identifier: MIT
# Encrypted keystore for CRYPT3X Lite.
# This is a minimal, dependency-light implementation using Python's hashlib + HMAC + XOR stream.
# It is designed as a firmware stub and should be replaced with stronger hardware-backed storage
# in a production build.

import base64
import hashlib
import json
import os
import sys
from pathlib import Path

STORE_PATH = Path(os.environ.get("CRYPT3X_KEYSTORE_PATH", "/var/lib/crypt3x/keystore.json"))


def _derive_key(pin: str, salt: bytes) -> bytes:
    return hashlib.pbkdf2_hmac("sha256", pin.encode("utf-8"), salt, 200000, dklen=32)


def _xor(data: bytes, key: bytes) -> bytes:
    out = bytearray()
    for i, b in enumerate(data):
        out.append(b ^ key[i % len(key)])
    return bytes(out)


def init_store(pin: str):
    if not STORE_PATH.parent.exists():
        STORE_PATH.parent.mkdir(parents=True, exist_ok=True)
    salt = os.urandom(16)
    key = _derive_key(pin, salt)
    ciphertext = _xor(b"{}", key)
    payload = {"salt": base64.b64encode(salt).decode(), "data": base64.b64encode(ciphertext).decode()}
    STORE_PATH.write_text(json.dumps(payload), encoding="utf-8")
    return payload


def _read_store(pin: str):
    if not STORE_PATH.exists():
        raise FileNotFoundError(f"Keystore not initialized: {STORE_PATH}")
    payload = json.loads(STORE_PATH.read_text(encoding="utf-8"))
    salt = base64.b64decode(payload["salt"])
    key = _derive_key(pin, salt)
    data = base64.b64decode(payload["data"])
    plain = _xor(data, key)
    return json.loads(plain.decode("utf-8"))


def set_secret(pin: str, label: str, value: str):
    store = _read_store(pin)
    store[label] = value
    salt = base64.b64decode(json.loads(STORE_PATH.read_text(encoding="utf-8"))["salt"])
    key = _derive_key(pin, salt)
    out = _xor(json.dumps(store, separators=(",", ":")).encode("utf-8"), key)
    payload = {"salt": base64.b64encode(salt).decode(), "data": base64.b64encode(out).decode()}
    STORE_PATH.write_text(json.dumps(payload), encoding="utf-8")
    return store


def get_secret(pin: str, label: str):
    store = _read_store(pin)
    return store.get(label)


def lock_store():
    if STORE_PATH.exists():
        STORE_PATH.write_text("{}", encoding="utf-8")
    return True


if __name__ == "__main__":
    if len(sys.argv) < 2:
        print("Usage: vault.py [init|set|get|lock] [pin] [label] [value]")
        sys.exit(1)

    cmd = sys.argv[1]
    if cmd == "init":
        pin = sys.argv[2] if len(sys.argv) > 2 else "default-pin"
        print(init_store(pin))
    elif cmd == "set":
        if len(sys.argv) != 5:
            print("Usage: vault.py set <pin> <label> <value>")
            sys.exit(2)
        print(set_secret(sys.argv[2], sys.argv[3], sys.argv[4]))
    elif cmd == "get":
        if len(sys.argv) != 4:
            print("Usage: vault.py get <pin> <label>")
            sys.exit(2)
        label = sys.argv[3]
        print(get_secret(sys.argv[2], label))
    elif cmd == "lock":
        print(lock_store())
    else:
        print(f"Unknown command: {cmd}")
        sys.exit(3)
