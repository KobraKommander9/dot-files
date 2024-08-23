if true then
  return {}
end

local M = {}

M[#M + 1] = {
  "https://codeberg.org/esensar/nvim-dev-container",
  cmd = {
    "DevcontainerBuild",
    "DevcontainerImageRun",
    "DevcontainerBuildAndRun",
    "DevcontainerBuildRunAndAttach",
    "DevcontainerComposeUp",
    "DevcontainerComposeDown",
    "DevcontainerComposeRm",
    "DevcontainerStartAuto",
    "DevcontainerStartAutoAndAttach",
    "DevcontainerAttachAuto",
    "DevcontainerStopAuto",
    "DevcontainerStopAll",
    "DevcontainerRemoveAll",
    "DevcontainerLogs",
    "DevcontainerOpenNearestConfig",
    "DevcontainerEditNearestConfig",
  },
  keys = {
    { "<leader>kdb", "<cmd>DevcontainerBuild<cr>", desc = "Build Devcontainer" },
    { "<leader>kdi", "<cmd>DevcontainerImageRun<cr>", desc = "Run Devcontainer Image" },
    { "<leader>kdr", "<cmd>DevcontainerBuildAndRun<cr>", desc = "Build and Run Devcontainer Image" },
    { "<leader>kda", "<cmd>DevcontainerBuildRunAndAttach<cr>", desc = "Build, Run, and Attach to Devcontainer Image" },
    { "<leader>kdu", "<cmd>DevcontainerComposeUp<cr>", desc = "Run docker-compose up" },
    { "<leader>kdd", "<cmd>DevcontainerComposeDown<cr>", desc = "Run docker-compose down" },
    { "<leader>kdR", "<cmd>DevcontainerComposeRm<cr>", desc = "Run docker-compose rm" },
    { "<leader>kds", "<cmd>DevcontainerStartAuto<cr>", desc = "Start Devcontainer" },
    { "<leader>kdS", "<cmd>DevcontainerStartAutoAndAttach<cr>", desc = "Start Devcontainer and Attach" },
    { "<leader>kdA", "<cmd>DevcontainerAttachAuto<cr>", desc = "Attach to Devcontainer" },
    { "<leader>kdx", "<cmd>DevcontainerStopAuto<cr>", desc = "Stop Devcontainer" },
    { "<leader>kdX", "<cmd>DevcontainerStopAll<cr>", desc = "Stop Everything" },
    { "<leader>kdm", "<cmd>DevcontainerRemoveAll<cr>", desc = "Remove Everything" },
    { "<leader>kdl", "<cmd>DevcontainerLogs<cr>", desc = "Open Logs" },
    { "<leader>kdo", "<cmd>DevcontainerOpenNearestConfig<cr>", desc = "Open Nearest Config" },
    { "<leader>kde", "<cmd>DevcontainerEditNearestConfig<cr>", desc = "Edit Nearest Config" },
  },
  opts = {
    attach_mounts = {
      neovim_config = {
        enabled = true,
        options = { "readonly" },
      },
      neovim_data = {
        enabled = false,
        options = {},
      },
      neovim_state = {
        enabled = false,
        options = {},
      },
    },
  },
}

M[#M + 1] = {
  "skanehira/denops-docker.vim",
  dependencies = { "vim-denops/denops.vim" },
}

M[#M + 1] = {
  "kkvh/vim-docker-tools",
  cmd = {
    "DockerToolsOpen",
    "DockerToolsClose",
    "DockerToolsToggle",
    "DockerToolsSetHost",
  },
  keys = {
    { "<leader>kto", "<cmd>DockerToolsOpen<cr>", desc = "Open Docker Tools" },
    { "<leader>ktc", "<cmd>DockerToolsClose<cr>", desc = "Close Docker Tools" },
    { "<leader>ktt", "<cmd>DockerToolsToggle<cr>", desc = "Toggle Docker Tools" },
    { "<leader>kth", "<cmd>DockerToolsSetHost<cr>", desc = "Set Docker Tools Host" },
  },
}

M[#M + 1] = {
  "jamestthompson3/nvim-remote-containers",
  cmd = {
    "AttachToContainer",
    "BuildImage",
    "StartImage",
    "ComposeUp",
    "ComposeDown",
    "ComposeDestroy",
  },
  keys = {
    { "<leader>ka", "<cmd>AttachToContainer<cr>", desc = "Attach to Container" },
    { "<leader>kb", "<cmd>BuildImage<cr>", desc = "Build Image" },
    { "<leader>ks", "<cmd>StartImage<cr>", desc = "Start Image" },
    { "<leader>ku", "<cmd>ComposeUp<cr>", desc = "Start docker-compose" },
    { "<leader>kU", "<cmd>ComposeDown<cr>", desc = "Stop docker-compose" },
    { "<leader>kx", "<cmd>ComposeDestroy<cr>", desc = "Kill docker-compose" },
  },
}

M[#M + 1] = {
  "skywind3000/asyncrun.vim",
  cmd = "AsyncRun",
  config = function()
    vim.g.asyncrun_open = 8
  end,
}

M[#M + 1] = {
  "chipsenkbeil/distant.nvim",
  branch = "v0.2",
  cmd = {
    "DistantInstall",
    "DistantLaunch",
    "DistantOpen",
    "DistantConnect",
    "DistantMetadata",
    "DistantShell",
    "DistantSessionInfo",
    "DistantSystemInfo",
    "DistantClientVersion",
  },
  config = function()
    require("distant").setup({
      ["*"] = require("distant.settings").chip_default(),
    })
  end,
}

M[#M + 1] = {
  "folke/which-key.nvim",
  opts = {
    defaults = {
      ["<leader>k"] = { name = "+containers" },
      ["<leader>kt"] = { name = "+tools" },
      ["<leader>kc"] = { name = "+docker" },
      ["<leader>kd"] = { name = "+devcontainer" },
      ["<leader>kcs"] = { "<cmd>AsyncRun colima start<cr>", "Start Docker" },
      ["<leader>kcd"] = { "<cmd>AsyncRun colima stop<cr>", "Stop Docker" },
    },
  },
}

return M
