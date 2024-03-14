local M = {}

local wezterm = require("wezterm")

function M.update_right_status(window, pane)
  -- Each element holds the text for a cell in a "powerline" style << fade
  local cells = {}

  -- get current key table
  local key_table = window:active_key_table()
  if key_table then
    table.insert(cells, key_table)
  end

  -- if the pane is zoomed
  local tab = pane:tab()
  if tab then
    for _, p in ipairs(tab:panes_with_info()) do
      if p.is_zoomed then
        table.insert(cells, "ZOOMED")
      end
    end
  end

  -- Figure out the cwd and host of the current pane.
  -- This will pick up the hostname for the remote host if your
  -- shell is using OSC 7 on the remote host.
  local cwd_uri = pane:get_current_working_dir()
  if cwd_uri then
    local hostname = ""

    if type(cwd_uri) == "userdata" then
      -- Running on a newer version of wezterm and we have
      -- a URL object here, making this simple!

      hostname = cwd_uri.host or wezterm.hostname()
    else
      -- an older version of wezterm, 20230712-072601-f4abf8fd or earlier,
      -- which doesn't have the Url object
      cwd_uri = cwd_uri:sub(8)
      local slash = cwd_uri:find("/")
      if slash then
        hostname = cwd_uri:sub(1, slash - 1)
      end
    end

    -- Remove the domain name portion of the hostname
    local dot = hostname:find("[.]")
    if dot then
      hostname = hostname:sub(1, dot - 1)
    end
    if hostname == "" then
      hostname = wezterm.hostname()
    end

    table.insert(cells, hostname)
  end

  -- I like my date/time in this style: "Wed Mar 3 08:14 AM"
  local date = wezterm.strftime("%a %b %-d %I:%M %p")
  table.insert(cells, date)

  -- An entry for each battery (typically 0 or 1 battery)
  for _, b in ipairs(wezterm.battery_info()) do
    table.insert(cells, string.format("%.0f%%", b.state_of_charge * 100))
  end

  -- The filled in variant of the < symbol
  local SOLID_LEFT_ARROW = utf8.char(0xe0b2)

  -- Get scheme colors
  local scheme = wezterm.color.get_builtin_schemes()["Dark+"]
  local bg = wezterm.color.parse(scheme.background)

  -- The elements to be formatted
  local elements = {}
  -- How many cells have been formatted
  local num_cells = 0

  -- Translate a cell into elements
  local function push(text, is_last)
    local cell_no = num_cells + 1
    local color_one = bg:complement_ryb():lighten(0.1 * cell_no)
    local color_two = bg:complement_ryb():lighten(0.1 * (cell_no + 1))

    local r, g, b, _ = color_one:linear_rgba()
    local luma = 0.2126 * r + 0.7152 * g + 0.0722 * b
    local text_color = wezterm.color.parse(luma < 140 and "#fff" or "#000")

    table.insert(elements, { Foreground = { Color = text_color } })
    table.insert(elements, { Background = { Color = color_one } })
    table.insert(elements, { Text = " " .. text .. " " })
    if not is_last then
      table.insert(elements, { Foreground = { Color = color_two } })
      table.insert(elements, { Text = SOLID_LEFT_ARROW })
    end
    num_cells = num_cells + 1
  end

  while #cells > 0 do
    local cell = table.remove(cells, 1)
    push(cell, #cells == 0)
  end

  window:set_right_status(wezterm.format(elements))
end

return M
