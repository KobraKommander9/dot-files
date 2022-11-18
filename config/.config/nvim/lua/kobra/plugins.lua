local fn = vim.fn

-- Automatically install packer
local install_path = fn.stdpath('data') .. '/site/pack/packer/start/packer.nvim'
if fn.empty(fn.glob(install_path)) > 0 then
  PACKER_BOOTSTRAP = fn.system({
    'git',
    'clone',
    '--depth',
    '1',
    'https://github.com/wbthomason/packer.nvim',
    install_path,
  })
  print('Installing packer; close and reopen Neovim...')
  vim.cmd([[packadd packer.nvim]])
end

-- Autocommand that reloads neovim whenever you save the plugins.lua file
vim.cmd([[
  augroup packer_user_config
    autocmd!
    autocmd BufWritePost plugins.lua source <afile> | PackerSync
  augroup end
]])

-- Use a protected call so we don't error out on first use
local status_ok, packer = pcall(require, 'packer')
if not status_ok then
  return
end

-- Have packer use a popup window
packer.init({
  max_jobs = 50,
  display = {
    open_fn = function()
      return require('packer.util').float({ border = 'rounded' })
    end,
  },
})

-- Install plugins
return packer.startup(function(use)
  use('wbthomason/packer.nvim') -- manage packer itself
  use('nvim-lua/popup.nvim') -- common dependency
  use('nvim-lua/plenary.nvim') -- common dependency

  -- Formatting
  use('tpope/vim-sleuth')
  use('tpope/vim-repeat')
  use('tpope/vim-rhubarb')
  use({ 'editorconfig/editorconfig-vim', config = [[require('kobra.config.editorconfig')]] })

  -- Navigation
  use({ 'jdhao/better-escape.vim', event = 'InsertEnter' })
  use({ 'ggandor/leap.nvim', config = [[require('kobra.config.leap')]] })
  use({ 'karb94/neoscroll.nvim', config = [[require('kobra.config.neoscroll')]] })

  -- Terminal
  use({ 'akinsho/toggleterm.nvim', config = [[require('kobra.config.toggleterm')]] })

  -- Syntax
  use({ 'nvim-treesitter/nvim-treesitter', run = ':TSUpdate', config = [[require('kobra.config.treesitter')]] })
  use('nvim-treesitter/nvim-treesitter-refactor')
  use('nvim-treesitter/nvim-treesitter-context')
  use('nvim-treesitter/playground')
  use({ 'terrortylor/nvim-comment', config = [[require('kobra.config.comment')]] })
  use('JoosepAlviste/nvim-ts-context-commentstring')
  use('fladson/vim-kitty')

  -- Git
  use('airblade/vim-gitgutter')
  use('f-person/git-blame.nvim')
  use('sindrets/diffview.nvim')
  use({
    'shumphrey/fugitive-gitlab.vim',
    requires = 'tpope/vim-fugitive',
    config = [[require('kobra.config.fugitive')]],
  })
  use('kdheepak/lazygit.nvim')

  -- Completion
  use('f3fora/cmp-spell')
  use('David-Kunz/cmp-npm')
  use('saadparwaiz1/cmp_luasnip')
  use('hrsh7th/cmp-nvim-lsp-signature-help')
  use('hrsh7th/cmp-nvim-lsp')
  use('hrsh7th/cmp-nvim-lua')
  use('hrsh7th/cmp-buffer')
  use('hrsh7th/cmp-path')
  use('hrsh7th/cmp-cmdline')
  use('hrsh7th/cmp-calc')
  use({ 'hrsh7th/nvim-cmp', config = [[require('kobra.config.cmp')]] })

  -- Matchings
  use({ 'windwp/nvim-autopairs', config = [[require('kobra.config.autopairs')]] })
  use('windwp/nvim-ts-autotag')
  use({ 'andymass/vim-matchup', config = [[require('kobra.config.matchup')]] })
  use({ 'RRethy/nvim-treesitter-endwise', config = [[require('kobra.config.endwise')]] })
  -- uncomment next line for indent visualization
  -- use({'lukas-reineke/indent-blankline.nvim', config = [[require('kobra.config.indent')]]})

  -- LSP
  use({
    'williamboman/mason.nvim',
    'williamboman/mason-lspconfig.nvim',
    'neovim/nvim-lspconfig',
  })
  use({ 'jose-elias-alvarez/null-ls.nvim', after = 'mason.nvim' })
  use({
    'jayp0521/mason-null-ls.nvim',
    after = 'null-ls.nvim',
    config = [[require('kobra.lsp')]],
  })
  use({ 'ray-x/lsp_signature.nvim', config = [[require('kobra.config.signature')]] })
  -- TODO: maybe figure out how to get the highlight color to work with my color scheme
  -- use('RRethy/vim-illuminate')
  use('onsails/lspkind.nvim')
  use({'j-hui/fidget.nvim', config = [[require('kobra.config.fidget')]]})
  use({'simrat39/symbols-outline.nvim', config = [[require('kobra.config.symbols-outline')]]})
  use({'weilbith/nvim-code-action-menu', cmd = 'CodeActionMenu'})

  -- DAP
  use('mfussenegger/nvim-dap')
  use('theHamsta/nvim-dap-virtual-text')
  use('rcarriga/nvim-dap-ui')
  use('nvim-telescope/telescope-dap.nvim')
  use('leoluz/nvim-dap-go')
  use('suketa/nvim-dap-ruby')
  use({
    'mxsdev/nvim-dap-vscode-js',
    opt = true,
    run = 'npm i --legacy-peer-deps && npm run compile',
  })

  -- Snippets
  use('L3MON4D3/LuaSnip')
  use('rafamadriz/friendly-snippets')

  -- Telescope
  use({ 'nvim-telescope/telescope.nvim', config = [[require('kobra.config.telescope')]] })
  use('nvim-telescope/telescope-fzy-native.nvim')
  use('nvim-telescope/telescope-media-files.nvim')
  use('BurntSushi/ripgrep')

  -- Tree
  use({
    'kyazdani42/nvim-tree.lua',
    requires = 'kyazdani42/nvim-web-devicons',
    config = [[require('kobra.config.nvim-tree')]],
  })

  -- Buffers
  use({ 'beauwilliams/focus.nvim', config = [[require('kobra.config.focus')]] })
  use({ 'romgrk/barbar.nvim', config = [[require('kobra.config.barbar')]] })

  -- Database
  use('tpope/vim-dadbod')
  use('kristijanhusak/vim-dadbod-ui')
  use('kristijanhusak/vim-dadbod-completion')

  -- Rest
  use({ 'NTBBloodbath/rest.nvim', config = [[require('kobra.config.rest')]] })

  -- Go
  use({
    'ray-x/go.nvim',
    config = [[require('kobra.config.go')]],
  })
  use('ray-x/guihua.lua')

  -- Colors
  use('sainnhe/sonokai')
  use('shaunsingh/moonlight.nvim')

  -- Start up
  use('lewis6991/impatient.nvim')
  use('dstein64/vim-startuptime')

  -- UI
  use('MunifTanjim/nui.nvim')

  -- Other
  use({ 'nvim-lualine/lualine.nvim', config = [[require('kobra.config.lualine')]] })
  use({ 'folke/which-key.nvim', config = [[require('kobra.config.whichkey')]] })
  use({ 'windwp/nvim-spectre', config = [[require('kobra.config.spectre')]] })
  use({ 'ThePrimeagen/refactoring.nvim', config = [[require('kobra.config.refactoring')]] })
  use({ 'norcalli/nvim-colorizer.lua', config = [[require('kobra.config.colorizer')]] })
  use({
    "iamcco/markdown-preview.nvim",
    run = [[vim.fn["mkdp#util#install"]()]],
    setup = function()
      vim.g.mkdp_filetypes = { 'markdown' }
    end,
    ft = { 'markdown' },
  })
  use({ 'rcarriga/nvim-notify', config = [[require('kobra.config.notify')]] })
  use({ 'Pocco81/AbbrevMan.nvim', config = [[require('kobra.config.abbrevman')]] })

  -- Automatically set up your configuration after cloning packer.nvim
  -- Put this at the end after all plugins
  if PACKER_BOOTSTRAP then
    require("packer").sync()
  end
end)