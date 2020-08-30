#!/bin/bash

USERNAME='toni'
HOSTNAME='sakura'
EDITOR='nvim'
TIMEZONE='America/New_York'
LOCALE='en_US'
CPUCODE='intel'
NETWORKINF='eno1'
PATHTOBOOT='boot'
ROOTLABEL='Arch Linux'
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
127.0.1.1       $HOSTNAME.localdomain $HOSTNAME
EOF
cat > /etc/pacman.d/mirrorlist << EOF
Server = https://arch.mirror.square-r00t.net/\$repo/os/\$arch
Server = https://arch.mirror.constant.com/\$repo/os/\$arch
EOF
pacman -S ntfs-3g intel-ucode man-db man-pages systemd-swap opendoas
useradd -m -g wheel -s /bin/$USERSHELL $USERNAME
echo "permit nopass :wheel" > /etc/doas.conf
cat > /etc/security/access.conf << EOF
+:root:LOCAL
+:(wheel):LOCAL
-:ALL:ALL
EOF
bootctl install
cat > /$PATHTOBOOT/loader/loader.conf << EOF
default         arch
timeout         3
editor          no
EOF
cat > /$PATHTOBOOT/loader/entries/arch.conf << EOF
title   $ROOTLABEL
linux   /vmlinuz-linux
initrd  /$CPUCODE-ucode.img
initrd  /initramfs-linux.img
options root="LABEL=$ROOTLABEL" rw
EOF
echo "/dev/sda1	/mnt/archive	ntfs-3g	uid=$USERNAME,gid=wheel,umask=0022 0 0" >> /etc/fstab
mkdir /mnt/archive
cat > /etc/systemd/network/20-wired.network << EOF
[Match]
Name=$NETWORKINF

[Network]
DHCP=yes
EOF
echo "swapfc_enabled=1" > /etc/systemd/swap.conf
systemctl enable systemd-networkd.service
systemctl enable systemd-resolved.service
systemctl enable systemd-swap
echo "-- ALL STEPS FINISHED"
echo "-- Remember to set a password for root and $USERNAME"
