local server = require("mason-lspconfig.mappings.server")

local M = {
  lspconfig_to_package = server.lspconfig_to_package,
  package_to_lspconfig = server.package_to_lspconfig,
}

function M.get_mason_map()
  return server
end

return M
