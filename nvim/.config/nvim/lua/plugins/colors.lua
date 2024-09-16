local M = {}

M[#M + 1] = {
  "ellisonleao/gruvbox.nvim",
  lazy = true,
  config = function()
    vim.o.background = "dark"
  end,
}

M[#M + 1] = {
  "marko-cerovac/material.nvim",
  lazy = true,
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
  lazy = true,
  config = function()
    vim.g.afterglow_italic_comments = 1
  end,
}

M[#M + 1] = {
  "romainl/flattened",
  lazy = true,
}

M[#M + 1] = {
  "bluz71/vim-moonfly-colors",
  lazy = true,
  name = "moonfly",
}

M[#M + 1] = {
  "nyoom-engineering/oxocarbon.nvim",
  lazy = true,
}

M[#M + 1] = {
  "glepnir/zephyr-nvim",
  lazy = true,
}

M[#M + 1] = {
  "theniceboy/nvim-deus",
  lazy = true,
}

M[#M + 1] = {
  "yonlu/omni.vim",
  lazy = true,
}

M[#M + 1] = {
  "tanvirtin/monokai.nvim",
  lazy = true,
}

M[#M + 1] = {
  "Mofiqul/dracula.nvim",
  lazy = true,
  opts = {
    transparent_bg = true,
  },
}

return M
