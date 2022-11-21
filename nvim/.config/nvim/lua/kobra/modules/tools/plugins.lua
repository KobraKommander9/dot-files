local tools = {}
local conf = require('kobra.modules.tools.config')

tools['kristijanhusak/vim-dadbod-ui'] = {
  cmd = { 'DBUIToggle', 'DBUIAddConnection', 'DBUI', 'DBUIFindBuffer', 'DBUIRenameBuffer', 'DB' },
  config = conf.vim_dadbod_ui,
  requires = { 'tpope/vim-dadbod', ft = { 'sql' } },
  opt = true,
}

tools['editorconfig/editorconfig-vim'] = {
  opt = true,
  cmd = { 'EditorConfigReload' },
}

tools['iamcco/markdown-preview.nvim'] = {
  ft = { 'markdown', 'pandoc.markdown', 'rmd' },
  cmd = { 'MarkdownPreview' },
  setup = conf.mkdp,
  run = [[sh -c "cd app && yarn install"]],
  opt = true,
}

tools['akinsho/toggleterm.nvim'] = {
  cmd = { 'ToggleTerm', 'TermExec' },
  event = { 'CmdwinEnter', 'CmdlineEnter' },
  config = conf.toggleterm,
}

tools['NTBBloodbath/rest.nvim'] = {
  opt = true,
  ft = { 'http' },
  config = conf.rest,
}

tools['liuchengxu/vim-clap'] = {
  cmd = { 'Clap' },
  run = function()
    vim.fn['clap#installer#download_binary']()
  end,
  setup = conf.clap,
  config = conf.clap_after,
}

tools['akinsho/git-conflict.nvim'] = {
  cmd = {
    'GitConflictListQf',
    'GitConflictChooseOurs',
    'GitConflictChooseTheirs',
    'GitConflictChooseBoth',
    'GitConflictNextConflict',
  },
  opt = true,
  config = conf.git_conflict,
}

tools['rbong/vim-flog'] = {
  cmd = { 'Flog', 'Flogsplit' },
  opt = true,
}

tools['tpope/vim-fugitive'] = {
  cmd = { 'Gvsplit', 'Git', 'Gedit', 'Gstatus', 'Gdiffsplit', 'Gvdiffsplit', 'Flog', 'Flogsplit' },
  opt = true,
}

tools['lewis6991/gitsigns.nvim'] = {
  opt = true,
  config = conf.gitsigns,
}

tools['shumphrey/fugitive-gitlab.vim'] = {
  opt = true,
  config = conf.fugitive_gitlab,
}

tools['kevinhwang91/nvim-bqf'] = {
  opt = true,
  event = { 'CmdlineEnter', 'QuickfixCmdPre' },
  config = conf.bqf,
}

tools['ahmedkhalf/project.nvim'] = {
  opt = true,
  after = { 'telescope.nvim' },
  config = conf.project,
}

return tools
