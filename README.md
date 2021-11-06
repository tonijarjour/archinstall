```
# System Clock
timedatectl set-ntp true

# Partitioning 
fdisk /dev/sdb

# Formatting
mkfs.fat -F32 /dev/sdbA
mkfs.ext4 -L "Arch Linux" /dev/sdbC
mkswap /dev/sdbB

# Mounting
swapon /dev/sdbB
mount /dev/sdbC /mnt
mkdir /mnt/boot
mount /dev/sdbA /mnt/boot

# Check /etc/pacman.d/mirrorlist

# Installation
pacstrap /mnt base linux-zen linux-firmware intel-ucode opendoas

# Mount instructions
genfstab -U /mnt >> /mnt/etc/fstab

# Chroot
arch-chroot /mnt
```
