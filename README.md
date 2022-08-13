```
# System Clock
timedatectl set-ntp true

# Partitioning 
fdisk /dev/sdb

# Formatting
mkfs.fat -F32 /dev/sdbA
mkfs.ext4 -L "ARCH_LINUX" /dev/sdbC

# Mounting
mount /dev/sdbC /mnt
mkdir /mnt/boot
mount /dev/sdbA /mnt/boot

# Installation
pacstrap /mnt base linux-zen linux-firmware amd-ucode opendoas

# Mount instructions
genfstab -U /mnt >> /mnt/etc/fstab

# Chroot
arch-chroot /mnt
```
