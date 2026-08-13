# Syncthing Automation

## Goal

Keep `chocobo` as the stable hub and treat every other machine as a disposable spoke.
Ansible should discover device IDs at runtime, connect both sides, and configure the
`Library` and `Downloads` folders without using Syncthing GUIs or storing IDs in inventory.

Expose only `chocobo`'s GUI to the LAN over HTTPS. Its password may be configured manually.

## Status

- An oversized draft exists in `tasks/apps/syncthing.yml`.
- It passes Ansible syntax and lint checks.
- It has not been run, so it has not changed any Syncthing configuration.
- It still needs to be reviewed and replaced with a much smaller, maintainable approach.
