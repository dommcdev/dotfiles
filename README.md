# Dotfiles

My personal dotfiles as well as a comprehensive Ansible playbook for configuring my machines.

## Features

- **DE**: Hyprland + Noctalia
- **Terminal**: Ghostty
- **Shell**: Zsh, Starship, Zoxide, Fastfetch
- **Editor**: Neovim, Zed, Opencode
- **Notable Programs**: Yazi, Keyd, Tailscale, Vicinae, Btop, Virt-manager, Feishin, Obsidian, etc

## Setup

1. Install a distro via its normal installer. Ensure the openssh-server (openssh on Arch) package is included as well as basic networking.
2. On the fresh machine run `ip addr`; add the new machine to `inventory.yml`.
3. On any existing machine run `make install-fresh`. Answer the prompts (you will need a Tailscale Auth key). Grab a coffee.
4. Once done swap the raw ip in `inventory.yml` with the new tailscale magicDNS name, and add the sudo password to `secrets.yml`
5. (Optional) Run `make post-install` on the fresh machine.
