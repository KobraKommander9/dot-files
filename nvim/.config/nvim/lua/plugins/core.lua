return {
  {
    "KobraKommander9/KobraVim",
    dev = true,
    version = false,
  },
  {
    "KobraKommander9/vintage-rose.nvim",
    -- dev = true,
    -- opts = {
    -- cache = false,
    -- lush = {
    --   enabled = true,
    -- },
    config = true,
  },
  {
    "KobraKommander9/bookwyrm.nvim",
    -- branch = "setup",
    dev = true,
  },
  {
    "folke/lazydev.nvim",
    opts = {
      library = {
        { path = "bookwyrm", words = { "bookwyrm" } },
      },
    },
  },
}
