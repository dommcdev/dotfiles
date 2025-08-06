#!/bin/env bash



# Shared

waybar rofi ttf-jetbrains-mono-nerd zsh btop  neovim adw-gtk-theme  tailscale yazi papirus-icon-theme 

impression audacity gnome-calculator decibels papers loupe showtime switcheroo gnome-calendar libreoffice-fresh blender, kdenlive

# Install aur packages
yay -S --noconfirm --needed --answerdiff None --answerclean None r-quick-share zsh-vi-mode 

# Install flatpaks
flatpak install --noninteractive flathub org.onlyoffice.desktopeditors org.nickvision.tubeconverter io.gitlab.adhami3310.Footage

# Install dev packages
curl -o- https://raw.githubusercontent.com/nvm-sh/nvm/v0.40.3/install.sh | bash
source "$HOME/.config/nvm/nvm.sh" #source file in lieu of restarting the shell
nvm install 22
npm install -g @google/gemini-cli




# Enable various services to start on boot
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
