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
2. Add the new machine to `inventory.yml`. You will need its ip address and username.
3. Optionally add a Tailscale auth key to `secrets.yml`, as well as the new machine's sudo/ssh password, then run `./install MACHINE` on any existing machine.
4. Once done, replace the raw IP in `inventory.yml` with the new Tailscale MagicDNS name. Add the MagicDNS name and user to the SSH config as well. You can remove ansible_user from the machine at this point.
5. Run `./install final` on the fresh machine.

Use `./install --no-pull MACHINE` to retry against the current worktree without pulling first.
