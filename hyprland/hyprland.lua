require("keybindings")

-- ################
-- ### MONITORS ###
-- ################
local thinkpad = "desc:Samsung Display Corp. ATNA53JB01-0"
local dell27 = "desc:Dell Inc. DELL G2724D CDDZ5Y3"

hl.monitor({ output = dell27, mode = "2560x1440@165", position = "auto", scale = 1 })
hl.monitor({ output = thinkpad, mode = "2880x1800@120", position = "auto", scale = 1.5 })

hl.monitor({ output = "", mode = "preferred", position = "auto", scale = 1, mirror = "eDP-1" })

-- #################
-- ### AUTOSTART ###
-- #################
hl.on("hyprland.start", function()
  hl.exec_cmd("udiskie")
  hl.exec_cmd("noctalia")
  hl.exec_cmd("hyprctl setcursor breeze_cursors 24")
end)

-- #############################
-- ### ENVIRONMENT VARIABLES ###
-- #############################
-- uwsm users should avoid placing environment variables in this file.
-- Instead, use ~/.config/uwsm/env for theming, xcursor, Nvidia and toolkit variables,
-- and ~/.config/uwsm/env-hyprland for HYPR* and AQ_* variables.
-- The format is export KEY=VAL

-- #####################
-- ### LOOK AND FEEL ###
-- #####################
local noctalia = require("noctalia")
noctalia.apply_theme()

hl.config({
  general = {
    gaps_in = 4,
    gaps_out = 8,

    border_size = 3,

    col = {
      --inactive_border = "rgba(bac2deaa)",
    },

    -- Set to true to enable resizing windows by clicking and dragging on borders and gaps
    resize_on_border = false,
    layout = "dwindle",
  },
})
-- Fullscreen windows have red border
hl.window_rule({ match = { fullscreen = true }, border_color = noctalia.colors.error })

hl.config({
  decoration = {
    rounding = 0,
    rounding_power = 0,

    -- Change transparency of focused and unfocused windows
    active_opacity = 1.0,
    inactive_opacity = 0.97, --default is 1.0
    --dim_inactive = true
    --dim_strength = 0.1

    shadow = {
      enabled = false,
      range = 4,
      render_power = 3,
      color = 0xee1a1a1a,
    },

    blur = {
      enabled = true,
      size = 3,
      passes = 3, --could use 3, but uses more gpu

      vibrancy = 0.1696,
    },
  },
})

hl.config({
  xwayland = {
    force_zero_scaling = true,
  },
})

hl.config({
  animations = {
    enabled = true,
  },
})

-- Default animations, see https://wiki.hypr.land/Configuring/Animations/
hl.curve("easeOutQuint", { type = "bezier", points = { { 0.23, 1 }, { 0.32, 1 } } })
hl.curve("easeInOutCubic", { type = "bezier", points = { { 0.65, 0.05 }, { 0.36, 1 } } })
hl.curve("linear", { type = "bezier", points = { { 0, 0 }, { 1, 1 } } })
hl.curve("almostLinear", { type = "bezier", points = { { 0.5, 0.5 }, { 0.75, 1.0 } } })
hl.curve("quick", { type = "bezier", points = { { 0.15, 0 }, { 0.1, 1 } } })
hl.curve("wind", { type = "bezier", points = { { 0.05, 0.9 }, { 0.1, 1.05 } } })
hl.curve("smoothFast", { type = "bezier", points = { { 0.33, 1 }, { 0.68, 1 } } }) -- Smooth but minimal easing, almost linear
hl.curve("gentle", { type = "bezier", points = { { 0.4, 0 }, { 0.2, 1 } } }) -- Gentle ease in/out, short travel
hl.curve("flat", { type = "bezier", points = { { 0.25, 0.25 }, { 0.75, 0.75 } } }) -- Almost no curve (linear-ish but softer)

