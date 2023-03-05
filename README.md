```
# Format root partition
mkfs.ext4 -L "ARCH_LINUX" /dev/sdbC

# Mount root and boot partitions
mount /dev/sdbC /mnt
mkdir /mnt/boot
mount /dev/sdbA /mnt/boot

# Clean up boot partition
cp -r /mnt/boot/EFI/Microsoft .
rm -rf /mnt/boot/*
mkdir /mnt/boot/EFI
cp -r Microsoft /mnt/boot/EFI

# Reflector
reflector --latest 10 --sort rate --country "United States" --save /etc/pacman.d/mirrorlist

# Installation
pacstrap /mnt base linux-zen linux-firmware amd-ucode

# Mount instructions
genfstab -U /mnt >> /mnt/etc/fstab

# Edit mkinitcpio config and remove the fallback file
vim /mnt/etc/mkinitcpio.d/linux-zen.preset
rm /mnt/boot/initramfs-linux-zen-fallback.img

# Chroot
arch-chroot /mnt

# mkinitcpio
mkinitcpio -P

# Run the script
bash install.sh
```
