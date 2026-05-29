-- nvidia
hl.env("LIBVA_DRIVER_NAME", "nvidia")
hl.env("__GLX_VENDOR_LIBRARY_NAME", "nvidia")
hl.env("ELECTRON_OZONE_PLATFORM_HINT", "auto") -- electron apps
hl.env("NVD_BACKEND", "direct") -- VA-API hardware video acceleration

hl.env("XDG_CURRENT_DESKTOP", "Hyprland")
hl.env("XDG_SESSION_TYPE", "wayland")
hl.env("XDG_SESSION_DESKTOP", "Hyprland")

hl.env("XCURSOR_SIZE", "24")
hl.env("HYPRCURSOR_SIZE", "24")
hl.env("SSH_AUTH_SOCK", "$XDG_RUNTIME_DIR/ssh-agent.socket")

hl.monitor({
  output = "DP-2",
  mode = "2560x1440@240",
  position = "2560x0",
  scale = 1,
  transform = 3,
})

hl.monitor({
  output = "DP-3",
  mode = "2560x1440@240",
  position = "0x400",
  scale = 1,
})

hl.on("hyprland.start", function()
  hl.exec_cmd("dbus-update-activation-environment --systemd WAYLAND_DISPLAY XDG_CURRENT_DESKTOP")
  hl.exec_cmd("systemctl --user start hyprpolkitagent")
  hl.exec_cmd("hyprpaper")
  hl.exec_cmd("swaync")
  hl.exec_cmd("waybar")
  hl.exec_cmd("hypridle")
end)

hl.config({
  general = {
    border_size = 2,
    col = {
      active_border = {
        colors = {
          "rgba(33ccffee)",
          "rgba(00ff99ee)",
          angle = 45,
        },
      },
      inactive_border = "rgba(595959aa)",
    },
    gaps_in = 3,
    gaps_out = 10,
    layout = "dwindle",
    resize_on_border = true,
  },
  animations = { enabled = true },
  decoration = {
    blur = {
      enabled = true,
      size = 3,
    },
    rounding = 5,
  },
  dwindle = {
    preserve_split = true,
    force_split = 2,
  },
})

hl.config({
  input = {
    follow_mouse = 2,
    repeat_delay = 200,
    repeat_rate = 30,
  },
})

local function float_rule(c)
  hl.window_rule({
    match = { class = c },
    float = true,
  })
end

float_rule("brave-browser")
float_rule("discord")
float_rule("nautilus")
float_rule("steam")
float_rule("Cidar")
float_rule("btop")
float_rule("GPU")
float_rule("sensors")
float_rule("heroic")
float_rule("minecraft-launcher")
float_rule("Emulator")
float_rule("jetbrains-studio")

hl.window_rule({
  name = "suppress-maximize-events",
  match = { class = ".*" },
  suppress_event = "maximize",
})

local mainMod = "SUPER"

local browser = "brave"
local fileManager = "nautilus"
local menu = "hyprlauncher"
local terminal = "wezterm"

hl.bind(mainMod .. " + B", hl.dsp.exec_cmd(browser))
hl.bind(mainMod .. " + C", hl.dsp.window.close())
hl.bind(mainMod .. " + SHIFT + C", hl.dsp.window.kill())
hl.bind(mainMod .. " + F", hl.dsp.exec_cmd(fileManager))
hl.bind(
  mainMod .. " + M",
  hl.dsp.exec_cmd("command -v hyprshutdown >/dev/null 2>&1 && hyprshutdown || hyprctl dispatch 'hl.dsp.exit()'")
)
hl.bind(mainMod .. " + SHIFT + M", hl.dsp.exit())
hl.bind(mainMod .. " + R", hl.dsp.exec_cmd(menu))
hl.bind(mainMod .. " + SHIFT + R", hl.dsp.exec_cmd("~/.scripts/toggle-recording.sh"))
hl.bind(mainMod .. " + T", hl.dsp.exec_cmd("wezterm start --always-new-process --class btop -- btop"))
hl.bind(
  mainMod .. " + SHIFT + T",
  hl.dsp.exec_cmd("wezterm start --always-new-process --class GPU -- watch nvidia-smi")
)
hl.bind(
  mainMod .. " + ALT + SHIFT + T",
  hl.dsp.exec_cmd("wezterm start --always-new-process --class sensors -- watch sensors")
)
hl.bind(mainMod .. " + Q", hl.dsp.exec_cmd(terminal))
hl.bind(mainMod .. " + V", hl.dsp.window.float({ action = "toggle" }))

hl.bind(mainMod .. " + ALT + H", hl.dsp.focus({ direction = "left" }))
hl.bind(mainMod .. " + ALT + I", hl.dsp.focus({ direction = "right" }))
hl.bind(mainMod .. " + ALT + E", hl.dsp.focus({ direction = "up" }))
hl.bind(mainMod .. " + ALT + N", hl.dsp.focus({ direction = "down" }))

for i = 1, 10 do
  local key = i % 10
  hl.bind(mainMod .. " + " .. key, hl.dsp.focus({ workspace = i }))
  hl.bind(mainMod .. " + SHIFT + " .. key, hl.dsp.window.move({ workspace = i }))
end

hl.bind(mainMod .. " + mouse_down", hl.dsp.focus({ workspace = "e+1" }))
hl.bind(mainMod .. " + mouse_up", hl.dsp.focus({ workspace = "e-1" }))

hl.bind(mainMod .. " + mouse:272", hl.dsp.window.drag(), { mouse = true })
hl.bind(mainMod .. " + mouse:273", hl.dsp.window.resize(), { mouse = true })

hl.bind("XF86AudioStop", hl.dsp.exec_cmd("playerctl play-pause"))
hl.bind("XF86AudioPause", hl.dsp.exec_cmd("playerctl play-pause"))
hl.bind("XF86AudioPlay", hl.dsp.exec_cmd("playerctl play-pause"))
hl.bind("XF86AudioNext", hl.dsp.exec_cmd("playerctl next"))
hl.bind("XF86AudioPrev", hl.dsp.exec_cmd("playerctl previous"))

hl.bind(
  "XF86AudioRaiseVolume",
  hl.dsp.exec_cmd("wpctl set-volume -l 1 @DEFAULT_AUDIO_SINK@ 5%+"),
  { locked = true, repeating = true }
)
hl.bind(
  "XF86AudioLowerVolume",
  hl.dsp.exec_cmd("wpctl set-volume @DEFAULT_AUDIO_SINK@ 5%-"),
  { locked = true, repeating = true }
)
hl.bind(
  "XF86AudioMute",
  hl.dsp.exec_cmd("wpctl set-mute @DEFAULT_AUDIO_SINK@ toggle"),
  { locked = true, repeating = true }
)
hl.bind(
  "XF86AudioMicMute",
  hl.dsp.exec_cmd("wpctl set-mute @DEFAULT_AUDIO_SOURCE@ toggle"),
  { locked = true, repeating = true }
)
