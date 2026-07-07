-- ###################
-- ### MY PROGRAMS ###
-- ###################
local terminal = "ghostty +new-window"
local fileManager = "nautilus --new-window"
local browser = "google-chrome-stable"
local notes = "obsidian"
local menu = "vicinae toggle"
local editor = 'ghostty -e "nvim"'
local webapp = "google-chrome-stable --app"
local screenshot = "noctalia msg screenshot-fullscreen"
local screenshotArea = "noctalia msg screenshot-region"

-- Floating TUI apps
local bluetooth = "noctalia msg bluetooth-enable && ghostty --class=com.dominic.bluetui -e bluetui"
local audiomixer = "ghostty --class=com.dominic.wiremix -e wiremix"
local calculator = "ghostty --class=com.dominic.calc -e qalc"
local sysmonitor = "ghostty --class=com.dominic.btop -e btop"
local wifi = "noctalia msg wifi-enable && ghostty --class=com.dominic.impala -e impala"
local power = "ghostty --class=com.dominic.powerbutton -e ~/.local/bin/power-button.sh"
local parabolic = "flatpak run org.nickvision.tubeconverter"

-- ###################
-- ### KEYBINDINGS ###
-- ###################
local mainMod = "SUPER"

-- See https://wiki.hypr.land/Configuring/Binds/
hl.bind(mainMod .. " + space", hl.dsp.exec_cmd(menu))
hl.bind("CTRL + apostrophe", hl.dsp.exec_cmd(menu))
hl.bind("Print", hl.dsp.exec_cmd(screenshot))
hl.bind("SHIFT + Print", hl.dsp.exec_cmd(screenshotArea))
hl.bind(mainMod .. " + TAB", hl.dsp.exec_cmd("noctalia msg session lock"))
hl.bind(mainMod .. " + grave", hl.dsp.exec_cmd("launch-screensaver.sh"))
hl.bind(mainMod .. " + SHIFT + grave", hl.dsp.exec_cmd("launch-screensaver.sh -l"))
hl.bind(mainMod .. " + A", hl.dsp.exec_cmd("noctalia msg notification-clear-active"))
hl.bind(mainMod .. " + SHIFT + A", hl.dsp.exec_cmd("noctalia msg notification-invoke-latest"))
hl.bind(mainMod .. " + B", hl.dsp.exec_cmd(browser))
hl.bind(mainMod .. " + SHIFT + B", hl.dsp.exec_cmd(browser .. " --incognito"))
hl.bind(mainMod .. " + D", hl.dsp.window.fullscreen({ mode = "maximized" }))
hl.bind(mainMod .. " + SHIFT + D", hl.dsp.window.fullscreen({ mode = "fullscreen" }))
hl.bind(mainMod .. " + E", hl.dsp.exec_cmd(bluetooth))
hl.bind(mainMod .. " + SHIFT + F", hl.dsp.exec_cmd("ghostty -e yazi"))
hl.bind(mainMod .. " + F", hl.dsp.exec_cmd(fileManager))
hl.bind(mainMod .. " + G", hl.dsp.window.float({ action = "toggle" }))
hl.bind("ALT + G", hl.dsp.exec_cmd("launch-grandorgue -h"))
hl.bind("ALT + SHIFT + G", hl.dsp.exec_cmd("grandorgue-layout"))
hl.bind(mainMod .. " + I", hl.dsp.exec_cmd(webapp .. '="https://gemini.google.com/app"'))
hl.bind(mainMod .. " + SHIFT + I", hl.dsp.exec_cmd(webapp .. '="https://chatgpt.com"'))
hl.bind("SHIFT + ALT + XF86TouchpadOff", hl.dsp.exec_cmd(webapp .. '="https://gemini.google.com/app"')) -- Copilot Key
hl.bind(mainMod .. " + N", hl.dsp.exec_cmd(notes))
hl.bind(mainMod .. " + O", hl.dsp.layout("togglesplit")) -- dwindle
hl.bind(mainMod .. " + SHIFT + P", hl.dsp.exec_cmd("hyprpicker | wl-copy"))
hl.bind(mainMod .. " + R", hl.dsp.exec_cmd(audiomixer))
hl.bind(mainMod .. " + return", hl.dsp.exec_cmd(terminal))
hl.bind(mainMod .. " + S", hl.dsp.exec_cmd(screenshot))
hl.bind(mainMod .. " + SHIFT + S", hl.dsp.exec_cmd(screenshotArea))
hl.bind(mainMod .. " + T", hl.dsp.exec_cmd(calculator))
hl.bind(mainMod .. " + U", hl.dsp.exec_cmd(sysmonitor))
hl.bind(mainMod .. " + W", hl.dsp.exec_cmd(wifi))
hl.bind(mainMod .. " + SHIFT + W", hl.dsp.exec_cmd("systemctl restart iwd"))
hl.bind(mainMod .. " + X", hl.dsp.window.close())
hl.bind(mainMod .. " + Y", hl.dsp.exec_cmd(parabolic))
hl.bind(mainMod .. " + SHIFT + Y", hl.dsp.exec_cmd(webapp .. '="https://youtube.com/playlist?list=WL"'))
hl.bind(mainMod .. " + Z", hl.dsp.workspace.toggle_special("magic"))
hl.bind(mainMod .. " + SHIFT + Z", hl.dsp.window.move({ workspace = "special:magic" }))

-- Move focus with mainMod SHIFT + hjkl
hl.bind(mainMod .. " + H", hl.dsp.focus({ direction = "l" }))
hl.bind(mainMod .. " + L", hl.dsp.focus({ direction = "r" }))
hl.bind(mainMod .. " + K", hl.dsp.focus({ direction = "u" }))
hl.bind(mainMod .. " + J", hl.dsp.focus({ direction = "d" }))

