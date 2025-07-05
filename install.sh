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

# Install Hyprland core packages
sudo pacman -S --noconfirm --needed dunst uwsm xdg-desktop-portal-hyprland xdg-desktop-portal-gtk qt5-wayland qt6-wayland hyprpolkitagent grim slurp sddm hyprland

# Install arch packages
sudo pacman -S --noconfirm --needed ghostty nautilus nautilus-python fastfetch hyprpaper hypridle waybar rofi ttf-jetbrains-mono-nerd stow zsh btop virt-manager blueman neovim cliphist hyprpicker hyprsunset adw-gtk-theme pavucontrol networkmanager

# Install aur packages
yay -S --noconfirm --needed --answerdiff None --answerclean None google-chrome

# Install flatpaks
flatpak install --noninteractive flathub org.gimp.GIMP org.onlyoffice.desktopeditors org.nickvision.tubeconverter


# -------------------------------------------------- #
#                     CONFIGURATION                  #
# -------------------------------------------------- #

git config --global credential.helper store
cd ~/dev/dotfiles
git pull
stow --adopt ghostty gtk hyprland hyprpaper waybar rofi apps zsh
git restore .
stow --override ghostty gtk hyprland hyprpaper waybar rofi apps zsh 


# -------------------------------------------------- #
#                   ONE-TIME COMMANDS                #
# -------------------------------------------------- #

# Enable various services to start on boot
sudo systemctl enable --now sddm.service
#sudo systemctl enable --now bluetooth.service
systemctl --user enable --now hyprpolkitagent.service
systemctl --user enable --now hyprpaper.service
systemctl --user enable --now waybar.service

# Getting GTK theme to apply everywhere
mkdir -p ~/.local/share/themes/
ln -s /usr/share/themes/adw-gtk3 ~/.local/share/themes/adw-gtk3
flatpak override --user --filesystem=xdg-config/gtk-4.0
flatpak override --user --filesystem=xdg-config/gtk-3.0
flatpak override --user --filesystem=xdg-data/themes
gsettings set org.gnome.desktop.interface gtk-theme "adw-gtk3"
gsettings set org.gnome.desktop.interface color-scheme 'prefer-dark'
sudo flatpak mask org.gtk.Gtk3theme.adw-gtk3
sudo flatpak mask org.gtk.Gtk3theme.adw-gtk3-dark


echo "-----------------------------------DONE!!!-------------------------"

read -rp "Do you want to reboot? [Y/n]: " choice

# Convert choice to lowercase for easier comparison
choice=${choice,,}

if [[ "$choice" == "y" || "$choice" == "" ]]; then
    echo "Rebooting..."
    sudo reboot now
else
    echo "Reboot as soon as possible for all configurations to take effect."
fi
