#!/bin/sh

# Easy
USERNAME='toni'
HOSTNAME='sakura'

# Change to nano if you're a noob.
EDITOR='vi'

# If you don't know what to put here, I'm sorry.
TIMEZONE='America/New_York'
LOCALE='en_US'
CPUCODE='intel-ucode'
GPUDRIVER='nvidia'
NETWORKINF='eno1'
PATHTOBOOT='boot'
ROOTLABEL='Arch Linux'

# Do NOT change unless you have a static IP Address.
IPADDRESS='127.0.1.1'

# Uncomment if you want zsh and change USERSHELL to zsh.
GETZSHELL='zsh'
USERSHELL='zsh'

# Uncomment if you want these.
GETGIT='git'
GETDEVEL='base-devel'
GETNTFS='ntfs-3g'

cat > /etc/pacman.d/mirrorlist << EOF
Server = https://arch.mirror.constant.com/\$repo/os/\$arch
Server = http://mirror.stephen304.com/archlinux/\$repo/os/\$arch
Server = http://arch.mirror.constant.com/\$repo/os/\$arch
Server = http://arch.mirror.square-r00t.net/\$repo/os/\$arch
Server = http://mirror.wdc1.us.leaseweb.net/archlinux/\$repo/os/\$arch
Server = http://ftp.osuosl.org/pub/archlinux/\$repo/os/\$arch
Server = http://mirrors.advancedhosters.com/archlinux/\$repo/os/\$arch
Server = http://archlinux.olanfa.rocks/\$repo/os/\$arch
EOF

pacstrap /mnt base

genfstab -U /mnt >> /mnt/etc/fstab

echo "ln -sf /usr/share/zoneinfo/$TIMEZONE /etc/localtime
hwclock --systohc
echo \"$LOCALE.UTF-8 UTF-8\" > /etc/locale.gen
locale-gen
echo \"LANG=$LOCALE.UTF-8\" > /etc/locale.conf
echo \"$HOSTNAME\" > /etc/hostname
cat > /etc/hosts << EOF
127.0.0.1       localhost
::1             localhost
$IPADDRESS       $HOSTNAME.localdomain $HOSTNAME
EOF
echo \"-- Enter a password for root\"
passwd
pacman -S $GETDEVEL $GETZSHELL $GETGIT $GETNTFS $CPUCODE $GPUDRIVER
useradd -m -g wheel -s /bin/$USERSHELL $USERNAME
echo \"-- Enter a password for $USERNAME\"
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
options root=\"LABEL=$ROOTLABEL\" rw
EOF
echo \"/dev/sda1	/mnt/archive	ntfs-3g	uid=$USERNAME,gid=wheel,umask=0022 0 0\" >> /etc/fstab
mkdir /mnt/archive
systemctl enable dhcpcd@$NETWORKINF.service" | arch-chroot /mnt
