local M = {}

local wezterm = require("wezterm")
local act = wezterm.action

function M.keys()
  return {
    -- Application
    { key = "q", mods = "CMD", action = act.QuitApplication },
    { key = "r", mods = "CMD", action = act.ReloadConfiguration },
    {
      key = "R",
      mods = "CMD",
      action = act.Multiple({
        act.ResetTerminal,
        act.SendKey({ key = "Enter" }),
      }),
    },

    -- Window
    { key = "f", mods = "CMD", action = act.ToggleFullScreen },

    -- Clipboard
    { key = "v", mods = "CMD", action = act.PasteFrom("Clipboard") },

    -- Font
    { key = "+", mods = "CMD", action = act.IncreaseFontSize },
    { key = "-", mods = "CMD", action = act.DecreaseFontSize },

    -- Launcher
    { key = "l", mods = "ALT", action = act.ShowLauncherArgs({ flags = "FUZZY|DOMAINS" }) },

    -- Tables
    {
      key = "p",
      mods = "ALT",
      action = act.ActivateKeyTable({
        name = "pane_mode",
        one_shot = false,
        replace_current = true,
      }),
    },
    {
      key = "q",
      mods = "ALT",
      action = act.ActivateKeyTable({
        name = "sessions",
        one_shot = false,
        replace_current = true,
      }),
    },
    {
      key = "s",
      mods = "ALT",
      action = act.ActivateKeyTable({
        name = "scroll",
        one_shot = false,
        replace_current = true,
      }),
    },
    {
      key = "S",
      mods = "ALT",
      action = act.ActivateKeyTable({
        name = "custom_search",
        replace_current = true,
      }),
    },
    {
      key = "t",
      mods = "ALT",
      action = act.ActivateKeyTable({
        name = "tab_mode",
        one_shot = false,
        replace_current = true,
      }),
    },
    {
      key = "w",
      mods = "ALT",
      action = act.ActivateKeyTable({
        name = "win_mode",
        one_shot = false,
        replace_current = true,
      }),
    },
    { key = "y", mods = "ALT", action = act.ActivateCopyMode },
  }
end

