#!/bin/sh

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
