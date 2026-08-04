- `ghostty +boo`
- `systemctl reboot --firmware-setup`
- Audio center: `wiremix`
- Disks: `caligula`, `disktui`
- Disk usage: `dust`, `duf`
- Convert images/pdf-to-image: `magick`
- Work with pdfs: `poppler-utils`, e.g. `pdfunite`
- View hardware info etc: `hostnamectl`
- Laptop mirroring wonky: `hyprctl reload`
- `hunk` diff for diff tui
- `systemd-analyze critical-chain` and `systemd-analyze blame`
- `scp` for quick simple file transfers

## For rebooting:

- `systemctl reboot`
- `reboot` (symlink to above)
- `shutdown -r now` (classic)

## For shutdown

- `systemctl poweroff`
- `poweroff` (symlink to above)
- `shutdown now` (classic)

## Logging out

On hyprland, `uwsm stop` should work. `loginctl terminate-session [session id]` works in vicinae, but not by itself in a terminal (screen freezes).

## Archiving/unarchiving

- `ouch`: everyday compression/decompression, nice tui
- `7zip`: high compression, good decompression
- `unar`: great decompression, fixes gibberish text
- `unrar`: best rar decompression (official spec)
- `unzip`: not special other than being a common dep (e.g. for nvim plugins)

## Flatpak overrides
- `flatpak override --user --show`
- `flatpak override --user --reset`
- `flatpak mask` to view masked apps
Whether to pass --user or not depends on whether you used `flatpak cmd` vs `sudo flatpak cmd`

## cp command

When copying *folders*, `cp` is NOT idempotent.
`cp src/ dest/` will clone src and rename as dest on a first run,
but create `dest/src` on the second run
use `rsync -a src/ dest/` instead, but keep in mind `src/` copies contents of src,
while `src` (no trailing /) copies the folder itself

## greping through entire git history

```sh
git rev-list --all | xargs git grep "string_to_find"
```

## Connecting to edurom (impala)

Use PEAP. For identity put full email; for phase2 identity put full email; for phase2 password put your stmu password. Leave phase2 method as mschapv2, and leave server domain mask, ca cert, client cert, client key, and key passphrase empty. You will be prompted to enter username/password - enter stmu email/password (again).

Note - using the eduroam option with full email + full email + password seems to work as well.

## Networking stuff

`wireless-regdb` might be necessary for setting regulartory domain on some wireless cards

## Opencode Notes

Run `opencode auth login --provider cursor`

https://github.com/ephraimduncan/opencode-cursor

## Git submodules

Two parts - actual file contents, and commit hash which tries to match those file contents.

`git submodule update --init --recursive --remote` grabs the latest commits from the remote (and dotbot does this automatically on each run). This changes both the files and the pointer, so it makes sense to add/commit the updated pointer.

HOWEVER, if you then do `git pull` on a different machine, it gets the updated pointer but NOT the updated files - they are now out of sync. If you run `git add/commit` at this point git will think you want to revert the pointer to match the files you have currently. This will work, but then running `git pull` on the og machine will then have the same problem, i.e. the files belong to [newer commit] but you just pulled [older commit].

The solution is to run `git submodule update` after pulling any commits that change the submodule commit pointer. This ensures that the files you have match the submodule commit pointer you last committed.

## Firmware updates

fwupd.org

```sh
fwupdmgr refresh
fwupdmgr get-updates
fwupdmgr update
fwupdmgr get-history
```

## AI Docs

Tell it to adhere to ASD-STE100 Simplified Technical English

## Getting Docker and Libvirt to play nicely.

On a normal Linux machine ip forwarding is disabled by default.

However, both docker and libvirt enable ip forwarding, with some firewall rules.

* Docker with the iptables backend sets a global FORWARD DROP policy, except for Docker and explicit user (DOCKER-USER) exceptions.
* Libvirt genrally only restricts virbr0 traffic, leaving the global FORWARD policy to ACCEPT.
* Docker with the nftables backend mimics libvirt more, i.e. doesn't set a global FORWARD DROP policy.

So to prevent Docker from stepping on Libvirt's toes, you can either

* Add some DOCKER-USER chain rules. It it somewhat complex to get these to persist though.
```sh
sudo iptables -w 10 -I DOCKER-USER 1 -i 'virbr+' -m conntrack --ctstate NEW,ESTABLISHED,RELATED -j ACCEPT
sudo iptables -w 10 -I DOCKER-USER 1 -o 'virbr+' -m conntrack --ctstate ESTABLISHED,RELATED -j ACCEPT
```
* Switch Docker to the experimental nftables backend
* Add `"ip-forward-no-drop": true` to `/etc/docker/daemon.json`

## GTK theming

### Adw-gtk3 theme
Both gtk3 and gtk4 can have their stylesheets overridden by an external theme.
Therefore, the adw-gtk theme in /usr/share/themes modifies gtk3/gtk4 apps to look like libadwaita apps.
It does not touch libadwaita apps though. It does define colors, but they will be the default libadwaita ones.

### Colors
It would be possible to replace the @define colors in the theme itself with the correct ones, however this would be more hassle than it is worth.
Instead, for gtk3 we can override colors in .config/gtk-3.0/gtk.css, and for gtk4 we can override colors in .config/gtk-4.0/gtk.css. The latter is where we can also put any styling/ui overrides for libadwaita apps as well.

### Applying GTK theme
For gtk3, use gsettings (gtk-theme and color-scheme)
For libadwaita, use custom gtk.css in ~/.config/gtk-4.0/

### Flatpaks
The adw-gtk3 theme should be installed automatically unless explicitly masked.

If your desired theme is not avaible as a flatpak you can instead place it in `~/.local/share/themes` and then put in a global flatpak overrides to allow sandbox access. If you want to install a theme from a package manager you will need to set up a hook to copy the theme from `/usr/share/themes` on update.

For getting the correct colors, simply put in an override to allow `~/.config/gtk-3.0/` and `~/.config/gtk-4.0/` into the sandbox. IMPORTANT: The folder itself can be a symlink, but the individual files cannot be!

### Hyprland theming
`~/.config/hypr/application-style.conf` provides styling for hypr* qt6 apps. See https://wiki.hypr.land/Hypr-Ecosystem/hyprland-qt-support/

More useful is `~/.config/hypr/hyprtoolkit.conf`, which themings hyprland dialogs, etc.

### Cursor theming

Place Hyprcursor themes in `~/.local/share/icons/`. Hyprland detects them automatically. If more than one theme is installed, set `HYPRCURSOR_THEME` and `HYPRCURSOR_SIZE` in `~/.config/uwsm/env-hyprland`.

Alternatively, add `exec-once = hyprctl setcursor <name> <size>` to the Hyprland config. This also works with XCursor themes.

For XWayland applications, set the cursor theme with `Inherits=<name>` in `~/.local/share/icons/default/index.theme`.