function M.tables()
  local copy_mode = nil
  if wezterm.gui then
    copy_mode = wezterm.gui.default_key_tables().copy_mode
    table.insert(copy_mode, { key = "n", action = act.CopyMode("MoveDown") })
    table.insert(copy_mode, { key = "e", action = act.CopyMode("MoveUp") })
    table.insert(copy_mode, { key = "i", action = act.CopyMode("MoveRight") })

    table.insert(copy_mode, { key = "k", action = act.CopyMode("MoveForwardWordEnd") })
  end

  local search_mode = nil
  if wezterm.gui then
    search_mode = wezterm.gui.default_key_tables().search_mode
    table.insert(search_mode, { key = "n", mods = "CTRL", action = act.CopyMode("NextMatch") })
    table.insert(search_mode, { key = "e", mods = "CTRL", action = act.CopyMode("PriorMatch") })

    table.insert(search_mode, { key = "p", mods = "CTRL", action = act.CopyMode("ClearPattern") })

    table.insert(search_mode, { key = "d", mods = "CTRL", action = act.CopyMode("NextMatchPage") })
    table.insert(search_mode, { key = "u", mods = "CTRL", action = act.CopyMode("PriorMatchPage") })

    table.insert(search_mode, { key = "y", mods = "CTRL", action = act.ActivateCopyMode })
  end

  return {
    copy_mode = copy_mode,
    search_mode = search_mode,

    -- scroll
    scroll = {
      -- exit
      { key = "Enter", action = act.PopKeyTable },
      { key = "Escape", action = act.PopKeyTable },

      -- scroll
      { key = "n", action = act.ScrollByLine(1) },
      { key = "e", action = act.ScrollByLine(-1) },
      { key = "d", action = act.ScrollByPage(0.5) },
      { key = "u", action = act.ScrollByPage(-0.5) },
      { key = "g", action = act.ScrollToTop },
      { key = "g", mods = "SHIFT", action = act.ScrollToBottom },
    },

    -- search
    custom_search = {
      -- exit
      { key = "Enter", action = act.PopKeyTable },
      { key = "Escape", action = act.PopKeyTable },

      -- search
      { key = "s", action = act.Search("CurrentSelectionOrEmptyString") },
      { key = "H", action = act.Search({
        Regex = "[a-f0-9]{6,}",
      }) },
    },

    -- sessions
    sessions = {
      -- exit
      { key = "Enter", action = act.PopKeyTable },
      { key = "Escape", action = act.PopKeyTable },

      -- new sessions
      { key = "s", action = act.SwitchToWorkspace },
      {
        key = "S",
        action = act.Multiple({
          act.PopKeyTable,
          act.PromptInputLine({
            description = "Enter new workspace name",
            action = wezterm.action_callback(function(window, pane, line)
              -- line will be `nil` if they hit escape without entering anything
              -- An empty string if they just hit enter
              -- Or the actual line of text they wrote
              if line then
                window:perform_action(act.SwitchToWorkspace({ name = line }), pane)
              end
            end),
          }),
        }),
      },

      -- change sessions
      { key = "n", action = act.SwitchWorkspaceRelative(1) },
      { key = "e", action = act.SwitchWorkspaceRelative(-1) },

      -- find sessions
      {
        key = "f",
        action = act.Multiple({
          act.ClearKeyTableStack,
          act.ShowLauncherArgs({ flags = "FUZZY|WORKSPACES" }),
        }),
      },

      -- rename
      {
        key = "r",
        action = act.Multiple({
          act.PopKeyTable,
          act.PromptInputLine({
            description = "Enter new workspace name",
            action = wezterm.action_callback(function(
              window,
              _, --[[ pane ]]
              line
            )
              -- line will be `nil` if they hit escape without entering anything
              -- An empty string if they just hit enter
              -- Or the actual line of text they wrote
              if line then
                wezterm.mux.rename_workspace(window:active_workspace(), line)
              end
            end),
          }),
        }),
      },
    },

    -- windows
    win_mode = {
      -- exit
      { key = "Enter", action = act.PopKeyTable },
      { key = "Escape", action = act.PopKeyTable },

      -- new windows
      { key = "n", action = act.SpawnWindow },

      -- close windows
      { key = "x", action = act.CloseCurrentTab({ confirm = false }) },

      -- select windows
      { key = "h", action = act.ActivateWindowRelative(-1) },
      { key = "i", action = act.ActivateWindowRelative(1) },
    },

    -- tabs
    tab_mode = {
      -- exit
      { key = "Enter", action = act.PopKeyTable },
      { key = "Escape", action = act.PopKeyTable },

      -- new tabs
      { key = "n", action = act.SpawnTab("CurrentPaneDomain") },
      {
        key = "N",
        action = act.Multiple({
          act.PopKeyTable,
          act.PromptInputLine({
            description = "Enter new tab name",
            action = wezterm.action_callback(function(
              window,
              _, --[[ pane ]]
              line
            )
              -- line will be `nil` if they hit escape without entering anything
              -- An empty string if they just hit enter
              -- Or the actual line of text they wrote
              if line then
                local tab = window:spawn_tab({})
                tab:set_title(line)
              end
            end),
          }),
        }),
      },
      { key = "w", action = act.SpawnWindow },

      -- close tabs
      { key = "x", action = act.CloseCurrentTab({ confirm = false }) },

      -- select tabs
      { key = "h", action = act.ActivateTabRelative(-1) },
      { key = "i", action = act.ActivateTabRelative(1) },

      -- move tabs
      { key = "m", action = act.ActivateKeyTable({
        name = "move_tabs",
        one_shot = false,
      }) },

      -- rename
      {
        key = "r",
        action = act.Multiple({
          act.PopKeyTable,
          act.PromptInputLine({
            description = "Enter new tab name",
            action = wezterm.action_callback(function(
              window,
              _, --[[ pane ]]
              line
            )
              -- line will be `nil` if they hit escape without entering anything
              -- An empty string if they just hit enter
              -- Or the actual line of text they wrote
              if line then
                window:active_tab():set_title(line)
              end
            end),
          }),
        }),
      },
    },

    move_tabs = {
      -- exit
      { key = "Enter", action = act.ClearKeyTableStack },
      { key = "Escape", action = act.PopKeyTable },

      -- move
      { key = "h", action = act.MoveTabRelative(-1) },
      { key = "i", action = act.MoveTabRelative(1) },
    },

    -- panes
    pane_mode = {
      -- exit
      { key = "Enter", action = act.PopKeyTable },
      { key = "Escape", action = act.PopKeyTable },

      -- new panes
      { key = "d", action = act.SplitPane({
        direction = "Down",
        size = { Percent = 50 },
      }) },
      { key = "r", action = act.SplitPane({
        direction = "Right",
        size = { Percent = 50 },
      }) },

      -- select
      { key = "h", action = act.ActivatePaneDirection("Left") },
      { key = "n", action = act.ActivatePaneDirection("Down") },
      { key = "e", action = act.ActivatePaneDirection("Up") },
      { key = "i", action = act.ActivatePaneDirection("Right") },

      -- actions
      { key = "x", action = act.CloseCurrentPane({ confirm = false }) },
      { key = "m", action = act.TogglePaneZoomState },
      {
        key = "=",
        action = act.Multiple({
          act.SendKey({ key = "w", mods = "CTRL" }),
          act.SendKey({ key = "=" }),
        }),
      },

      -- sub actions
      { key = "R", action = act.ActivateKeyTable({
        name = "pane_resize",
        one_shot = false,
      }) },
    },

    pane_resize = {
      -- Escape mode
      { key = "Enter", action = act.ClearKeyTableStack },
      { key = "Escape", action = act.PopKeyTable },

      -- resize
      { key = "h", action = act.AdjustPaneSize({ "Left", 1 }) },
      { key = "H", action = act.AdjustPaneSize({ "Left", 5 }) },
      { key = "n", action = act.AdjustPaneSize({ "Down", 1 }) },
      { key = "N", action = act.AdjustPaneSize({ "Down", 5 }) },
      { key = "e", action = act.AdjustPaneSize({ "Up", 1 }) },
      { key = "E", action = act.AdjustPaneSize({ "Up", 5 }) },
      { key = "i", action = act.AdjustPaneSize({ "Right", 1 }) },
      { key = "I", action = act.AdjustPaneSize({ "Right", 5 }) },
    },
  }
end

return M
