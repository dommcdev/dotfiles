### Install Packages
Ensure `ethtool` and `wakeonlan` are installed

### Tweak BIOS Settings
Look for and enable settings that mention
* Wake on LAN
* Power on by PCI-E
* Resume by PME

Also make sure ErP is disabled

### Enable WOL in kernel
Create `/etc/udev/rules.d/81-wol.rules` and paste the following:
```
ACTION=="add", SUBSYSTEM=="net", NAME=="en*", RUN+="/usr/bin/ethtool -s $name wol g"
```
Then reload udev to arm it:
`sudo udevadm control --reload-rules && sudo udevadm trigger`

Note: Alternatively, you can run the above ethtool cmd via a systemd service, cron job, etc...it just has to be run once per boot. You could also create `/etc/systemd/network/50-wol.link` but this would require taking over the functionality of `/usr/lib/systemd/network/99-default.link` since only the higher priority file from the above will be run.

More info: https://wiki.archlinux.org/title/Wake-on-LAN
