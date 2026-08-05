# 32-bit Graphics Support

These packages are only needed for 32-bit applications such as Steam, Wine, and Proton. Before installing any Ubuntu `:i386` packages, enable the architecture and refresh the package cache:

```yaml
- name: Configure Ubuntu package architectures
  when: is_ubuntu
  block:
    - name: List enabled foreign package architectures
      ansible.builtin.command: dpkg --print-foreign-architectures
      register: ubuntu_foreign_architectures
      changed_when: false

    - name: Enable Ubuntu 32-bit packages
      ansible.builtin.command: dpkg --add-architecture i386
      become: true
      changed_when: true
      when: "'i386' not in ubuntu_foreign_architectures.stdout_lines"
```

## Arch Linux

AMD:

- `lib32-mesa`
- `lib32-vulkan-radeon`

Intel:

- `lib32-mesa`
- `lib32-vulkan-intel`

NVIDIA:

- `lib32-nvidia-utils`

## Fedora

AMD:

- `mesa-dri-drivers.i686`
- `mesa-va-drivers-freeworld.i686`
- `mesa-vulkan-drivers.i686`

Intel:

- `mesa-dri-drivers.i686`
- `mesa-vulkan-drivers.i686`

NVIDIA:

- `xorg-x11-drv-nvidia-libs.i686`

Current Fedora normally installs the NVIDIA package automatically through RPM Boolean dependencies.

## Ubuntu

AMD:

- `libgl1-mesa-dri:i386`
- `mesa-va-drivers:i386`
- `mesa-vdpau-drivers:i386`
- `mesa-vulkan-drivers:i386`

Intel:

- `intel-media-va-driver-non-free:i386`
- `libgl1-mesa-dri:i386`
- `mesa-vulkan-drivers:i386`

NVIDIA:

- `libnvidia-gl-<driver-version>:i386`
- `libvulkan1:i386`

The NVIDIA library version must match the installed driver, such as `libnvidia-gl-580:i386` for `nvidia-driver-580-open`.
