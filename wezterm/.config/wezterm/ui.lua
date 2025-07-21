local M = {}

local wezterm = require("wezterm")
local win_utils = require("utils.window")

wezterm.on("update-right-status", win_utils.update_right_status)

--[[
local function background(config)
  local home = os.getenv("HOME")

  config.background = {
    {
      source = {
        File = home .. "/.config/wezterm/images/chaotic_gore_magala.jpeg",
      },
      hsb = {
        brightness = 0.03,
      },
    },
  }
end
--]]

function M.apply(config)
  config.enable_tab_bar = true
  config.tab_bar_at_bottom = true

  config.window_background_opacity = 0.6
  config.initial_rows = 50
  config.initial_cols = 160

  config.font = wezterm.font("GoMono Nerd Font Mono")
  config.font_size = 12.0

  config.color_scheme = "Dark+"
  config.inactive_pane_hsb = {
    saturation = 0.5,
    brightness = 0.4,
  }

  -- background(config)
end

return M
