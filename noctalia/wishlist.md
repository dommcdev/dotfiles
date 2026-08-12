## Small QoL stuff/nits
* Hide unamed devices in bluetooth panel (Blueman does this by default)
* Mention in the docs that ethernet status will only be displayed in the network module if using NetworkManager (as opposed to just iwd).
* Default to last logged-in user in the greeter. I believe this is how SDDM does it?
* [Created] Default to XDG_PICTURES_DIR #3415
* Add a feels-like field to weather widget
* Add a settings icon to the network widget that opens nm-connection-editor (?)
* Ability to group a spacer with a bar widget (so that if for some reason the widget doesn't display the spacer doesn't either, e.g. a battery widget).
* [Commented] Add ipc bind for screenshotting with pipe included #3273
* [Commented] Differentiate between battery/ac in idle settings. Especially important for stuff like suspend. #3336
* [Commented] Allow screenshoting specific window #3380
* [Commented] Add action to screenshot notif with customizable open with (previewer and editor) #3303
* [Coming soon] Drawer groups for the bar

## Bugs
* Occasionally the weather visual effects don't work
* Timezone detection is flaky/incorrect sometimes?
* Greeter doesn't respect border radius = 0 setting
* Buttons with borders have weird animation layout shifts
* [Created] Battery widget doesn't work (#345 + og #3436 issue)

## Larger QoL improvements
* Tooltips. Many of the widgets could really use these.

* Configuring stuff is kind of clunky
  * Editing the config file manually is a pain due to settings.toml overriding it AND noctalia not hot-reloading on save.
  * Using the gui is great but it doesn't save to the regular (e.g. git-controlled) config file without manual export. Also not everything in the config is visible in the gui, e.g. a desktop widget from a previous monitor that just needs the size/position tweaked.
  * Ultimately, why does the 2-file config system exist at all? Programs like vicinae allow gui config changes to write directly to the main save file.

* Widgets vs displays. After using hyprlock I get why noctalia did it this way, but it is a big PITA and there are some serious pitfalls.
  * Changing display scale messes up your widgets.
  * Plugging into a different monitor port (or having 2 monitors with DisplayPort, etc) will mess widgets up (??)
