local mason_config = require("kobra.lsp.mason")
local servers = mason_config.servers

mason_config.setup()

local lspconfig_status_ok, lspconfig = pcall(require, "lspconfig")
if not lspconfig_status_ok then
	return
end

local opts = {}

for _, server in pairs(servers) do
	opts = {
		on_attach = require("kobra.lsp.handlers").on_attach,
		capabilities = require("kobra.lsp.handlers").capabilities,
	}

	server = vim.split(server, "@")[1]

	local require_ok, conf_opts = pcall(require, "kobra.lsp.settings." .. server)
	if require_ok then
		opts = vim.tbl_deep_extend("force", conf_opts, opts)
	end

	lspconfig[server].setup(opts)
end

-- change the border of the hover window
local border = {
  {"┏", "FloatBorder"},
  {"━", "FloatBorder"},
  {"┓", "FloatBorder"},
  {"┃", "FloatBorder"},
  {"┛", "FloatBorder"},
  {"━", "FloatBorder"},
  {"┗", "FloatBorder"},
  {"┃", "FloatBorder"},
}

local orig_util_open_floating_preview = vim.lsp.util.open_floating_preview
function vim.lsp.util.open_floating_preview(contents, syntax, options, ...)
  options = options or {}
  options.border = options.border or border
  return orig_util_open_floating_preview(contents, syntax, options, ...)
end
