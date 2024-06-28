local M = {}

local wezterm = require("wezterm")

local function docker_list()
  local success, stdout, _ = wezterm.run_child_process({
    "docker container ls --format '{{.ID}}:{{.Names}}'",
  })

  local containers = {}

  if success then
    for _, line in ipairs(stdout:split("\n")) do
      local id, name = line:match("([^:]+):([^:]+)")
      if id and name then
        containers[id] = name
      end
    end
  end

  return containers
end

local function make_docker_fixup_func(id)
  return function(cmd)
    cmd.args = cmd.args or { "/bin/bash" }
    local wrapped = {
      "docker",
      "exec",
      "-it",
      id,
    }

    for _, arg in ipairs(cmd.args) do
      table.insert(wrapped, arg)
    end

    cmd.args = wrapped
    return cmd
  end
end

local function make_docker_label_func(id)
  return function(name)
    local success, stdout, _ = wezterm.run_child_process({
      "docker",
      "container",
      "inspect",
      "-f",
      "{{.State.Status}}",
      id,
    })

    if success and stdout:match("running") then
      return wezterm.format({
        { Foreground = { AnsiColor = "Green" } },
        { Text = "docker container named " .. name },
      })
    end

    return wezterm.format({
      { Foreground = { AnsiColor = "Red" } },
      { Text = "docker container named " .. name .. "(" .. stdout .. ")" },
    })
  end
end

function M.domains()
  local domains = {}

  for id, name in pairs(docker_list()) do
    table.insert(
      domains,
      wezterm.exec_domain("docker: " .. name, make_docker_fixup_func(id), make_docker_label_func(id))
    )
  end

  return domains
end

return M
