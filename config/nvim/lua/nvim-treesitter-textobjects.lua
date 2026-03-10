local config_module = vim.fn.stdpath("config") .. "/lua/nvim-treesitter-textobjects.lua"

local function load_runtime_module()
  for _, path in ipairs(vim.api.nvim_get_runtime_file("lua/nvim-treesitter-textobjects.lua", true)) do
    if path ~= config_module then
      return dofile(path)
    end
  end

  error("Could not find the runtime nvim-treesitter-textobjects module")
end

local M = load_runtime_module()

if type(M.setup) ~= "function" then
  function M.setup(opts)
    local configs = require("nvim-treesitter.configs")
    if not configs.get_module("textobjects.select") then
      M.init()
    end
    configs.setup({ textobjects = opts })
  end
end

return M
