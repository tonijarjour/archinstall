#!/bin/bash

USERNAME='toni'
HOSTNAME='sakura'
TIMEZONE='America/New_York'
LOCALE='en_US'
CPUCODE='intel'
ESPBOOT='boot'
ROOTLABEL='ARCH_LINUX'
INTERFACE='eno1'

ln -sf /usr/share/zoneinfo/$TIMEZONE /etc/localtime
hwclock --systohc
echo "$LOCALE.UTF-8 UTF-8" > /etc/locale.gen
locale-gen
echo "LANG=$LOCALE.UTF-8" > /etc/locale.conf
echo "$HOSTNAME" > /etc/hostname
cat > /etc/hosts << EOF
127.0.0.1       localhost
::1             localhost
127.0.1.1       $HOSTNAME.localdomain $HOSTNAME
EOF
useradd -m -g wheel $USERNAME
echo "permit nopass :wheel" > /etc/doas.conf
echo "LABEL=ARCHIVE /mnt/archive ext4 defaults 0 2" >> /etc/fstab
cat > /etc/security/access.conf << EOF
+:root:LOCAL
+:(wheel):LOCAL
-:ALL:ALL
EOF
bootctl install
cat > /$ESPBOOT/loader/loader.conf << EOF
default         arch.conf
timeout         3
editor          no
EOF
cat > /$ESPBOOT/loader/entries/arch.conf << EOF
title   Arch Linux
linux   /vmlinuz-linux
initrd  /$CPUCODE-ucode.img
initrd  /initramfs-linux.img
options root="LABEL=$ROOTLABEL" rw
EOF
cat > /etc/systemd/network/20-wired.network << EOF
[Match]
Name=$INTERFACE

[Network]
DHCP=yes
EOF
systemctl enable systemd-networkd.service
systemctl enable systemd-resolved.service
echo "-- ALL STEPS FINISHED"
echo "-- Remember to set a PASSWORD for root and $USERNAME"
