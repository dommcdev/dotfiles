#!/bin/env bash
set -e #exit immediately if a command exits with a non-zero status

# -------------------------------------------------- #
#                  SOFTWARE INSTALLATION             #
# -------------------------------------------------- #

#Update system
sudo pacman -Syu

#Install yay
echo "Installing yay..."
sudo pacman -S --noconfirm --needed git base-devel
git clone https://aur.archlinux.org/yay.git && cd yay && makepkg -si --noconfirm && cd .. && rm -rf yay
#yay --version

#Install flatpak
echo "Installing flatpak..."
sudo pacman -S --noconfirm --needed flatpak
flatpak remote-add --if-not-exists flathub https://flathub.org/repo/flathub.flatpakrepo
#flatpak --version

#Install arch+aur packages
yay -S --needed --answerdiff None --answerclean None google-chrome ghostty nautilus fastfetch hyprpaper hypridle waybar rofi ttf-jetbrains-mono-nerd stow zsh btop virt-manager blueman

#Install flatpaks
flatpak install --noninteractive flathub org.gimp.GIMP onlyoffice tubeconverter

# -------------------------------------------------- #
#                   SERVICE MANAGEMENT               #
# -------------------------------------------------- #

#Enable various services to start on boot
sudo systemctl enable --now bluetooth.service

# -------------------------------------------------- #
#                     CONFIGURATION                  #
# -------------------------------------------------- #

git config --global credential.helper store
cd ~ && mkdir -p dev && cd dev
git clone http://developermcd.com:8080/Dominic/dotfiles.git
cd dotfiles
for package in */; do
    stow --adopt "${package%/}"
    git restore .
    stow --override "${package%/}" #the %/ removes the trailing slash from directory names
done

