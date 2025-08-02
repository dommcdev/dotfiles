#!/bin/env bash

# Prerequisites
# sudo pacman -S git
# mkdir dev && cd dev
# git clone http://developermcd.com:8080/Dominic/dotfiles.git

# -------------------------------------------------- #
#                  SOFTWARE INSTALLATION             #
# -------------------------------------------------- #

# Make sure system is up to date
sudo pacman -Syu

# Install yay
echo "Installing yay..."
sudo pacman -S --noconfirm --needed git base-devel
git clone https://aur.archlinux.org/yay.git && cd yay
makepkg -si --noconfirm && cd .. && rm -rf yay

# Install flatpak
echo "Installing flatpak..."
sudo pacman -S --noconfirm --needed flatpak
flatpak remote-add --if-not-exists flathub https://flathub.org/repo/flathub.flatpakrepo

# Install graphics drivers
sudo pacman -S --noconfirm --needed libva-mesa-driver libva-utils mesa vulkan-radeon

# Install useful utilies
sudo pacman -S --noconfirm --needed openssh wget iwd wireless_tools wpa_supplicant smartmontools xdg-utils bluez bluez-utils curl ffmpeg gst-plugins-good gst-plugins-bad gst-plugins-ugly gst-libav jq 7zip fd ripgrep poppler zoxide imagemagick chafa resvg qt6-svg qt6-declarative qt5-quickcontrols2 udiskie

# Install arch packages
sudo pacman -S --noconfirm --needed dunst uwsm xdg-desktop-portal-hyprland xdg-desktop-portal-gtk qt5-wayland qt6-wayland hyprpolkitagent grim slurp sddm hyprland hyprlock hypridle hyprpaper hyprpicker hyprsunset ghostty nautilus nautilus-python gvfs-smb fastfetch waybar rofi ttf-jetbrains-mono-nerd stow zsh btop virt-manager blueman neovim cliphist adw-gtk-theme pavucontrol networkmanager network-manager-applet nm-connection-editor ddcutil tailscale yazi fzf libnotify trash-cli noto-fonts-emoji sushi bat cava asciiquarium cmatrix cowsay ponysay papirus-icon-theme

# Install gui packages
sudo pacman -S --noconfirm --needed gimp impression audacity gnome-calculator decibels papers loupe showtime switcheroo gnome-calendar libreoffice-fresh blender, kdenlive

# Install aur packages
yay -S --noconfirm --needed --answerdiff None --answerclean None google-chrome r-quick-share downgrade zsh-vi-mode

# Install flatpaks
flatpak install --noninteractive flathub org.onlyoffice.desktopeditors org.nickvision.tubeconverter io.gitlab.adhami3310.Footage

# Install dev packages
curl -o- https://raw.githubusercontent.com/nvm-sh/nvm/v0.40.3/install.sh | bash
source "$HOME/.config/nvm/nvm.sh" #source file in lieu of restarting the shell
nvm install 22
npm install -g @google/gemini-cli

# -------------------------------------------------- #
#                     CONFIGURATION                  #
# -------------------------------------------------- #

# Ensure some dirs exist (or don't exist)
mkdir -p ~/Downloads


# Apply dotfiles, authenticate gitlab
cd ~/dev/dotfiles && ./install
git pull #neccesary to populate gitcredentials

# Enable various services to start on boot
sudo systemctl enable sddm.service
sudo systemctl enable --now bluetooth.service
sudo systemctl enable --now tailscaled
systemctl --user enable hyprpolkitagent.service
systemctl --user enable hyprpaper.service
systemctl --user enable hypridle.service
systemctl --user enable waybar.service
systemctl --user enable sunshine.service

# Get GTK theme to apply everywhere
flatpak override --user --filesystem=xdg-config/gtk-4.0
flatpak override --user --filesystem=xdg-config/gtk-3.0
flatpak override --user --filesystem=xdg-data/themes
gsettings set org.gnome.desktop.interface gtk-theme "adw-gtk3"
gsettings set org.gnome.desktop.interface color-scheme 'prefer-dark'
sudo flatpak mask org.gtk.Gtk3theme.adw-gtk3
sudo flatpak mask org.gtk.Gtk3theme.adw-gtk3-dark

# Install and apply icon theme
cd ~/dev
git clone https://github.com/vinceliuice/Colloid-icon-theme.git && cd Colloid-icon-theme
./install.sh -s catppuccin -t yellow -b
cd .. && rm -rf Colloid-icon-them
gsettings set org.gnome.desktop.interface icon-theme "Colloid-Yellow-Catppuccin-Dark"

# Apply grub theme/config
#sudo mv /etc/default/grub /etc/default/grub.bak
#cd ~/dev/dotfiles && sudo stow --dotfiles --target=/ grub
#sudo grub-mkconfig -o /boot/grub/grub.cfg

# Change shell
chsh -s /usr/bin/zsh

# Authenticate Tailscale (also sign in to Google in the process)
#sudo tailscale up


echo "-----------------------------------DONE!!!-------------------------"

read -rp "Do you want to reboot? [Y/n]: " choice

# Convert choice to lowercase for easier comparison
choice=${choice,,}

if [[ "$choice" == "y" || "$choice" == "" ]]; then
    echo "Rebooting now..."
    sudo reboot now
else
    echo "Reboot as soon as possible for all configurations to take effect."
fi
