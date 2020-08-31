#!/bin/bash

HOSTNAME='sakura'
TIMEZONE='America/New_York'
LOCALE='en_US'
CPUCODE='intel'
ESPBOOT='boot'
ROOTLABEL='Arch Linux'

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
echo "-- ALL STEPS FINISHED"
echo "-- Remember to set a PASSWORD for root"
