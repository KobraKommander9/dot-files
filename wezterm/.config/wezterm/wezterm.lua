local wezterm = require("wezterm")

local config = {}

if wezterm.config_builder then
  config = wezterm.config_builder()
end

require("keys.config").apply(config)
require("ui").apply(config)
require("workspaces").apply(config)

config.term = "wezterm"

return config