hl.animation({ leaf = "global", enabled = true, speed = 10, bezier = "default" })
hl.animation({ leaf = "border", enabled = true, speed = 5.39, bezier = "easeOutQuint" })
hl.animation({ leaf = "windows", enabled = true, speed = 4.79, bezier = "easeOutQuint" })
hl.animation({ leaf = "windowsIn", enabled = true, speed = 4.1, bezier = "easeOutQuint", style = "popin 87%" })
hl.animation({ leaf = "windowsOut", enabled = true, speed = 1.49, bezier = "linear", style = "popin 87%" })
hl.animation({ leaf = "fadeIn", enabled = true, speed = 1.73, bezier = "almostLinear" })
hl.animation({ leaf = "fadeOut", enabled = true, speed = 1.46, bezier = "almostLinear" })
hl.animation({ leaf = "fade", enabled = true, speed = 3.03, bezier = "quick" })
hl.animation({ leaf = "layers", enabled = true, speed = 3.81, bezier = "easeOutQuint" })
hl.animation({ leaf = "layersIn", enabled = true, speed = 4, bezier = "easeOutQuint", style = "fade" })
hl.animation({ leaf = "layersOut", enabled = true, speed = 1.5, bezier = "linear", style = "fade" })
hl.animation({ leaf = "fadeLayersIn", enabled = true, speed = 1.79, bezier = "almostLinear" })
hl.animation({ leaf = "fadeLayersOut", enabled = true, speed = 1.39, bezier = "almostLinear" })
hl.animation({ leaf = "workspaces", enabled = false }) --no animation
--hl.animation({ leaf = "workspaces", enabled = true, speed = 1, bezier = "easeOutQuint" }) --super quick slide
--hl.animation({ leaf = "workspaces", enabled = true, speed = 4, bezier = "wind" }) --fancy, with spring
--hl.animation({ leaf = "workspacesIn", enabled = true, speed = 1.21, bezier = "almostLinear", style = "fade" }) --default
--hl.animation({ leaf = "workspacesOut", enabled = true, speed = 1.94, bezier = "almostLinear", style = "fade" }) --default

hl.config({
  dwindle = {
    preserve_split = true, -- You probably want this
  },
})

-- For grandorgue
hl.config({
  master = {
    new_status = "slave",
    mfact = 0.07,
  },
})

hl.config({
  misc = {
    force_default_wallpaper = 0, -- Set to 0 or 1 to disable the anime mascot wallpapers
    disable_hyprland_logo = true, -- If true disables the random backgrounds
    focus_on_activate = true,
  },
})

-- #############
-- ### INPUT ###
-- #############
hl.config({
  input = {
    kb_layout = "us",
    kb_variant = "",
    kb_model = "",
    kb_options = "",
    kb_rules = "",

    numlock_by_default = true,
    follow_mouse = 1,
    repeat_rate = 45,

    sensitivity = 0, -- -1.0 - 1.0, 0 means no modification.

    touchpad = {
      natural_scroll = false,
      scroll_factor = 0.4,
      clickfinger_behavior = true,
      tap_to_click = true,
    },
  },
})

hl.config({
  gestures = {
    -- Note - two-finger gestures are supported but don't work on all trackpads.
    --    gesture = 3, left, dispatcher, exec, wtype -M alt -P left -p left -m alt
    --    gesture = 3, right, dispatcher, exec, wtype -M alt -P right -p right -m alt
    workspace_swipe_invert = false,
  },
})
hl.gesture({ fingers = 3, direction = "horizontal", action = "workspace" })

-- ##############################
-- ### WINDOWS AND WORKSPACES ###
-- ##############################

-- Tags
hl.window_rule({ match = { class = "^(showtime|decibels)$" }, tag = "+multimedia_video" })
hl.window_rule({ match = { class = "^(org.gnome.Loupe|org.gnome.Papers)$" }, tag = "+viewer" })

-- Ignore maximize requests from apps
hl.window_rule({ match = { class = ".*" }, suppress_event = "maximize" })

-- Fix some dragging issues with XWayland
hl.window_rule({
  match = { class = "^$", title = "^$", xwayland = true, float = true, fullscreen = false, pin = false },
  no_focus = true,
})

-- Fix issue where PWAs running in XWayland open as floating windows
hl.window_rule({ match = { class = "Google-chrome" }, tile = true })

-- Custom scroll factor for Ghostty
hl.window_rule({ match = { class = "com.mitchellh.ghostty" }, scroll_touchpad = 0.2 })

-- Always workspace 5 for specific creative apps
hl.window_rule({ match = { class = "^(gimp|org.kde.kdenlive|blender)$" }, workspace = "5" })

-- Make popups/dialogs act as such
hl.window_rule({
  match = { class = "^(xdg-desktop-portal-gtk)$" },
  float = true,
  center = true,
  size = { "monitor_w*0.5", "monitor_h*0.6" },
})
hl.window_rule({
  match = { initial_title = "(Open Files)" },
  float = true,
  center = true,
  size = { "monitor_w*0.7", "monitor_h*0.6" },
})

