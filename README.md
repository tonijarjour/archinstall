### How to use
1. Filesystem.
2. `bash install.sh`
3. `arch-chroot /mnt`
4. `bash finish.sh`

### Should I use these?
You will have to modify them to fit your system and preferences. 

### Why are there no comments?
Comments will break the script.

-----------------
```
# Verify EFI mode
ls /sys/firmware/efi/efivars

# System Clock
timedatectl set-ntp true

# Partition and Format
fdisk /dev/sdb

mkfs.ext4 -L "Arch Linux" /dev/sdbX
mount /dev/sdbX /mnt

mkdir /mnt/boot
mount /dev/sdbX /mnt/boot

mkswap /dev/sdbX
swapon /dev/sdbX
```
