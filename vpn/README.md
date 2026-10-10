# Keystore

This store is a firmware stub for CRYPT3X Lite. It stores a tiny encrypted JSON blob keyed to a PIN, using a PBKDF2-derived key and XOR stream encryption. It is a secure prototype for the build system and is designed for extension to a stronger hardware-backed storage implementation later.

## Usage
```bash
./keystore/vaultctl.sh init mypin
./keystore/vaultctl.sh set mypin gmail user@example.com
./keystore/vaultctl.sh get mypin gmail
./keystore/vaultctl.sh lock
```

## Storage path
`/var/lib/crypt3x/keystore.json`
