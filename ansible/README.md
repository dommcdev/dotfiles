# Ansible Dotfiles

This folder is the Ansible migration target for the Dotbot profiles under `meta/`.

## Layout

- `site.yml`: single playbook targeting `all`.
- `inventory.yml`: static persona matrix using `servers`, `desktops`, `custom`, and `laptops` groups.
- `group_vars/all.yml`: shared paths, OS flags, environment injection, and package matrices.
- `tasks/terminal.yml`: headless-safe CLI and TUI tools from the old `cli.yaml` and `tui.yaml`, except Yazi.
- `tasks/yazi.yml`: Yazi install, config link, and package sync.
- `tasks/gui.yml`: graphical apps and desktop-only developer tools.
- `tasks/mac.yml`: macOS-only configuration, Karabiner, Raycast, and Rectangle.
- `tasks/looknfeel.yml`: fonts, GTK, QT, icons, and cursors.
- `tasks/misc.yml`: bootstrap work, small distro conditionals, laptop conditionals, wallpapers, fun tools, Timeshift, and other small items.
- Dedicated task files remain for larger or swappable components such as `hypr.yml`, `waybar.yml`, `vicinae.yml`, `network.yml`, `printing.yml`, and `virtualization.yml`.

## Run

```bash
cd ansible
ansible-playbook site.yml
```

Edit `inventory.yml` to move hosts between persona groups. OS-specific behavior is handled with facts and `when:` blocks inside task files rather than separate `arch.yml`, `ubuntu.yml`, or `fedora.yml` files.
