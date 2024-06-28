local M = {}

local wezterm = require("wezterm")
local mux = wezterm.mux

wezterm.on("gui-startup", function(cmd)
  -- allow `wezterm start -- something` to affect what we spawn
  -- in our initial window
  local args = {}
  if cmd then
    args = cmd.args
  end

  -- Set a workspace for nvim
  local tab, _, _ = mux.spawn_window({
    workspace = "default",
    args = args,
  })

  tab:set_title("default")

  mux.set_active_workspace("default")
end)

return M
