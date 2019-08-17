#!/bin/sh

USERNAME='toni'
HOSTNAME='sakura'
EDITOR='vi'
TIMEZONE='America/New_York'
LOCALE='en_US'
CPUCODE='intel-ucode'
GPUDRIVER='nvidia'
NETWORKINF='eno1'
PATHTOBOOT='boot'
ROOTLABEL='Arch Linux'
IPADDRESS='127.0.1.1'
USERSHELL='zsh'
GETZSHELL='zsh'
GETGIT='git'
GETDEVEL='base-devel'
GETNTFS='ntfs-3g'

ln -sf /usr/share/zoneinfo/$TIMEZONE /etc/localtime
hwclock --systohc
echo "$LOCALE.UTF-8 UTF-8" > /etc/locale.gen
locale-gen
echo "LANG=$LOCALE.UTF-8" > /etc/locale.conf
echo "$HOSTNAME" > /etc/hostname
cat > /etc/hosts << EOF
127.0.0.1       localhost
::1             localhost
$IPADDRESS       $HOSTNAME.localdomain $SHHOSTNAME
EOF
echo "-- Enter a password for root"
passwd
pacman -S $GETDEVEL $GETZSHELL $GETGIT $GETNTFS $CPUCODE $GPUDRIVER
useradd -m -g wheel -s /bin/$USERSHELL $USERNAME
echo "-- Enter a password for $USERNAME"
passwd $USERNAME
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
systemctl enable dhcpcd@$NETWORKINF.service