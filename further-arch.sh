#!/bin/bash

ln -sf /usr/share/zoneinfo/Asia/Kathmandu /etc/localtime
hwclock --systohc

echo 'en_US.UTF-8 UTF-8' >> /etc/locale.gen
locale-gen
echo 'LANG=en_US.UTF-8' > /etc/locale.conf

echo 'ArchLinux' > /etc/hostname
passwd 

read -p 'Add a user. Enter username: ' name
useradd -m -G wheel,audio,video,storage,disk $name
passwd $name

cd /tmp
git clone https://github.com/dishanshakya/arch-config

mv -r /tmp/arch-config/* /home/$name/

pacman -S lxappearance papirus-icon-theme gvfs-mtp noto-fonts-emoji adobe-source-code-pro-fonts noto-fonts
sudo
echo '%wheel ALL=(ALL:ALL) ALL' >> /etc/sudoers
echo 'Install bootloader with grub-install'
