local config_path = require('kobra.core.global').config_path
local data_dir = require('kobra.core.global').data_path

local modules_dir = config_path .. '/lua/kobra/modules'
local packer_compiled = data_dir .. '/kobra/packer_compiled.lua'
local packer = nil

local Packer = {}
Packer.__index = Packer

function Packer:load_plugins()
  self.repos = {}
  self.rocks = {}

  local get_plugins_list = function()
    local list = {}
    local tmp = vim.split(vim.fn.globpath(modules_dir, '*/plugins.lua'), '\n')
    for _, f in ipairs(tmp) do
      list[#list + 1] = string.match(f, 'lua/(.+).lua$')
    end
    return list
  end

  local plugins_file = get_plugins_list()
  for _, m in ipairs(plugins_file) do
    local repos = require(m)
    for repo, conf in pairs(repos) do
      self.repos[#self.repos + 1] = vim.tbl_extend('force', { repo }, conf)
    end
  end

  self.rocks = require('kobra.modules.rocks')
end

Packer:load_plugins()

function Packer:load_packer()
  if not packer then
    vim.api.nvim_command('packadd packer.nvim')
    packer = require('packer')
  end

  packer.init({
    compile_path = packer_compiled,
    git = { clone_timeout = 240 },
    disable_commands = true,
    max_jobs = 50,
    display = {
      open_fn = function()
	      return require('packer.util').float({ border = 'rounded' })
      end,
    },
    profile = {
      enable = true,
    },
  })
  packer.reset()

  local use = packer.use
  local use_rocks = packer.use_rocks

  self:load_plugins()

  use('wbthomason/packer.nvim')
  use({
    'lewis6991/impatient.nvim',
    config = function() require('impatient') end,
  })

  for _, repo in ipairs(self.repos) do
    use(repo)
  end

  for _, rock in ipairs(self.rocks) do
    use_rocks(rock)
  end
end

function Packer:init_ensure_plugins()
  local packer_dir = data_dir .. '/pack/packer/start/packer.nvim'
  local state = vim.loop.fs_stat(packer_dir)

  if not state then
    local cmd = '!git clone https://github.com/wbthomason/packer.nvim ' .. packer_dir
    vim.api.nvim_command(cmd)
    vim.loop.fs_mkdir(data_dir .. 'lua', 511, function()
      assert('make compile path dir failed')
    end)

    self:load_packer()
    packer.sync()
    return 'installing'
  end

  return 'installed'
end

local plugins = setmetatable({}, {
  __index = function(_, key)
    if not packer then
      Packer:load_packer()
    end
    return packer[key]
  end,
})

function plugins.ensure_plugins()
  return Packer:init_ensure_plugins()
end

function plugins.register_plugin(repo)
  table.insert(Packer.repos, repo)
end

function plugins.compile_notify()
  plugins.compile()
  vim.notify('Compile Done!', 'info', { title = 'Packer' })
end

function plugins.auto_compile()
  local file = vim.fn.expand('%:p')
  if file:match(modules_dir) or file:match(vim.fn.stdpath('config')) then
    plugins.clean()
    plugins.compile()
  end

  vim.cmd([[silent UpdateRemotePlugins]])
  require('kobra.packer_compiled')
end

function plugins.compile_loader()
  plugins.clean()
  plugins.compile()
  vim.cmd([[silent UpdateRemotePlugins]])
end

function plugins.load_compile()
  if vim.fn.filereadable(packer_compiled) == 1 then
    require('kobra.packer_compiled')
  else
    assert('Missing packer compile file Run PackerCompile Or PackerInstall to fix')
    vim.cmd('packadd packer.nvim')
    plugins.compile()
    require('kobra.packer_compiled')
    vim.notify('compile finished successfully wrote to ' .. packer_compiled)
  end
  vim.cmd([[command! PackerCompile lua require('kobra.core.pack').compile_notify()]])
  vim.cmd([[command! PackerInstall lua require('kobra.core.pack').install()]])
  vim.cmd([[command! PackerUpdate lua require('kobra.core.pack').update()]])
  vim.cmd([[command! PackerSync lua require('kobra.core.pack').sync()]])
  vim.cmd([[command! PackerClean lua require('kobra.core.pack').clean()]])
  vim.cmd([[autocmd User PackerComplete lua require('kobra.core.pack').compile()]])
end

return plugins
