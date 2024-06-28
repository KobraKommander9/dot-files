local M = {}

function M.apply(config)
  -- local docker_domains = require("domains.docker").domains()

  local exec_domains = {}
  -- for _, domain in ipairs(docker_domains) do
  --   table.insert(exec_domains, domain)
  -- end

  config.exec_domains = exec_domains
end

return M
