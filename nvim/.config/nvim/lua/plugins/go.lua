return {
  "neovim/nvim-lspconfig",
  opts = {
    servers = {
      gopls = {
        settings = {
          gopls = {
            env = {
              GOPRIVATE = "git.tcncloud.net",
            },
          },
        },
      },
    },
  },
}
