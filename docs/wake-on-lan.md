### Install Packages
Ensure `ethtool` and `wakeonlan` are installed

### Tweak BIOS Settings
Look for and enable settings that mention
* Wake on LAN
* Power on by PCI-E
* Resume by PME

Also make sure ErP is disabled

### Enable in Kernel
Create `/etc/systemd/network/50-wol.link` and paste the following:
```toml
[Match]
MACAddress=12:34:56:78:9a:bc  # Replace with your actual MAC address

[Link]
WakeOnLan=magic
```
