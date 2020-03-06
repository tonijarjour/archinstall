### How to use
1. Filesystem.
2. `sh install.sh`
3. `arch-chroot /mnt`
4. `sh finish.sh`

### Should I use these?
You will have to modify them to fit your system and preferences. 

### Why are there no comments?
Comments will break the script.

-----------------
# Network interface
ip link
systemctl enable dhcpcd@NETWORKINF.service

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

# Mirror list
cat > /etc/pacman.d/mirrorlist << EOF
Server = https://arch.mirror.constant.com/\$repo/os/\$arch
Server = http://mirror.stephen304.com/archlinux/\$repo/os/\$arch
Server = http://arch.mirror.constant.com/\$repo/os/\$arch
Server = http://arch.mirror.square-r00t.net/\$repo/os/\$arch
Server = http://mirror.wdc1.us.leaseweb.net/archlinux/\$repo/os/\$arch
Server = http://ftp.osuosl.org/pub/archlinux/\$repo/os/\$arch
Server = http://mirrors.advancedhosters.com/archlinux/\$repo/os/\$arch
EOF

# Install
pacstrap /mnt base linux linux-firmware dhcpcd neovim

# Fstab (startup mount instructions)
genfstab -U /mnt >> /mnt/etc/fstab

# Change root into system
arch-chroot /mnt

# Timezone
TIMEZONE='America/New_York'
ln -sf /usr/share/zoneinfo/$TIMEZONE /etc/localtime
hwclock --systohc

# Locale
LOCALE='en_US'
echo "$LOCALE.UTF-8 UTF-8" > /etc/locale.gen
locale-gen
echo "LANG=$LOCALE.UTF-8" > /etc/locale.conf

# Host name
HOSTNAME='sakura'
echo "$HOSTNAME" > /etc/hostname
IPADDRESS='127.0.1.1'
cat > /etc/hosts << EOF
127.0.0.1       localhost
::1             localhost
$IPADDRESS       $HOSTNAME.localdomain $HOSTNAME
EOF

# Root Password
passwd

# Important installs
pacman -S git ntfs-3g intel-ucode nvidia

# Add user
USERNAME='toni'
USERSHELL='bash'
useradd -m -g wheel -s /bin/$USERSHELL $USERNAME
passwd $USERNAME

# Sudo
EDITOR=nvim visudo

# PAM
cat > /etc/security/access.conf << EOF
+:root:LOCAL
+:(wheel):LOCAL
-:ALL:ALL
EOF

# Boot loader
PATHTOBOOT='boot'
bootctl --path=/$PATHTOBOOT install
cat > /$PATHTOBOOT/loader/loader.conf << EOF
default         arch
timeout         3
console-mode    keep
editor          no
EOF
CPUCODE='intel-ucode'
ROOTLABEL='Arch Linux'
cat > /$PATHTOBOOT/loader/entries/arch.conf << EOF
title   Arch Linux
linux   /vmlinuz-linux
initrd  /$CPUCODE.img
initrd  /initramfs-linux.img
options root="LABEL=$ROOTLABEL" rw
EOF

# Archive
echo "/dev/sda1	/mnt/archive	ntfs-3g	uid=$USERNAME,gid=wheel,umask=0022 0 0" >> /etc/fstab
mkdir /mnt/archive

# Internet
systemctl enable dhcpcd@$NETWORKINF.service
