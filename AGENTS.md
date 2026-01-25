# AGENTS.md - Dotfiles Repository

This document provides guidance for AI coding agents working in this dotfiles repository.

## Repository Overview

This is a personal dotfiles repository using **Dotbot** for cross-platform configuration management. It supports Arch Linux, Ubuntu, Fedora, and macOS with profiles for server, desktop environment, and full custom rice setups.

### Key Entry Points

| Script | Purpose |
|--------|---------|
| `./install` | Interactive profile installer |
| `./setup <config>` | Install individual config module (e.g., `./setup all/git`) |
| `./sys` | System detection utility (`./sys id`, `./sys power`, `./sys type`) |

### Directory Structure

```
dotfiles/
├── meta/                    # Dotbot orchestration
│   ├── configs/             # YAML config modules by category
│   │   ├── all/             # Cross-platform (cli, git, nvim, ssh, tmux, zsh)
│   │   ├── arch/            # Arch-specific
│   │   ├── custom/          # Full rice (hypr, waybar, gtk, fonts)
│   │   ├── desktop/         # GUI apps
│   │   ├── linux/           # Linux-generic
│   │   ├── linux-desktop/   # Linux DE-specific
│   │   ├── mac/             # macOS-specific
│   │   └── ubuntu/          # Ubuntu-specific
│   ├── profiles/            # Installation profiles (arch-custom, mac-server, etc.)
│   ├── base.yaml            # Default dotbot settings
│   └── install-profile      # Profile installer script
├── scripts/                 # Utility scripts (symlinked to ~/.local/bin)
├── nvim/                    # Neovim config (Lua)
├── hypr/                    # Hyprland WM configs
├── zsh/                     # Zsh configuration
└── [app-name]/              # Other app configurations
```

## Build / Test / Lint Commands

**There is no formal test suite or linter configured.** This is a dotfiles repo, not a software project.

### Validation Commands

```bash
# Check shell scripts for syntax errors
bash -n scripts/update
bash -n install

# Shellcheck (if installed)
shellcheck scripts/*

# Dry-run dotbot (not supported natively, but you can inspect YAML)
cat meta/configs/all/git.yaml

# Test system detection
./sys id      # Returns: arch, ubuntu, mac, or unknown
./sys power   # Returns: 1 (laptop) or 0 (desktop)
./sys type    # Returns: Linux or Darwin
```

### Running a Single Config

```bash
# Install a specific config module
./setup all/git
./setup all/nvim
./setup custom/hypr

# With sudo prefix for root-level configs
./setup arch/pacman-sudo
```

## Code Style Guidelines

### Shell Scripts

#### Shebang

**ALWAYS** use `#!/usr/bin/env bash` for portability:

```bash
#!/usr/bin/env bash
set -euo pipefail  # Strict mode for critical scripts
```


Use `set -euo pipefail` for critical scripts, or just `set -e` for simpler scripts where unbound variables aren't a concern.

#### Variable Naming

- **UPPER_CASE** for constants and environment-level config:
  ```bash
  NC='\033[0m'
  BASE_CONFIG="base"
  CONFIG_SUFFIX=".yaml"
  ```

- **lower_case** (snake_case) for local/function-scoped variables:
  ```bash
  local id=$1
  target_profile="${CURRENT_ID}-${suffix}"
  ```

#### Function Naming

Both styles are acceptable, but be consistent within a file:

- **snake_case** (preferred for new scripts):
  ```bash
  show_logo() { ... }
  get_current_brightness() { ... }
  ```

- **kebab-case** (used in waybar/grimblast scripts):
  ```bash
  get-icon() { ... }
  toggle-mute() { ... }
  ```

#### Main Function Pattern

Wrap execution logic in a `main` function:

```bash
main() {
    local device=$1
    local action=$2
    # ...
}

main "$@"
```

#### Error Handling

```bash
# Strict mode at script start
set -euo pipefail

# Or just set -e for simpler scripts
set -e

# Check command existence before use
if command -v pacman &>/dev/null; then
    sudo pacman -Syu --noconfirm
fi

# Suppress errors when acceptable
sudo pacman -Rns --noconfirm fprintd 2>/dev/null || true
```

#### Quoting

- **Always double-quote variables**: `"$variable"`, `"${array[@]}"`
- **Single quotes for literals**: `'literal string'`

#### Output Helpers

Use color functions for user feedback:

```bash
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
RED='\033[0;31m'
NC='\033[0m'

print_section() { echo -e "\n${GREEN}==> $1${NC}"; }
print_info() { echo -e "${YELLOW}$1${NC}"; }
print_error() { echo -e "${RED}$1${NC}"; }
```

### Dotbot YAML Configs

#### Structure

Each config file in `meta/configs/` follows this pattern:

```yaml
- link:
    ~/.config/app:
      path: app/*
      glob: true

- shell:
  - command1
  - |
    multiline
    command
```

#### Conditional Installation

Use `./sys` for platform detection:

```yaml
- shell:
  - |
    if [[ "$(./sys id)" == "arch" ]]; then
      sudo pacman -S --noconfirm --needed package
    elif [[ "$(./sys id)" == "ubuntu" ]]; then
      sudo apt install -y package
    elif [[ "$(./sys id)" == "mac" ]]; then
      brew install package
    fi
```

#### Conditional Linking

```yaml
- link:
    ~/.config/hypr/hypridle.conf:
      path: hypr/hypridle-laptop.conf
      if: '[ "$(./sys power)" = "1" ]'

#### Multi-line Content

**Avoid** using `\n` in `echo` commands (e.g., `echo -e "a\nb"`) as it may break the Dotbot YAML parser. Always use heredocs for multi-line content:

```yaml
- shell:
  - |
    sudo tee /path/to/file >/dev/null <<EOF
    line 1
    line 2
    EOF
```

### Idempotency

All shell commands in configs must be idempotent:

- Use `mkdir -p` (not `mkdir`)
- Use `pacman --needed` to skip installed packages
- Use `systemctl enable` (safe to re-run)
- Use `tee` to overwrite config files
- Check before modifying: `grep -q pattern file || echo >> file`

## Common Patterns

### Package Installation

```bash
# Arch
sudo pacman -S --noconfirm --needed package1 package2

# Ubuntu (via Homebrew for consistency)
brew install package

# AUR
yay -S --noconfirm package
```

### Systemd Services

```bash
sudo systemctl enable --now service-name
systemctl --user enable service-name
```

### Creating System Configs

```bash
sudo mkdir -p /etc/app
sudo tee /etc/app/config.conf >/dev/null <<'EOF'
config content here
EOF
```

## Important Notes

- The `./sys` script is the source of truth for platform detection
- Configs are organized by scope: `all/` > `linux/` > `arch/` (most specific)
- Profiles in `meta/profiles/` are simple lists of config paths to install
- The theme is **Catppuccin Mocha** throughout.
- **Clean & Concise Code**: Always prefer simple, readable, and concise solutions. Avoid over-engineering; do not write a 50-line function when a few lines will suffice.
- **IMPORTANT**: When writing new scripts or TUIs, **DO NOT hardcode hex colors** (e.g., Catppuccin Mocha hex codes). Instead, rely on standard terminal ANSI colors (e.g., via `tput setaf`) or tools that use the terminal's color scheme (like `gum`). This ensures the UI respects the user's terminal theme.
- **Gum Usage**: When using `gum`, **ALWAYS** override its default pink/purple colors. Use the terminal's color scheme (e.g., `--border-foreground 4` for blue, `--selected-foreground 2` for green). Never leave `gum` defaults visible.
- Neovim config uses Lua with Lazy.nvim plugin manager
