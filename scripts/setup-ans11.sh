ODROIDGO2-UBOOT-CONFIG

setenv max_cpufreq "1200"
setenv boot_cpufreq "1100"
setenv max_ddrfreq "666"

# Privacy-first boot arguments for CRYPT3X Lite on ANS11
setenv bootargs "console=tty1 quiet loglevel=2 root=LABEL=CRYPT3X rootwait fbcon=rotate:0 fbcon=primary:0 max_cpufreq=${max_cpufreq} boot_cpufreq=${boot_cpufreq} max_ddrfreq=${max_ddrfreq} crypt3x.privacy=1 crypt3x.vault=1 crypt3x.duress=1"

load mmc 1:1 0x02000000 Image
load mmc 1:1 0x01f00000 rk3326-ans11.dtb
booti 0x02000000 - 0x01f00000
