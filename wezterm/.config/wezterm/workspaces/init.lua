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

  -- Set a workspace for coding
  local code_tab, build_pane, window = mux.spawn_window({
    workspace = "coding",
    args = args,
  })

  local dev_tab = window:spawn_tab({})
  dev_tab:set_title("dev")

  code_tab:set_title("code")
  local editor_pane = build_pane:split({
    direction = "Top",
    size = 0.5,
  })

  editor_pane:activate()
  code_tab:set_zoomed(true)

  mux.set_active_workspace("coding")
end)

return M
