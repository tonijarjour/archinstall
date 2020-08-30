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

# Installation
pacstrap /mnt base linux linux-firmware
genfstab -U /mnt >> /mnt/etc/fstab
arch-chroot /mnt
bash install.sh
```
