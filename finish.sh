#!/bin/bash

USERNAME='toni'
HOSTNAME='sakura'
EDITOR='nvim'
TIMEZONE='America/New_York'
LOCALE='en_US'
CPUCODE='intel-ucode'
NETWORKINF='eno1'
PATHTOBOOT='boot'
ROOTLABEL='Arch Linux'
IPADDRESS='127.0.1.1'
USERSHELL='bash'

ln -sf /usr/share/zoneinfo/$TIMEZONE /etc/localtime
hwclock --systohc
echo "$LOCALE.UTF-8 UTF-8" > /etc/locale.gen
locale-gen
echo "LANG=$LOCALE.UTF-8" > /etc/locale.conf
echo "$HOSTNAME" > /etc/hostname
cat > /etc/hosts << EOF
127.0.0.1       localhost
::1             localhost
$IPADDRESS       $HOSTNAME.localdomain $HOSTNAME
EOF
pacman -S base-devel git ntfs-3g nvidia intel-ucode man-db man-pages neovim
useradd -m -g wheel -s /bin/$USERSHELL $USERNAME
visudo
cat > /etc/security/access.conf << EOF
+:root:LOCAL
+:(wheel):LOCAL
-:ALL:ALL
EOF
bootctl --path=/$PATHTOBOOT install
cat > /$PATHTOBOOT/loader/loader.conf << EOF
default         arch
timeout         3
console-mode    keep
editor          no
EOF
cat > /$PATHTOBOOT/loader/entries/arch.conf << EOF
title   Arch Linux
linux   /vmlinuz-linux
initrd  /$CPUCODE.img
initrd  /initramfs-linux.img
options root="LABEL=$ROOTLABEL" rw
EOF
echo "/dev/sda1	/mnt/archive	ntfs-3g	uid=$USERNAME,gid=wheel,umask=0022 0 0" >> /etc/fstab
mkdir /mnt/archive
cat > /etc/systemd/network/20-wired.network << EOF
[Match]
Name=$NETWORKINF

[Network]
DHCP=ipv4
EOF
systemctl enable systemd-networkd.service
systemctl enable systemd-resolved.service
echo "-- ALL STEPS FINISHED"
echo "-- Remember to set a password for root and $USERNAME"
