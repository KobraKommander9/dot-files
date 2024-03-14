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
  local tab, term_pane, window = mux.spawn_window({
    workspace = "nvim",
    args = args,
  })

  tab:set_title("nvim")

  local _, nvim_pane, _ = term_pane:split({
    direction = "Top",
    size = 0.8,
  })

  nvim_pane:send_text("nvim\n")

  tab:set_zoomed(true)

  local term_tab, _, _ = window:spawn_tab()
  term_tab:set_title("term")

  mux.set_active_workspace("nvim")
end)

return M
