local M = {}

function M.apply(config)
  config.use_dead_keys = false
  config.send_composed_key_when_left_alt_is_pressed = false
  config.send_composed_key_when_right_alt_is_pressed = false
  config.disable_default_key_bindings = true

  local tables = require("keys.tables")

  -- config.leader = { key = "a", mods = "ALT" }
  config.keys = tables.keys()
  config.key_tables = tables.tables()
end

return M
