local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
if not vim.loop.fs_stat(lazypath) then
  vim.fn.system({
    "git",
    "clone",
    "--filter=blob:none",
    "https://github.com/folke/lazy.nvim.git",
    "--branch=stable",
    lazypath,
  })
end
vim.opt.rtp:prepend(vim.env.LAZY or lazypath)

require("lazy").setup({
  spec = {
    {
      "KobraKommander9/KobraVim",
      dev = true,
      branch = "lsp",
      opts = {
        keys = "colemak",
      },
      import = "kobravim.plugins",
    },
    -- import any extras modules here
    { import = "kobravim.plugins.extras.dap" },
    { import = "kobravim.plugins.extras.lang.go" },
    { import = "kobravim.plugins.extras.lang.markdown" },
    { import = "kobravim.plugins.extras.lang.typescript" },
    { import = "kobravim.plugins.extras.lang.wgsl" },
    { import = "kobravim.plugins.extras.neotest" },
    -- import/override with your plugins
    { import = "plugins" },
  },
  dev = {
    path = "~/Projects/nvim",
  },
  defaults = {
    -- By default, only LazyVim plugins will be lazy-loaded. Your custom plugins will load during startup.
    -- If you know what you're doing, you can set this to `true` to have all your custom plugins lazy-loaded by default.
    lazy = true,
    -- It's recommended to leave version=false for now, since a lot the plugin that support versioning,
    -- have outdated releases, which may break your Neovim install.
    version = false, -- always use the latest git commit
    -- version = "*", -- try installing the latest stable version for plugins that support semver
  },
  -- install = { colorscheme = { "autumn" } },
  checker = { enabled = false }, -- automatically check for plugin updates
  performance = {
    rtp = {
      disabled_plugins = {
        "gzip",
        "tarPlugin",
        "tohtml",
        "tutor",
        "zipPlugin",
      },
    },
  },
})
