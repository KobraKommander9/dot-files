local M = {}

local wezterm = require("wezterm")

function M.apply(config)
  config.use_dead_keys = false
  config.send_composed_key_when_left_alt_is_pressed = false
  config.send_composed_key_when_right_alt_is_pressed = false
  config.disable_default_key_bindings = true

  config.keys = {
    { key = "q", mods = "CMD", action = wezterm.action.QuitApplication },
    { key = "v", mods = "CMD", action = wezterm.action.PasteFrom("Clipboard") },
    { key = "n", mods = "CMD", action = wezterm.action.IncreaseFontSize },
    { key = "e", mods = "CMD", action = wezterm.action.DecreaseFontSize },
  }
end

return M
