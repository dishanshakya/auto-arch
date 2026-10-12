#!/bin/bash
set -e

###############################
# STAGE 2: runs inside chroot #
###############################
if [ "$1" = "chroot" ]; then
    root=$2
    efi=$3
    CONF=/arch-config/configuration

    ln -sf /usr/share/zoneinfo/Asia/Kathmandu /etc/localtime
    hwclock --systohc

    echo 'en_US.UTF-8 UTF-8' >> /etc/locale.gen
    locale-gen
    echo 'LANG=en_US.UTF-8' > /etc/locale.conf
    echo 'ArchLinux' > /etc/hostname

    echo 'Set root password'
    passwd

    read -p 'Add a user. Enter username: ' name
    useradd -m -G wheel,audio,video,storage,disk "$name"
    passwd "$name"

    pacman -S --noconfirm lxappearance papirus-icon-theme gvfs-mtp \
        noto-fonts-emoji adobe-source-code-pro-fonts noto-fonts

    echo '%wheel ALL=(ALL:ALL) ALL' >> /etc/sudoers

    # home dotfiles (trailing /. includes hidden files)
    cp -r "$CONF"/. /home/$name/

    # system-level Xorg configs don't belong in ~
    mkdir -p /etc/X11/xorg.conf.d
    for f in 70-synaptics.conf 00-keyboard.conf; do
        [ -f /home/$name/$f ] && mv /home/$name/$f /etc/X11/xorg.conf.d/
    done

    # archman helper on PATH
    if [ -f /home/$name/archman ]; then
        install -m 755 /home/$name/archman /usr/local/bin/archman
        rm /home/$name/archman
    fi

    # if picom/ ended up at the top level, move it to ~/.config
    if [ -d /home/$name/picom ]; then
        mkdir -p /home/$name/.config
        mv /home/$name/picom /home/$name/.config/picom
    fi

    chown -R $name:$name /home/$name

    systemctl enable NetworkManager

    if [ "$efi" != 0 ]; then
        grub-install --target=x86_64-efi --efi-directory=/boot --bootloader-id=GRUB
    else
        grub-install --target=i386-pc /dev/${root%%[0-9]*}
    fi
    grub-mkconfig -o /boot/grub/grub.cfg

    exit 0
fi

#############################
# STAGE 1: runs on live ISO #
#############################
REPO="$(dirname "$(realpath "$0")")"

echo -e 'Arch Install\n'
read -p '/ Root partition (eg. sda1): ' root
read -p '[Swap] Swap partition: ' swap

efi=0
# comment the next line if bios instead of efi
read -p '/boot EFI partition: ' efi

mkfs.ext4 /dev/$root
mkswap /dev/$swap

mount /dev/$root /mnt
swapon /dev/$swap

if [ "$efi" != 0 ]; then
    mkfs.fat -F 32 /dev/$efi
    mount --mkdir /dev/$efi /mnt/boot
fi

pacstrap -K /mnt base linux linux-firmware vim firefox networkmanager i3 xorg \
    ttf-dejavu ttf-3270-nerd polybar nitrogen pcmanfm alacritty rofi grub \
    efibootmgr git network-manager-applet neofetch xorg-xinit xcompmgr sudo \
    picom xf86-input-synaptics

genfstab -U /mnt >> /mnt/etc/fstab

# copy the repo into the new system, run stage 2 there, then clean up
mkdir -p /mnt/arch-config
cp -r "$REPO"/. /mnt/arch-config/
arch-chroot /mnt bash /arch-config/arch.sh chroot "$root" "$efi"
rm -rf /mnt/arch-config

echo 'Done. Run: umount -R /mnt && reboot'
