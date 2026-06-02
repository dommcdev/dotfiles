# Ansible Dotfiles Infrastructure Architecture Summary

## 1. Inventory Strategy (`inventory.yml`)
* **Static Matrix:** Replaces interactive script prompts with a flat host-to-group layout.
* **Horizontal Persona Groups:** Machines are categorized into operational trait groups (`servers`, `desktops`, `custom`, `laptops`) based on their role, not their operating system.
* **Dynamic Fact Discovery:** Operating system details (Arch vs. macOS/Darwin) are handled automatically by Ansible's native fact gathering engine at runtime.

## 2. Playbook Hierarchy (`site.yml`)
* **Single Master Playbook:** Your setup utilizes exactly one control playbook (`site.yml`).
* **Single Universal Play:** Targets `hosts: all` to process your entire machine fleet concurrently.
* **Top-to-Bottom Execution:** Playbooks run sequentially. A failure in an early bootstrap step instantly halts execution on that specific machine to prevent cascading configuration errors.
* **Fluid Skipping:** Features like graphical environments use high-level conditional hooks (`when: "'desktops' in group_names"`) to skip execution loops on headless hardware within milliseconds.

## 3. Configuration Decoupling (`group_vars/`)
* **Separation of Concerns:** Hardcoded binary paths and custom parameters are removed from task scripts and stored in localized variable sheets (`group_vars/all.yml`, `group_vars/servers.yml`, etc.).
* **Centralized Environment Injections:** To solve path tracking issues with runtimes like Homebrew and Bun before your customized shell configuration is active, reusable `$PATH` dictionaries are maintained here.

## 4. Task File Organization (`tasks/*.yml`)
* **Application Colocation:** One file per application. The installation of packages, file symlinks, configuration updates, and service triggers all live under one roof (e.g., `tasks/network.yml`).
* **Declarative Native Modules:** Imperative shell blocks are replaced with native, state-aware components like `ansible.builtin.file` for symlinks, `ansible.builtin.package` for binaries, and `ansible.builtin.systemd` for services.
* **Localized Path Injection:** Tasks or blocks interacting with localized runtimes call the environment dictionaries directly (`environment: "{{ brew_environment }}"`), modifying the execution path in-memory without polluting the host environment.

## 5. Service Lifecycle Management
* **Dynamic Inline Handlers:** By calling your task files via dynamic includes (`include_tasks`), you can place `handlers:` blocks directly at the bottom of the exact same configuration files they manage.
* **Idempotent Restarts:** Restarts are purely event-driven. A service will only cycle if an asset or configuration file actually logs a state change during the run.
* **Session Resilience:** Graphical user-space units (like `hypridle`) use a native `systemctl --user is-systemd-managed` validation check in their handlers. If you bootstrap from a raw TTY or SSH, the configuration reload skips cleanly; if you are inside an active desktop session, the daemon reloads your settings instantly.
