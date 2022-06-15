--[[
lvim is the global options object

Linters should be
filled in as strings with either
a global executable or a path to
an executable
]]
-- THESE ARE EXAMPLE CONFIGS FEEL FREE TO CHANGE TO WHATEVER YOU WANT

-- general
lvim.log.level = "error"
lvim.format_on_save = true
lvim.colorscheme = "onedark"

-- keymappings [view all the defaults by pressing <leader>Lk]
lvim.leader = "space"
-- add your own keymapping
lvim.keys.normal_mode["<C-s>"] = ":w<cr>"
-- unmap a default keymapping
-- lvim.keys.normal_mode["<C-Up>"] = false
-- edit a default keymapping
-- lvim.keys.normal_mode["<C-q>"] = ":q<cr>"

-- Change Telescope navigation to use j and k for navigation and n and p for history in both input and normal mode.
-- we use protected-mode (pcall) just in case the plugin wasn't loaded yet.
-- local _, actions = pcall(require, "telescope.actions")
-- lvim.builtin.telescope.defaults.mappings = {
--   -- for input mode
--   i = {
--     ["<C-j>"] = actions.move_selection_next,
--     ["<C-k>"] = actions.move_selection_previous,
--     ["<C-n>"] = actions.cycle_history_next,
--     ["<C-p>"] = actions.cycle_history_prev,
--   },
--   -- for normal mode
--   n = {
--     ["<C-j>"] = actions.move_selection_next,
--     ["<C-k>"] = actions.move_selection_previous,
--   },
-- }

-- Use which-key to add extra bindings with the leader-key prefix
-- lvim.builtin.which_key.mappings["P"] = { "<cmd>Telescope projects<CR>", "Projects" }
-- lvim.builtin.which_key.mappings["t"] = {
--   name = "+Trouble",
--   r = { "<cmd>Trouble lsp_references<cr>", "References" },
--   f = { "<cmd>Trouble lsp_definitions<cr>", "Definitions" },
--   d = { "<cmd>Trouble lsp_document_diagnostics<cr>", "Diagnostics" },
--   q = { "<cmd>Trouble quickfix<cr>", "QuickFix" },
--   l = { "<cmd>Trouble loclist<cr>", "LocationList" },
--   w = { "<cmd>Trouble lsp_workspace_diagnostics<cr>", "Diagnostics" },
-- }

-- TODO: User Config for predefined plugins
-- After changing plugin config exit and reopen LunarVim, Run :PackerInstall :PackerCompile
lvim.builtin.alpha.active = true
lvim.builtin.alpha.mode = "dashboard"
lvim.builtin.notify.active = true
lvim.builtin.terminal.active = true
lvim.builtin.nvimtree.setup.view.side = "left"
lvim.builtin.nvimtree.show_icons.git = 0

-- if you don't want all the parsers change this to a table of the ones you want
lvim.builtin.treesitter.ensure_installed = {
  "bash",
  "c",
  "javascript",
  "json",
  "lua",
  "python",
  "typescript",
  "tsx",
  "css",
  "rust",
  "java",
  "yaml",
}

lvim.builtin.treesitter.ignore_install = { "haskell" }
lvim.builtin.treesitter.highlight.enabled = true

-- generic LSP settings

-- ---@usage disable automatic installation of servers
-- lvim.lsp.automatic_servers_installation = false

-- ---@usage Select which servers should be configured manually. Requires `:LvimCacheReset` to take effect.
-- See the full default list `:lua print(vim.inspect(lvim.lsp.override))`
-- vim.list_extend(lvim.lsp.override, { "pyright" })

-- ---@usage setup a server -- see: https://www.lunarvim.org/languages/#overriding-the-default-configuration
-- local opts = {} -- check the lspconfig documentation for a list of all possible options
-- require("lvim.lsp.manager").setup("pylsp", opts)

-- -- you can set a custom on_attach function that will be used for all the language servers
-- -- See <https://github.com/neovim/nvim-lspconfig#keybindings-and-completion>
-- lvim.lsp.on_attach_callback = function(client, bufnr)
--   local function buf_set_option(...)
--     vim.api.nvim_buf_set_option(bufnr, ...)
--   end
--   --Enable completion triggered by <c-x><c-o>
--   buf_set_option("omnifunc", "v:lua.vim.lsp.omnifunc")
-- end

-- -- set a formatter, this will override the language server formatting capabilities (if it exists)
-- local formatters = require "lvim.lsp.null-ls.formatters"
-- formatters.setup {
--   { command = "black", filetypes = { "python" } },
--   { command = "isort", filetypes = { "python" } },
--   {
--     -- each formatter accepts a list of options identical to https://github.com/jose-elias-alvarez/null-ls.nvim/blob/main/doc/BUILTINS.md#Configuration
--     command = "prettier",
--     ---@usage arguments to pass to the formatter
--     -- these cannot contain whitespaces, options such as `--line-width 80` become either `{'--line-width', '80'}` or `{'--line-width=80'}`
--     extra_args = { "--print-with", "100" },
--     ---@usage specify which filetypes to enable. By default a providers will attach to all the filetypes it supports.
--     filetypes = { "typescript", "typescriptreact" },
--   },
-- }

