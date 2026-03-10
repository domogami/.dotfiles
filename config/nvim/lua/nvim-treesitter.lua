local config_module = vim.fn.stdpath("config") .. "/lua/nvim-treesitter.lua"
local unpack_ = table.unpack or unpack

local function load_runtime_module()
  for _, path in ipairs(vim.api.nvim_get_runtime_file("lua/nvim-treesitter.lua", true)) do
    if path ~= config_module then
      return dofile(path)
    end
  end

  error("Could not find the runtime nvim-treesitter module")
end

local M = load_runtime_module()
local info = require("nvim-treesitter.info")
local install = require("nvim-treesitter.install")
local indent = require("nvim-treesitter.indent")

if type(M.get_installed) ~= "function" then
  function M.get_installed(kind)
    if kind == nil or kind == "parsers" then
      return info.installed_parsers()
    end
    return info.installed_parsers()
  end
end

if type(M.install) ~= "function" then
  function M.install(langs, _opts)
    return {
      await = function(_, cb)
        if type(langs) == "string" then
          install.ensure_installed_sync(langs)
        elseif type(langs) == "table" and #langs > 0 then
          install.ensure_installed_sync(unpack_(langs))
        end

        if cb then
          cb()
        end
      end,
    }
  end
end

if type(M.update) ~= "function" then
  function M.update(langs, _opts)
    local update = install.update({ with_sync = true })
    if langs == nil then
      return update()
    elseif type(langs) == "table" and #langs > 0 then
      return update(unpack_(langs))
    elseif type(langs) == "string" and langs ~= "" then
      return update(langs)
    end
    return update()
  end
end

if type(M.indentexpr) ~= "function" then
  function M.indentexpr()
    return indent.get_indent(vim.v.lnum)
  end
end

return M
