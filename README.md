```
# System Clock
timedatectl set-ntp true

# Partitioning 
fdisk /dev/sdb

# Formatting
mkfs.fat -F32 /dev/sdbA
mkfs.ext4 -L "Arch Linux" /dev/sdbB

# Mounting
mount /dev/sdbX /mnt
mkdir /mnt/boot
mount /dev/sdbX /mnt/boot

# Installation
bash install.sh
arch-chroot /mnt
bash finish.sh
```
