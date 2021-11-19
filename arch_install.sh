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

lsblk
read -p "Enter the drive (e.g. /dev/sda): " drive
cfdisk $drive
read -p "Enter the linux root partition (/dev/sda3): " partition
mkfs.ext4 $partition 

read -p "Did you also create a swap partition? [y/n]" swapanswer
if [[ $swapanswer = y ]] ; then
  echo "Enter SWAP partition: "
  read swappartition
  mkswap $swappartition
fi

read -p "Did you also create efi partition? [y/n]" efianswer
if [[ $efianswer = y ]] ; then
  echo "Enter EFI partition: "
  read efipartition
  mkfs.vfat -F 32 $efipartition
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

read -p "Do you want to automatically select the fastest mirrors? [y/n]" answer
if [[ $answer = y ]] ; then
  echo "Selecting the fastest mirrors"
  reflector --latest 20 --sort rate --save /etc/pacman.d/mirrorlist --protocol https --download-timeout 5
fi
pacstrap /mnt base base-devel linux linux-firmware

echo -e "\n### Configuring the system"
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

echo "Enter hostname: "
read hostname
echo $hostname > /etc/hostname
echo "127.0.0.1       localhost" >> /etc/hosts
echo "::1             localhost" >> /etc/hosts
echo "127.0.1.1       $hostname" >> /etc/hosts
passwd

echo -e "\n### Setting up bootloader"
pacman --noconfirm -S refind
refind-install
root_partuuid=$(lsblk -dno PARTUUID $partition)
echo "\"Boot using default options\" \"root=PARTUUID=$root_partuuid rw add_efi_memmap initrd=boot\intel-ucode.img initrd=boot\initramfs-linux.img\"" > /boot/refind_linux.conf
read -p "Did you want to create a Pacman hook for rEFInd? [y/n]" hookanswer
if [[ $hookanswer = y ]] ; then
  mkdir -p /etc/pacman.d/hooks
  touch /etc/pacman.d/hooks/refind.hook
  echo "[Trigger]" > /etc/pacman.d/hooks/refind.hook
  echo "Operation=Upgrade" >> /etc/pacman.d/hooks/refind.hook
  echo "Type=Package" >> /etc/pacman.d/hooks/refind.hook
  echo "Target=refind" >> /etc/pacman.d/hooks/refind.hook
  echo "\n[Action]" >> /etc/pacman.d/hooks/refind.hook
  echo "Description = Updating rEFInd on ESP" >> /etc/pacman.d/hooks/refind.hook
  echo "When=PostTransaction" >> /etc/pacman.d/hooks/refind.hook
  echo "Exec=/usr/bin/refind-install" >> /etc/pacman.d/hooks/refind.hook
fi

echo -e "\n### Creating user"
read -p "Enter Username: " username
useradd -mG wheel $username
passwd $username
echo "%wheel ALL=(ALL) ALL" >> /etc/sudoers


echo -e "\n### Setting up yay package manager"
pacman -S --noconfirm git
git clone https://aur.archlinux.org/yay.git
cd yay
makepkg -si

echo -e "\n### Installing packages"
pacman -S --noconfirm sed
yay -S --noconfirm sway sway-launcher-desktop waybar \
    vim emacs 
#    noto-fonts noto-fonts-emoji noto-fonts-cjk ttf-font-awesome \
#     sxiv mpv zathura zathura-pdf-mupdf ffmpeg imagemagick  \
#     fzf man-db xwallpaper python-pywal youtube-dl unclutter xclip maim \
#     zip unzip unrar p7zip xdotool papirus-icon-theme brightnessctl  \
#     dosfstools ntfs-3g git sxhkd zsh pipewire pipewire-pulse \
#     vim emacs arc-gtk-theme rsync firefox dash \
#     xcompmgr libnotify dunst slock jq \
#     dhcpcd networkmanager rsync pamixer

#systemctl enable NetworkManager.service 

echo "Pre-Installation Finish Reboot now"
ai3_path=/home/$username/arch_install3.sh
sed '1,/^###\ Part\ 3$/d' arch_install2.sh > $ai3_path
rm arch_install2.sh
chown $username:$username $ai3_path
chmod +x $ai3_path
su -c $ai3_path -s /bin/sh $username
exit 


### Part 3
printf '\033c'
#cd $HOME
#git clone --separate-git-dir=$HOME/.dotfiles https://github.com/bugswriter/dotfiles.git tmpdotfiles
#rsync --recursive --verbose --exclude '.git' tmpdotfiles/ $HOME/
#rm -r tmpdotfiles
#git clone --depth=1 https://github.com/Bugswriter/dwm.git ~/.local/src/dwm
#sudo make -C ~/.local/src/dwm install
#git clone --depth=1 https://github.com/Bugswriter/st.git ~/.local/src/st
#sudo make -C ~/.local/src/st install
#git clone --depth=1 https://github.com/Bugswriter/dmenu.git ~/.local/src/dmenu
#sudo make -C ~/.local/src/dmenu install
#git clone --depth=1 https://github.com/Bugswriter/baph.git ~/.local/src/baph
#sudo make -C ~/.local/src/baph install
#baph -inN libxft-bgra-git

#ln -s ~/.config/x11/xinitrc .xinitrc
#ln -s ~/.config/shell/profile .zprofile
#sh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)"
#mv ~/.oh-my-zsh ~/.config/zsh/oh-my-zsh
#rm ~/.zshrc ~/.zsh_history
#mkdir -p ~/dl ~/vids ~/music ~/dox ~/code ~/pix/ss
#alias dots='/usr/bin/git --git-dir=$HOME/.dotfiles/ --work-tree=$HOME'
#dots config --local status.showUntrackedFiles no
#exit
