local M = {}

M[#M + 1] = {
  "ellisonleao/gruvbox.nvim",
  config = function()
    vim.o.background = "dark"
  end,
}

M[#M + 1] = {
  "marko-cerovac/material.nvim",
  opts = {
    plugins = {
      "dap",
      "gitsigns",
      "mini",
      "nvim-cmp",
      "nvim-navic",
      "nvim-web-devicons",
      "telescope",
      "which-key",
    },
  },
  config = function(_, opts)
    require("material").setup(opts)
    vim.g.material_style = "deep ocean"
  end,
}

M[#M + 1] = {
  "danilo-augusto/vim-afterglow",
  config = function()
    vim.g.afterglow_italic_comments = 1
  end,
}

M[#M + 1] = {
  "romainl/flattened",
}

M[#M + 1] = {
  "bluz71/vim-moonfly-colors",
  name = "moonfly",
}

M[#M + 1] = {
  "nyoom-engineering/oxocarbon.nvim",
}

M[#M + 1] = {
  "glepnir/zephyr-nvim",
}

M[#M + 1] = {
  "theniceboy/nvim-deus",
}

M[#M + 1] = {
  "yonlu/omni.vim",
}

M[#M + 1] = {
  "tanvirtin/monokai.nvim",
}

M[#M + 1] = {
  "Mofiqul/dracula.nvim",
}

return M
