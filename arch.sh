#!/bin/bash

echo 'Arch Install\n\n'
read -p '/ Root partition (eg. sda, sda1): ' root
read -p '[Swap] Swap partition: ' swap

efi=0
#comment the next line if bios instead of efi
read -p '/boot EFI partition: ' efi


mkfs.ext4 /dev/$root
mkswap /dev/$swap

mount /dev/$root /mnt
swapon /dev/$swap

if [ $efi -ne 0]; then
	mkfs.fat -F 32 /dev/$efi
	mount /dev/$efi /mnt/boot
fi

#downloads

pacstrap -K /mnt base linux linux-firmware vim firefox networkmanager i3 xorg ttf-dejavu ttf-3270-nerd polybar nitrogen pcmanfm alacritty rofi grub efibootmgr git network-manager-applet neofetch

genfstab -U /mnt >> /mnt/etc/fstab

arch-chroot /mnt

