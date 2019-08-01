#!/bin/sh

ln -sf /usr/share/zoneinfo/America/New_york /etc/localtime
hwclock --systohc
echo "en_US.UTF-8 UTF-8" > /etc/locale.gen
locale-gen
echo "LANG=en_US.UTF-8" > /etc/locale.conf
echo "lunar" > /etc/hostname
echo "127.0.0.1       localhost
::1             localhost
127.0.1.1       lunar.localdomain lunar" > /etc/hosts
passwd
pacman -S base-devel zsh git intel-ucode
useradd -m -g wheel -s /bin/zsh toni
passwd toni
EDITOR=vi
visudo
echo "+:root:LOCAL
+:(wheel):LOCAL
-:ALL:ALL" > /etc/security/access.conf
bootctl --path=/boot install
echo "default         arch
timeout         3
console-mode    keep
editor          no" > /boot/loader/loader.conf
echo "title   Arch Linux
linux   /vmlinuz-linux
initrd  /intel-ucode.img
initrd  /initramfs-linux.img
options root=\"LABEL=Arch Linux\" rw" > /boot/loader/entries/arch.conf
