local function map(mode, lhs, rhs, opts)
  local keys = require("lazy.core.handler").handlers.keys

  -- do not create keymap if a lazy keys handler exists
  if not keys.active[keys.parse({ lhs, mode = mode }).id] then
    opts = opts or {}
    opts.silent = opts.silent ~= false
    vim.keymap.set(mode, lhs, rhs, opts)
  end
end

map("n", "<leader>gg", function()
  os.execute("zellij run -f -n lazygit --cwd " .. vim.fn.getcwd() .. " -- lazygit")
end, { desc = "Open LazyGit with Zellij" })
