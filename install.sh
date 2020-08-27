#!/bin/bash

cat > /etc/pacman.d/mirrorlist << EOF
Server = https://mirror.osbeck.com/archlinux/\$repo/os/\$arch
Server = https://iad.mirrors.misaka.one/archlinux/\$repo/os/\$arch
Server = https://arch.mirror.square-r00t.net/\$repo/os/\$arch
Server = https://plug-mirror.rcac.purdue.edu/archlinux/\$repo/os/\$arch
Server = https://mirror.sergal.org/archlinux/\$repo/os/\$arch
Server = https://mirrors.lug.mtu.edu/archlinux/\$repo/os/\$arch
Server = https://repo.ialab.dsu.edu/archlinux/\$repo/os/\$arch
Server = https://ftp.sudhip.com/archlinux/\$repo/os/\$arch
Server = https://arlm.tyzoid.com/\$repo/os/\$arch
Server = https://arch.hu.fo/archlinux/\$repo/os/\$arch
Server = https://mirrors.melbourne.co.uk/archlinux/\$repo/os/\$arch
Server = https://archmirror1.octyl.net/\$repo/os/\$arch
Server = https://mirror.wtnet.de/arch/\$repo/os/\$arch
Server = https://mirror.pkgbuild.com/\$repo/os/\$arch
Server = https://archlinux.thaller.ws/\$repo/os/\$arch
EOF

pacstrap /mnt base linux linux-firmware

genfstab -U /mnt >> /mnt/etc/fstab
