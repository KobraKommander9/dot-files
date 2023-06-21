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
      opts = {
        layouts = {
          colemak = true,
        },
        start_screen = {
          buttons = {
            ["nv"] = { "nvim", "~/dot-files/nvim/.config/nvim" },
            ["fg"] = { "Furious George", "~/fg" },
            ["om"] = { "Omnichannel", "~/Matrix/services/omnichannel" },
          },
          folders = {
            { "Matrix", "~/Matrix" },
            { "Projects", "p", "~/Projects" },
          },
          workspaces = {
            {
              "Matrix Sessions",
              "ms",
              "~/Matrix",
            },
            {
              "Project Sessions",
              "ps",
              "~/Projects/",
            },
            {
              "Dotfile Sessions",
              "ds",
              "~/dot-files/",
            },
          },
        },
      },
      import = "kobra.plugins",
    },
    -- import any extras modules here
    { import = "kobra.plugins.presets.kobra" },
    -- import/override with your plugins
    { import = "plugins" },
  },
  defaults = {
    -- By default, only LazyVim plugins will be lazy-loaded. Your custom plugins will load during startup.
    -- If you know what you're doing, you can set this to `true` to have all your custom plugins lazy-loaded by default.
    lazy = false,
    -- It's recommended to leave version=false for now, since a lot the plugin that support versioning,
    -- have outdated releases, which may break your Neovim install.
    version = false, -- always use the latest git commit
    -- version = "*", -- try installing the latest stable version for plugins that support semver
  },
  install = { colorscheme = { "carbonfox" } },
  checker = { enabled = true }, -- automatically check for plugin updates
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
