if true then
  return {}
end

local M = {}

M[#M + 1] = {
  "neovim/nvim-lspconfig",
  opts = {
    servers = {
      protobufls = {
        mason = false,
        settings = {},
      },
    },
  },
}

return M
