#!/bin/bash
#
# Arch Linux installation
#
# Bootable USB:
# - [Download](https://archlinux.org/download/) ISO and GPG files
# - Verify the ISO file: `$ pacman-key -v archlinux-<version>-x86_64.iso.sig`
# - Create a bootable USB with: `# dd if=archlinux*.iso of=/dev/sdX && sync`



### Part 1
# From live environment: 
# - ensure network interface is enabled using `ip link`
# - Connect to wifi via: `# iwctl station wlan0 connect WIFI-NETWORK`
# - Downlaod: `# curl -OsL https://git.io/louise-arch-install)`
# - Check, then run: `# bash louise-arch-install`

printf '\033c'
echo "Welcome to Arch Linux Installation"

loadkeys us
timedatectl set-ntp true

echo -e "\n### Checking UEFI boot mode"
if [ ! -f /sys/firmware/efi/fw_platform_size ]; then
    echo >&2 "You must boot in UEFI mode to continue"
    exit 2
fi

echo -en "\nFormat disks? [y/n] "
read formatanswer
if [[ $formatanswer = y ]] ; then
    lsblk
    read -p "Enter the drive (e.g. /dev/sda): " drive
    cfdisk $drive
    read -p "Enter the linux root partition (/dev/sda3): " partition
    mkfs.ext4 $partition 

    fdisk -l $drive
    echo -en "\nDid you also create efi partition? [y/n] "
    read efianswer
    if [[ $efianswer = y ]] ; then
      read -p "Enter EFI partition (e.g. /dev/sda1): " efipartition
      mkfs.vfat -F 32 $efipartition
    fi

    read -p "Did you also create a swap partition? [y/n] " swapanswer
    if [[ $swapanswer = y ]] ; then
      read -p "Enter SWAP partition (e.g. /dev/sda2): " swappartition
      mkswap $swappartition
    fi

    echo -e "\n### Mounting file system"
    mount $partition /mnt 
    if [[ $efianswer = y ]] ; then
      mkdir -p /mnt/boot/efi
      mount $efipartition /mnt/boot/efi
    fi
    if [[ $swapanswer = y ]] ; then
      swapon $swappartition
    fi
else
    lsblk
    read -p "Enter the linux root partition (/dev/sda3): " partition
fi

echo -en "\nDo you want to automatically select the fastest mirrors? [y/n] "
read answer
if [[ $answer = y ]] ; then
  echo "Selecting the fastest mirrors"
  reflector --latest 20 --sort rate --save /etc/pacman.d/mirrorlist --protocol https --download-timeout 5
fi
pacstrap /mnt base base-devel linux linux-firmware linux-headers intel-ucode

echo -e "\n### Generating fstab"
genfstab -U /mnt >> /mnt/etc/fstab
sed '1,/^###\ Part\ 2$/d' louise-arch-install > /mnt/arch_install2.sh
chmod +x /mnt/arch_install2.sh
arch-chroot /mnt ./arch_install2.sh
exit 


### Part 2
printf '\033c'
echo -e "\n### Setting up clock"
ln -sf /usr/share/zoneinfo/America/Los_Angeles /etc/localtime
hwclock --systohc

echo -e "\n### Setting up Localization"
echo "en_US.UTF-8 UTF-8" >> /etc/locale.gen
locale-gen
echo "LANG=en_US.UTF-8" > /etc/locale.conf
echo "KEYMAP=us" > /etc/vconsole.conf

echo -e "\n### Setting computer hostname"
read -p "Enter hostname: " hostname
echo $hostname > /etc/hostname
echo "127.0.0.1       localhost" >> /etc/hosts
echo "::1             localhost" >> /etc/hosts
echo "127.0.1.1       $hostname" >> /etc/hosts
echo -e "\n### Creating root password"
passwd

