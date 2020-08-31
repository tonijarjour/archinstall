```
# System Clock
timedatectl set-ntp true

# Partitioning 
fdisk /dev/sdb

# Formatting
mkfs.fat -F32 /dev/sdbA
mkfs.ext4 -L "Arch Linux" /dev/sdbB

# Mounting
mount /dev/sdbB /mnt
mkdir /mnt/boot
mount /dev/sdbA /mnt/boot

# Check /etc/pacman.d/mirrorlist

# Installation
pacstrap /mnt base linux linux-firmware

# Mount instructions
genfstab -U /mnt >> /mnt/etc/fstab

# Chroot
arch-chroot /mnt
```
