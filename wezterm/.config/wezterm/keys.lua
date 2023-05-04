local M = {}

function M.apply(config)
  config.use_dead_keys = false
  config.send_composed_key_when_left_alt_is_pressed = false
  config.send_composed_key_when_right_alt_is_pressed = false
  config.use_ime = false
  config.disable_default_key_bindings = true
end

return M
