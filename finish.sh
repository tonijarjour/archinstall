#!/bin/sh

USERNAME='toni'
HOSTNAME='sakura'
TIMEZONE='America/New_York'
LOCALE='en_US'
IPADDRESS='127.0.1.1'


ln -sf /usr/share/zoneinfo/$TIMEZONE /etc/localtime
hwclock --systohc
echo "$LOCALE.UTF-8 UTF-8" > /etc/locale.gen
locale-gen
echo "LANG=$LOCALE.UTF-8" > /etc/locale.conf
echo "$HOSTNAME" > /etc/hostname
echo "127.0.0.1       localhost
::1             localhost
$IPADDRESS       $HOSTNAME.localdomain $HOSTNAME" > /etc/hosts
echo "Enter a password for root"
passwd
pacman -S base-devel zsh git intel-ucode ntfs-3g nvidia
useradd -m -g wheel -s /bin/zsh $USERNAME
echo "Enter a password for $USERNAME"
passwd $USERNAME
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
echo "/dev/sda1	/mnt/archive	ntfs-3g	uid=$USERNAME,gid=wheel,umask=0022 0 0" >> /etc/fstab
mkdir /mnt/archive
systemctl enable dhcpcd@eno1.service
