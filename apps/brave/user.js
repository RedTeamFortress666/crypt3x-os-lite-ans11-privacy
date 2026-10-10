# Explicit privacy-essential package set for CRYPT3X Lite on ANS11
# These names are Debian/Ubuntu-style package names and are intended for the rootfs build system.
# Final image recipe can adapt them to the distribution backend that is chosen later.

# Core system
systemd
util-linux
sudo
bash
coreutils
grep
sed
findutils
procps
net-tools
iproute2
ca-certificates
openssl
gnupg
sqlite3
python3
python3-pip
python3-cryptography
python3-keyring

# Browser / web
brave-browser

# DNS privacy
stubby
dnscrypt-proxy
systemd-resolved
resolvconf

# VPN / firewall / proxy
wireguard-tools
wireguard-dkms
openvpn
ufw
iptables
nftables
iproute2
netfilter-persistent

# Security / key vault
cryptsetup
libfuse2
pass
pinentry-curses
libssl-dev

# Device / network tools
dhcp-client
wireless-tools
wpasupplicant
network-manager
network-manager-openvpn
network-manager-wireguard
bluetooth
bluez
bluez-tools

# F-Droid / app management
fdroidserver
android-tools-adb
android-tools-fastboot

# Portmaster / privacy monitor
iptables-persistent
ufw
nftables

# Diagnostics
htop
curl
wget
tcpdump
dnsutils

# Minimal user tools
nano
vim-tiny
htop
bash-completion
