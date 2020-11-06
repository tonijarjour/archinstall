#!/bin/bash

USERNAME='toni'
HOSTNAME='sakura'
USERSHELL='bash'
TIMEZONE='America/New_York'
LOCALE='en_US'
CPUCODE='intel'
ESPBOOT='boot'
ROOTLABEL='Arch Linux'
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
useradd -m -g wheel -s /bin/$USERSHELL $USERNAME
echo "permit nopass :wheel" > /etc/doas.conf
echo "/dev/sda1 /mnt/archive ntfs-3g uid=$USERNAME,gid=wheel,umask=0022 0 0" >> /etc/fstab
cat > /etc/security/access.conf << EOF
+:root:LOCAL
+:(wheel):LOCAL
-:ALL:ALL
EOF
bootctl install
cat > /$ESPBOOT/loader/loader.conf << EOF
default         arch
timeout         3
editor          no
EOF
cat > /$ESPBOOT/loader/entries/arch.conf << EOF
title   $ROOTLABEL
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
ln -sf /run/systemd/resolve/stub-resolv.conf /etc/resolv.conf
echo "-- ALL STEPS FINISHED"
echo "-- Remember to set a PASSWORD for root and $USERNAME"
