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
# - partition disks as required
# - ensure network interface is enabled using `ip link`
# - Connect to wifi via: `# iwctl station wlan0 connect WIFI-NETWORK`
# - Run: `# bash <(curl -sL https://git.io/maximbaz-install)`

printf '\033c'
echo "Welcome to Arch Linux Installation"

pacman --noconfirm -Sy archlinux-keyring
loadkeys us
timedatectl set-ntp true

echo -e "\n### Checking UEFI boot mode"
if [ ! -f /sys/firmware/efi/fw_platform_size ]; then
    echo >&2 "You must boot in UEFI mode to continue"
    exit 2
fi

echo -e "\n### Formatting drives"
lsblk
echo "Enter the drive: "
read drive
cfdisk $drive 
echo "Enter the linux partition: "
read partition
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
sed '1,/^###\ Part\ 2$/d' arch_install.sh > /mnt/arch_install2.sh
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

echo "Hostname: "
read hostname
echo $hostname > /etc/hostname
echo "127.0.0.1       localhost" >> /etc/hosts
echo "::1             localhost" >> /etc/hosts
echo "127.0.1.1       $hostname" >> /etc/hosts
passwd

echo -e "\n### Setting up bootloader"
pacman --noconfirm -S refind
refind-install

read -p "Did you want to create a Pacman hook for rEFInd? [y/n]" hookanswer
if [[ $hookanswer = y ]] ; then
  echo "Enter SWAP partition: "
  read swappartition
  mkswap $swappartition
fi

pacman -S --noconfirm sed

pacman -S --noconfirm xorg-server xorg-xinit xorg-xkill xorg-xsetroot xorg-xbacklight xorg-xprop \
     noto-fonts noto-fonts-emoji noto-fonts-cjk ttf-jetbrains-mono ttf-joypixels ttf-font-awesome \
     sxiv mpv zathura zathura-pdf-mupdf ffmpeg imagemagick  \
     fzf man-db xwallpaper python-pywal youtube-dl unclutter xclip maim \
     zip unzip unrar p7zip xdotool papirus-icon-theme brightnessctl  \
     dosfstools ntfs-3g git sxhkd zsh pipewire pipewire-pulse \
     vim emacs arc-gtk-theme rsync firefox dash \
     xcompmgr libnotify dunst slock jq \
     dhcpcd networkmanager rsync pamixer

systemctl enable NetworkManager.service 
rm /bin/sh
ln -s dash /bin/sh
echo "%wheel ALL=(ALL) NOPASSWD: ALL" >> /etc/sudoers
echo "Enter Username: "
read username
useradd -m -G wheel -s /bin/zsh $username
passwd $username
echo "Pre-Installation Finish Reboot now"
ai3_path=/home/$username/arch_install3.sh
sed '1,/^#part3$/d' arch_install2.sh > $ai3_path
chown $username:$username $ai3_path
chmod +x $ai3_path
su -c $ai3_path -s /bin/sh $username
exit 

#part3
printf '\033c'
cd $HOME
git clone --separate-git-dir=$HOME/.dotfiles https://github.com/bugswriter/dotfiles.git tmpdotfiles
rsync --recursive --verbose --exclude '.git' tmpdotfiles/ $HOME/
rm -r tmpdotfiles
git clone --depth=1 https://github.com/Bugswriter/dwm.git ~/.local/src/dwm
sudo make -C ~/.local/src/dwm install
git clone --depth=1 https://github.com/Bugswriter/st.git ~/.local/src/st
sudo make -C ~/.local/src/st install
git clone --depth=1 https://github.com/Bugswriter/dmenu.git ~/.local/src/dmenu
sudo make -C ~/.local/src/dmenu install
git clone --depth=1 https://github.com/Bugswriter/baph.git ~/.local/src/baph
sudo make -C ~/.local/src/baph install
baph -inN libxft-bgra-git

ln -s ~/.config/x11/xinitrc .xinitrc
ln -s ~/.config/shell/profile .zprofile
sh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)"
mv ~/.oh-my-zsh ~/.config/zsh/oh-my-zsh
rm ~/.zshrc ~/.zsh_history
mkdir -p ~/dl ~/vids ~/music ~/dox ~/code ~/pix/ss
alias dots='/usr/bin/git --git-dir=$HOME/.dotfiles/ --work-tree=$HOME'
dots config --local status.showUntrackedFiles no
exit
