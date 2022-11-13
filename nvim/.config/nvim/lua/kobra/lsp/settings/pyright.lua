return {
  cmd = {DATA_PATH .. '/lsp_servers/python/node_modules/.bin/pyright-langserver', '--stdio'},
  handlers = {
    ['textDocument/publishDiagnostics'] = vim.lsp.with(vim.lsp.diagnostic.on_publish_diagnostics, {
      virtual_text = {spacing = 0, prefix = ''},
      signs = true,
      underline = true,
      update_in_insert = true,
    }),
  },
  settings = {
    python = {
      analysis = {
        typeCheckingMode = 'basic',
        autoSearchPaths = true,
        useLibraryCodeForTypes = true,
      },
    },
  },
}