pacman --noconfirm -S archlinux-keyring 
echo -e "\n### Installing packages"
pacman --noconfirm -S vim emacs git refind \
    sway swayidle swaylock waybar wl-clipboard mako \
    xf86-video-nouveau qt5-wayland \
    noto-fonts noto-fonts-emoji noto-fonts-cjk ttf-font-awesome papirus-icon-theme \
    fcitx5 fcitx5-chinese-addons \
    imv mpv zathura zathura-pdf-mupdf ffmpeg imagemagick  \
    man-db man-pages iwd \
    fzf fd rsync youtube-dl unclutter htop openssh usbutils \
    zip unzip unrar p7zip \
    python-pyserial arduino-cli \
    cups cups-pdf swappy \
    bluez bluez-utils brightnessctl \
    pulseaudio pulseaudio-alsa pavucontrol pulsemixer \
    alacritty fish zoxide 

echo -e "\n### Setting up bootloader"
refind-install
echo "$partition"
echo "\"Boot using default options\" \"root=PARTUUID=$(lsblk -dno PARTUUID $partition) rw add_efi_memmap initrd=boot\intel-ucode.img initrd=boot\initramfs-linux.img\"" > /boot/refind_linux.conf

echo -e "\n### Creating user"
read -p "Enter Username: " username
useradd -mG wheel $username
passwd $username
echo "%wheel ALL=(ALL) ALL" >> /etc/sudoers

echo -e "\n### Starting services"
read -p "Did you want to create a Pacman hook for rEFInd? [y/n] " hookanswer
if [[ $hookanswer = y ]] ; then
  mkdir -p /etc/pacman.d/hooks
  touch /etc/pacman.d/hooks/refind.hook
  echo "[Trigger]" > /etc/pacman.d/hooks/refind.hook
  echo "Operation=Upgrade" >> /etc/pacman.d/hooks/refind.hook
  echo "Type=Package" >> /etc/pacman.d/hooks/refind.hook
  echo "Target=refind" >> /etc/pacman.d/hooks/refind.hook
  echo -e "\n[Action]" >> /etc/pacman.d/hooks/refind.hook
  echo "Description = Updating rEFInd on ESP" >> /etc/pacman.d/hooks/refind.hook
  echo "When=PostTransaction" >> /etc/pacman.d/hooks/refind.hook
  echo "Exec=/usr/bin/refind-install" >> /etc/pacman.d/hooks/refind.hook
fi

read -p "Set up reflector service to update mirrorlist? [y/n] " reflectoranswer
if [[ $reflectoranswer = y ]] ; then
  pacman -S --noconfirm reflector 
  echo "--country United States" >> /etc/xdg/reflector/reflector.conf
  echo "--download-timeout 5" >> /etc/xdg/reflector/reflector.conf
  systemctl enable --now reflector.service
fi

echo -e "\n### Setting up networking"
read -p "Set up networking with iwd? [y/n] " iwdanswer
if [[ $iwdanswer = y ]] ; then
    systemctl enable --now systemd-resolved.service systemd-networkd.service iwd.service
fi

echo -e "\n### Pre-Installation Finished"
ai3_path=/home/$username/arch_install3.sh
sed '1,/^###\ Part\ 3$/d' arch_install2.sh > $ai3_path
rm arch_install2.sh
chown $username:$username $ai3_path
chmod +x $ai3_path
su -c $ai3_path -s /bin/sh $username
exit 


### Part 3
printf '\033c'
echo -e "\n### Configuring user environment"
cd $HOME
echo -e "\n### Setting up yay package manager"
git clone https://aur.archlinux.org/yay.git
cd yay
makepkg -si
cd $HOME

echo -e "\n### Installing AUR packages"
yay --noconfirm -S greetd greetd-gtkgreet \
    sway-launcher-desktop wev xorg-xwayland \
    wget2 ch34x-dkms-git grimshot \
    pulseaudio-modules-bt \
    spotify ferdi-bin google-chrome anki


echo -e "\n### Setting up dotfiles"
git clone --separate-git-dir=$HOME/.dotfiles https://github.com/louisethomas/dotfiles.git tmpdotfiles
rsync --recursive --verbose --exclude '.git' tmpdotfiles/ $HOME/
rm -r tmpdotfiles
git --git-dir=$HOME/.dotfiles/ --work-tree=$HOME config --local status.showUntrackedFiles no

#mkdir -p ~/dl ~/vids ~/music ~/dox ~/code ~/pix/ss


echo -e "\n### Installation finished"
exit