-- Move  Windows
hl.bind(mainMod .. " + CTRL + h", hl.dsp.window.move({ direction = "l" }))
hl.bind(mainMod .. " + CTRL + l", hl.dsp.window.move({ direction = "r" }))
hl.bind(mainMod .. " + CTRL + k", hl.dsp.window.move({ direction = "u" }))
hl.bind(mainMod .. " + CTRL + j", hl.dsp.window.move({ direction = "d" }))

-- Resize windows
hl.bind(mainMod .. " + right", hl.dsp.window.resize({ x = 40, y = 0, relative = true }), { repeating = true })
hl.bind(mainMod .. " + left", hl.dsp.window.resize({ x = -40, y = 0, relative = true }), { repeating = true })
hl.bind(mainMod .. " + up", hl.dsp.window.resize({ x = 0, y = -40, relative = true }), { repeating = true })
hl.bind(mainMod .. " + down", hl.dsp.window.resize({ x = 0, y = 40, relative = true }), { repeating = true })

--hl.bind(mainMod .. " + period", hl.dsp.layout("move +col"))
--hl.bind(mainMod .. " + comma", hl.dsp.layout("swapcol l"))

-- Switch workspaces with mainMod + [0-9]
hl.bind(mainMod .. " + 1", hl.dsp.focus({ workspace = 1 }))
hl.bind(mainMod .. " + 2", hl.dsp.focus({ workspace = 2 }))
hl.bind(mainMod .. " + 3", hl.dsp.focus({ workspace = 3 }))
hl.bind(mainMod .. " + 4", hl.dsp.focus({ workspace = 4 }))
hl.bind(mainMod .. " + 5", hl.dsp.focus({ workspace = 5 }))
hl.bind(mainMod .. " + 6", hl.dsp.focus({ workspace = 6 }))
hl.bind(mainMod .. " + 7", hl.dsp.focus({ workspace = 7 }))
hl.bind(mainMod .. " + 8", hl.dsp.focus({ workspace = 8 }))
hl.bind(mainMod .. " + 9", hl.dsp.focus({ workspace = 9 }))
hl.bind(mainMod .. " + 0", hl.dsp.focus({ workspace = 10 }))

-- Move active window to a workspace with mainMod + SHIFT + [0-9]
hl.bind(mainMod .. " + SHIFT + 1", hl.dsp.window.move({ workspace = 1 }))
hl.bind(mainMod .. " + SHIFT + 2", hl.dsp.window.move({ workspace = 2 }))
hl.bind(mainMod .. " + SHIFT + 3", hl.dsp.window.move({ workspace = 3 }))
hl.bind(mainMod .. " + SHIFT + 4", hl.dsp.window.move({ workspace = 4 }))
hl.bind(mainMod .. " + SHIFT + 5", hl.dsp.window.move({ workspace = 5 }))
hl.bind(mainMod .. " + SHIFT + 6", hl.dsp.window.move({ workspace = 6 }))
hl.bind(mainMod .. " + SHIFT + 7", hl.dsp.window.move({ workspace = 7 }))
hl.bind(mainMod .. " + SHIFT + 8", hl.dsp.window.move({ workspace = 8 }))
hl.bind(mainMod .. " + SHIFT + 9", hl.dsp.window.move({ workspace = 9 }))
hl.bind(mainMod .. " + SHIFT + 0", hl.dsp.window.move({ workspace = 10 }))

-- Scroll through existing workspaces with mainMod + scroll
hl.bind(mainMod .. " + mouse_down", hl.dsp.focus({ workspace = "e+1" }))
hl.bind(mainMod .. " + mouse_up", hl.dsp.focus({ workspace = "e-1" }))

-- Move/resize windows with mainMod + LMB/RMB and dragging
hl.bind(mainMod .. " + mouse:272", hl.dsp.window.drag(), { mouse = true })
hl.bind(mainMod .. " + mouse:273", hl.dsp.window.resize(), { mouse = true })

-- Multimedia keys for volume and LCD brightness
hl.bind("XF86AudioRaiseVolume", hl.dsp.exec_cmd("noctalia msg volume-up"), { repeating = true, locked = true })
hl.bind("XF86AudioLowerVolume", hl.dsp.exec_cmd("noctalia msg volume-down"), { repeating = true, locked = true })
hl.bind("XF86AudioMute", hl.dsp.exec_cmd("noctalia msg volume-mute"), { repeating = true, locked = true })
hl.bind("XF86AudioMicMute", hl.dsp.exec_cmd("noctalia msg mic-mute"), { repeating = true, locked = true })
hl.bind("XF86MonBrightnessUp", hl.dsp.exec_cmd("noctalia msg brightness-up"), { repeating = true, locked = true })
hl.bind("XF86MonBrightnessDown", hl.dsp.exec_cmd("noctalia msg brightness-down"), { repeating = true, locked = true })
hl.bind("XF86PowerOff", hl.dsp.exec_cmd(power), { repeating = true, locked = true })

-- Media playback
hl.bind("XF86AudioNext", hl.dsp.exec_cmd("noctalia msg media next"), { locked = true })
hl.bind("XF86AudioPrev", hl.dsp.exec_cmd("noctalia msg media previous"), { locked = true })
hl.bind("XF86AudioPause", hl.dsp.exec_cmd("noctalia msg media toggle"), { locked = true })
hl.bind("XF86AudioPlay", hl.dsp.exec_cmd("noctalia msg media toggle"), { locked = true })

--Misc fn keys
hl.bind("XF86Calculator", hl.dsp.exec_cmd(calculator), { repeating = true, locked = true })
hl.bind("XF86Search", hl.dsp.exec_cmd(menu), { repeating = true, locked = true })
