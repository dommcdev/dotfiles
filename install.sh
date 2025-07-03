#!/bin/env bash

# Prerequisites
# sudo pacman -Syu git
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
#yay --version

# Install flatpak
echo "Installing flatpak..."
sudo pacman -S --noconfirm --needed flatpak
flatpak remote-add --if-not-exists flathub https://flathub.org/repo/flathub.flatpakrepo
#flatpak --version

# Install Hyprland core packages
sudo pacman -S --noconfirm --needed hyprland dunst uwsm xdg-desktop-portal-hyprland qt5-wayland qt6-wayland hyprpolkitagent grim slurp sddm

# Install arch packages
sudo pacman -S --noconfirm --needed ghostty nautilus nautilus-python fastfetch hyprpaper hypridle waybar rofi ttf-jetbrains-mono-nerd stow zsh btop virt-manager blueman neovim cliphist hyprpicker hyprsunset adw-gtk-theme

# Install aur packages
yay -S --noconfirm --needed --answerdiff None --answerclean None google-chrome

# Install flatpaks
flatpak install --noninteractive flathub org.gimp.GIMP org.onlyoffice.desktopeditors org.nickvision.tubeconverter org.gtk.Gtk3theme.adw-gtk3

# -------------------------------------------------- #
#                   SERVICE MANAGEMENT               #
# -------------------------------------------------- #

#Enable various services to start on boot
sudo systemctl enable --now sddm.service
#sudo systemctl enable --now bluetooth.service
systemctl --user enable --now hyprpolkitagent.service
systemctl --user enable --now hyprpaper.service
systemctl --user enable --now waybar.service

# -------------------------------------------------- #
#                     CONFIGURATION                  #
# -------------------------------------------------- #

git config --global credential.helper store
cd ~/dev/dotfiles
git pull
stow --adopt ghostty gtk hyprland hyprpaper waybar rofi apps
git restore .
stow --override ghostty gtk hyprland hyprpaper waybar rofi apps

