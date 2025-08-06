#!/bin/env bash


# Terminal
sudo pacman -S --noconfirm --needed openssh wget curl ffmpeg 7zip fd ripgrep poppler zoxide imagemagick chafa resvg ncdu fzf trash-cli bat cava asciiquarium cmatrix cowsay ponysay tldr whois

# Shared

# Install arch packages
sudo pacman -S --noconfirm --needed dunst  grim slurp sddm ghostty nautilus nautilus-python gvfs-smb fastfetch waybar rofi ttf-jetbrains-mono-nerd zsh btop virt-manager blueman neovim adw-gtk-theme pavucontrol networkmanager network-manager-applet nm-connection-editor ddcutil tailscale yazi libnotify noto-fonts-emoji sushi papirus-icon-theme  udiskie

# Install gui packages
sudo pacman -S --noconfirm --needed gimp impression audacity gnome-calculator decibels papers loupe showtime switcheroo gnome-calendar libreoffice-fresh blender, kdenlive

# Install aur packages
yay -S --noconfirm --needed --answerdiff None --answerclean None google-chrome r-quick-share downgrade zsh-vi-mode clipse

# Install flatpaks
flatpak install --noninteractive flathub org.onlyoffice.desktopeditors org.nickvision.tubeconverter io.gitlab.adhami3310.Footage

# Install dev packages
curl -o- https://raw.githubusercontent.com/nvm-sh/nvm/v0.40.3/install.sh | bash
source "$HOME/.config/nvm/nvm.sh" #source file in lieu of restarting the shell
nvm install 22
npm install -g @google/gemini-cli




# Enable various services to start on boot
sudo systemctl enable sddm.service
sudo systemctl enable --now bluetooth.service
sudo systemctl enable --now tailscaled
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


# Authenticate Tailscale (also sign in to Google in the process)
#sudo tailscale up



read -rp "Do you want to reboot? [Y/n]: " choice

# Convert choice to lowercase for easier comparison
choice=${choice,,}

if [[ "$choice" == "y" || "$choice" == "" ]]; then
    echo "Rebooting now..."
    sudo reboot now
else
    echo "Reboot as soon as possible for all configurations to take effect."
fi
