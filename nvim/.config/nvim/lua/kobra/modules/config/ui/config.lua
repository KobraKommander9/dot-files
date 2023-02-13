local config = {}

function config.notify()
  require('notify').setup({
    stages = 'slide',
    render = 'minimal',
    timeout = 5000,
  })

  require('telescope').load_extension('notify')
end

function config.lualine()
  require('lualine').setup({
    options = {
      theme = 'auto',
    },
  })
end

-- THEME
function config.moonlight()
  vim.g.moonlight_borders = true
  require('moonlight').set()
  vim.cmd 'colorscheme moonlight'
end

function config.nightfox()
  vim.cmd('colorscheme carbonfox')
end

return config