-- Float wlctl, bluetui, wiremix, btop, sushi, settings, and calculator
hl.window_rule({
  match = { class = "com.dominic.wlctl" },
  float = true,
  center = true,
  size = { "monitor_w*0.55", "monitor_h*0.55" },
  stay_focused = true,
  dim_around = true,
})
hl.window_rule({
  match = { class = "com.dominic.bluetui" },
  float = true,
  center = true,
  size = { "monitor_w*0.5", "monitor_h*0.5" },
  stay_focused = true,
  dim_around = true,
})
hl.window_rule({
  match = { class = "com.dominic.wiremix" },
  float = true,
  center = true,
  size = { "monitor_w*0.5", "monitor_h*0.5" },
  stay_focused = true,
  dim_around = true,
})
hl.window_rule({
  match = { class = "com.dominic.calc" },
  float = true,
  center = true,
  size = { "monitor_w*0.3", "monitor_h*0.5" },
})
hl.window_rule({
  match = { class = "com.dominic.btop" },
  float = true,
  center = true,
  size = { "monitor_w*0.70", "monitor_h*0.70" },
  stay_focused = true,
  dim_around = true,
})
hl.window_rule({
  match = { class = "com.dominic.cal" },
  float = true,
  center = true,
  size = { 750, 820 },
  stay_focused = true,
  dim_around = true,
})
hl.window_rule({
  match = { class = "com.dominic.powerbutton" },
  float = true,
  center = true,
  size = { 500, 250 },
  stay_focused = true,
  dim_around = true,
})
hl.window_rule({ match = { class = "com.dominic.screensaver" }, float = true, fullscreen = true, stay_focused = true })
hl.window_rule({
  match = { class = "^(org.gnome.NautilusPreviewer)$" },
  float = true,
  center = true,
  size = { "monitor_w*0.8", "monitor_h*0.9" },
  stay_focused = true,
  dim_around = true,
})

-- GrandOrgue
hl.window_rule({
  name = "Grandorgue Top Bar",
  match = {
    initial_title = "^GrandOrgue v.*",
    initial_class = "GrandOrgue",
  },
  tile = true,
  no_max_size = true,
})

hl.window_rule({
  name = "Grandorgue Tiled Windows",
  match = {
    initial_class = "GrandOrgue",
    -- Matches anything that isn't the Topbar
    initial_title = "negative:^(GrandOrgue v.*|Loading sample set|Program Settings)$",
  },
  tile = true,
})

hl.window_rule({
  name = "Grandorgue Floating Windows",
  match = {
    initial_title = "^(Open organ|Program Settings)$",
    initial_class = "GrandOrgue",
  },
  float = true,
  center = true,
  size = { "monitor_w*0.7", "monitor_h*0.75" },
})

-- Noctalia settings window
hl.window_rule({
  match = { class = "dev.noctalia.Noctalia" },
  float = true,
  size = { 1080, 920 },
})

-- Noctalia blur/animation stuff
hl.layer_rule({
  name = "noctalia",
  match = {
    namespace = "^noctalia-(bar-.+|notification|dock|panel|attached-panel|osd)$",
  },
  no_anim = true,
  ignore_alpha = 0.5,
  blur = true,
  blur_popups = true,
})

-- Prevents screen sleep while any GrandOrgue window is open
hl.window_rule({ match = { class = "GrandOrgue" }, idle_inhibit = "always" })
hl.window_rule({ match = { class = "GrandOrgue" }, workspace = "9" })

-- For Grandorgue layout
hl.workspace_rule({ workspace = "9", layout = "master" })
hl.workspace_rule({ workspace = "9", layout_opts = { orientation = "top" } })

hl.workspace_rule({ workspace = "1", persistent = true })
hl.workspace_rule({ workspace = "2", persistent = true })
hl.workspace_rule({ workspace = "3", persistent = true })
hl.workspace_rule({ workspace = "4", persistent = true })
hl.workspace_rule({ workspace = "5", persistent = true })

-- Move to a hidden workspace and prevent it from stealing focus
hl.window_rule({
  name = "Hide Typora's license popup window",
  match = {
    initial_class = "^Typora$",
    initial_title = "^License Info$",
  },

  workspace = "special:trash silent",
  no_initial_focus = true,
})

-- Vicinae stuff
hl.layer_rule({ blur = true, ignore_alpha = 0, match = { namespace = "vicinae" } })
hl.layer_rule({ no_anim = true, match = { namespace = "vicinae" } })
hl.layer_rule({ match = { namespace = "vicinae" }, dim_around = true })
