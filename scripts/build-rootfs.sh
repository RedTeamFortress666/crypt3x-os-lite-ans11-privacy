BOARD=ANS11
SOC=RK3326
BOOTLOADER=uboot
KERNEL=linux-4.4.y
BOOTARGS="console=tty1 quiet loglevel=2 root=LABEL=CRYPT3X rootwait crypt3x.privacy=1 crypt3x.vault=1 crypt3x.duress=1"
PRIVACY_MODE=strict
DNS_UPSTREAM=1.1.1.1,1.0.0.1
VPN_PROVIDER=wireguard
