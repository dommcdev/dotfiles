# Syncthing Automation

Ansible now performs the complete initial setup without the Syncthing GUI:

- `chocobo` is the hub and every other host in the play is a spoke.
- Device IDs are discovered during the play and are not stored in inventory.
- `Library` and `Downloads` are created and shared by `chocobo`.
- Spokes automatically accept folders from `chocobo` under their home directory.
- Every peer uses its inventory hostname directly on port 22000.
- Discovery, relays, and NAT traversal are disabled.
- The GUI remains localhost-only, so it needs neither LAN exposure nor a password.

Run the play for `chocobo` and the desired spokes together. Replacing a machine adds
its new identity automatically. Old identities are deliberately not removed: automatic
identity deletion adds substantial complexity and is rarely needed.

Syncthing cannot trust arbitrary unknown devices. Device IDs are its authentication
mechanism, but Ansible discovers and exchanges them so there is no manual approval.

Syncthing is retained instead of using Unison or lsyncd. Unison needs a scheduled or
long-running process for each spoke and matching versions on both ends. Lsyncd is only
a one-way mirror and is unsafe when files can be changed on both machines.