-- -- set additional linters
-- local linters = require "lvim.lsp.null-ls.linters"
-- linters.setup {
--   { command = "flake8", filetypes = { "python" } },
--   {
--     -- each linter accepts a list of options identical to https://github.com/jose-elias-alvarez/null-ls.nvim/blob/main/doc/BUILTINS.md#Configuration
--     command = "shellcheck",
--     ---@usage arguments to pass to the formatter
--     -- these cannot contain whitespaces, options such as `--line-width 80` become either `{'--line-width', '80'}` or `{'--line-width=80'}`
--     extra_args = { "--severity", "warning" },
--   },
--   {
--     command = "codespell",
--     ---@usage specify which filetypes to enable. By default a providers will attach to all the filetypes it supports.
--     filetypes = { "javascript", "python" },
--   },
-- }

-- Additional Plugins
lvim.plugins = {
  { "navarasu/onedark.nvim" },
  { "ellisonleao/glow.nvim" },
  { "iamcco/markdown-preview.nvim" },
  { "folke/tokyonight.nvim" },
  { "lukas-reineke/indent-blankline.nvim" },
  { "AndrewRadev/tagalong.vim" },
  { "tpope/vim-surround" },
  { "rafamadriz/friendly-snippets" },
  { "mattn/emmet-vim" },
  { "karb94/neoscroll.nvim" },
  { "folke/todo-comments.nvim" },
  { "smithbm2316/centerpad.nvim" },
  {
    "folke/trouble.nvim",
    cmd = "TroubleToggle",
  },

}

require("todo-comments").setup {
  -- your configuration comes here
  -- or leave it empty to use the default settings
  -- refer to the configuration section below
}
-- ! HACK
-- Autocommands (https://neovim.io/doc/user/autocmd.html)
-- lvim.autocommands.custom_groups = {
--   { "BufWinEnter", "*.lua", "setlocal ts=8 sw=8" },
-- }

require("neoscroll").setup()

-- Lua
require('onedark').setup {
  -- Main options --
  style = 'dark', -- Default theme style. Choose between 'dark', 'darker', 'cool', 'deep', 'warm', 'warmer' and 'light'
  transparent = true, -- Show/hide background
  term_colors = true, -- Change terminal color as per the selected theme style
  ending_tildes = false, -- Show the end-of-buffer tildes. By default they are hidden
  cmp_itemkind_reverse = false, -- reverse item kind highlights in cmp menu
  -- toggle theme style ---
  toggle_style_key = '<leader>ts', -- Default keybinding to toggle
  toggle_style_list = { 'dark', 'darker', 'cool', 'deep', 'warm', 'warmer', 'light' }, -- List of styles to toggle between

  -- Change code style ---
  -- Options are italic, bold, underline, none
  -- You can configure multiple style with comma seperated, For e.g., keywords = 'italic,bold'
  code_style = {
    comments = 'italic',
    keywords = 'none',
    functions = 'none',
    strings = 'none',
    variables = 'none'
  },

  -- Custom Highlights --
  colors = {}, -- Override default colors
  highlights = {}, -- Override highlight groups

  -- Plugins Config --
  diagnostics = {
    darker = true, -- darker colors for diagnostic
    undercurl = true, -- use undercurl instead of underline for diagnostics
    background = true, -- use background color for virtual text
  },
}

-- require("toggleterm").setup {
-- size can be a number or function which is passed the current terminal
-- size = 20 | function(term)
--   if term.direction == "horizontal" then
--     return 15
--   elseif term.direction == "vertical" then
--     return vim.o.columns * 0.4
--   end
-- end,
-- open_mapping = [[<c-\>]],
-- on_open = fun(t: Terminal), -- function to run when the terminal opens
-- on_close = fun(t: Terminal), -- function to run when the terminal closes
-- on_stdout = fun(t: Terminal, job: number, data: string[], name: string) -- callback for processing output on stdout
-- on_stderr = fun(t: Terminal, job: number, data: string[], name: string) -- callback for processing output on stderr
-- on_exit = fun(t: Terminal, job: number, exit_code: number, name: string) -- function to run when terminal process exits
-- hide_numbers = true, -- hide the number column in toggleterm buffers
-- shade_filetypes = {},
-- highlights = {
-- highlights which map to a highlight group name and a table of it's values
-- NOTE: this is only a subset of values, any group placed here will be set for the terminal window split
--   Normal = {
--     guibg = <VALUE-HERE>,
--   },
--   NormalFloat = {
--     link = 'Normal'
--   },
--   FloatBorder = {
--     guifg = <VALUE-HERE>,
--     guibg = <VALUE-HERE>,
--   },
-- },
-- shade_terminals = true,
-- shading_factor = '<number>', -- the degree by which to darken to terminal colour, default: 1 for dark backgrounds, 3 for light
-- start_in_insert = true,
-- insert_mappings = true, -- whether or not the open mapping applies in insert mode
-- terminal_mappings = true, -- whether or not the open mapping applies in the opened terminals
-- persist_size = false,
-- direction = 'vertical' | 'horizontal' | 'tab' | 'float',
-- close_on_exit = true, -- close the terminal window when the process exits
-- shell = vim.o.shell, -- change the default shell
-- This field is only relevant if direction is set to 'float'
-- float_opts = {
-- The border key is *almost* the same as 'nvim_open_win'
-- see :h nvim_open_win for details on borders however
-- the 'curved' border is a custom border type
-- not natively supported but implemented in this plugin.
--   border = 'single' | 'double' | 'shadow' | 'curved' | ... other options supported by win open
--   width = <value>,
--   height = <value>,
--   winblend = 3,
-- }
-- direction = 'float',
-- }

vim.cmd([[
set wrap
set relativenumber
]])
