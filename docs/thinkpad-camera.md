### Kernel module

Install imx471-dkms-git from the aur

Verify with lsmod | grep imx471

### Userspace

Install libcamera and pipewire-libcamera

Verify with qcam

### Applications

mkdir -p ~/.config/wireplumber/wireplumber.conf.d
touch ~/.config/wireplumber/wireplumber.conf.d/10-libcamera.conf

and paste

wireplumber.profiles = {
  main = {
    monitor.libcamera = required
  }
}

Reboot.
Chrome when launched with --enable-features=WebRtcPipeWireCamera should work.
