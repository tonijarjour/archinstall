USERNAME='toni'
USERSHELL='bash'
INTERFACE='eno1'

cat > /etc/security/access.conf << EOF
+:root:LOCAL
+:(wheel):LOCAL
-:ALL:ALL
EOF
cat > /etc/systemd/network/20-wired.network << EOF
[Match]
Name=$INTERFACE

[Network]
DHCP=yes
EOF
systemctl enable --now systemd-networkd.service
systemctl enable --now systemd-resolved.service
cat > /etc/pacman.d/mirrorlist << EOF
Server = https://arch.mirror.square-r00t.net/\$repo/os/\$arch
Server = https://arch.mirror.constant.com/\$repo/os/\$arch
EOF
pacman -S ntfs-3g systemd-swap opendoas
echo "permit nopass :wheel" > /etc/doas.conf
echo "swapfc_enabled=1" > /etc/systemd/swap.conf
systemctl enable --now systemd-swap
useradd -m -g wheel -s /bin/$USERSHELL $USERNAME
echo "/dev/sda1 /mnt/archive ntfs-3g uid=$USERNAME,gid=wheel,umask=0022 0 0" >> /etc/fstab
