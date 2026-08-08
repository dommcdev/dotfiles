Don't include a system update anywhere in the taskfiles. This will break stuff, e.g. openssh will need restarting, uinput won't be loaded if the linux kernel updates, etc.

### Homebrew
The Ansible community module handles setting the env PATH to include the brew binary.
