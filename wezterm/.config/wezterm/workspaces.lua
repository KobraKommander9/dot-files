local M = {}

local wezterm = require("wezterm")
local mux = wezterm.mux

wezterm.on("gui-startup", function(cmd)
  local args = {}
  if cmd then
    args = cmd.args
  end

  local dotfiles_path = wezterm.home_dir .. "/.dot-files"
  local _, build_pane, _ = mux.spawn_window({
    workspace = "dotfiles",
    cwd = dotfiles_path,
    args = args,
  })

  build_pane:send_text("nvim .\n")
end)

function M.apply(config)
  config.unix_domains = {
    { name = "unix" },
  }

  config.default_gui_startup_args = { "connect", "unix" }
end

return M
