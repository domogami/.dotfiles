-- since this is just an example spec, don't actually load anything here and return an empty spec
-- stylua: ignore
if true then return {
  {
    'navarasu/onedark.nvim',
    opts = {
      style = 'dark', -- Default theme style. Choose between 'dark', 'darker', 'cool', 'deep', 'warm', 'warmer' and 'light'
      transparent = false,  -- Show/hide background
      term_colors = true, -- Change terminal color as per the selected theme style
      ending_tildes = false, -- Show the end-of-buffer tildes. By default they are hidden
      cmp_itemkind_reverse = false, -- reverse item kind highlights in cmp menu

      -- toggle theme style ---
      toggle_style_key = nil, -- keybind to toggle theme style. Leave it nil to disable it, or set it to a string, for example "<leader>ts"
      toggle_style_list = {'dark', 'darker', 'cool', 'deep', 'warm', 'warmer', 'light'}, -- List of styles to toggle between

      -- Change code style ---
      -- Options are italic, bold, underline, none
      -- You can configure multiple style with comma separated, For e.g., keywords = 'italic,bold'
      code_style = {
          comments = 'italic',
          keywords = 'none',
          functions = 'none',
          strings = 'none',
          variables = 'none'
      },

      -- Lualine options --
      lualine = {
          transparent = true, -- lualine center bar transparency
      },

      -- Custom Highlights --
      colors = {}, -- Override default colors
      highlights = {}, -- Override highlight groups

      -- Plugins Config --
      diagnostics = {
          darker = true, -- darker colors for diagnostic
          undercurl = true,   -- use undercurl instead of underline for diagnostics
          background = true,    -- use background color for virtual text
      }
    }
  },
  {
    "LazyVim/LazyVim",
    opts = {
      colorscheme = "onedark",
    },
  },
  -- {
  --   "epwalsh/obsidian.nvim",
  --   version = "*",  -- recommended, use latest release instead of latest commit
  --   lazy = true,
  --   ft = "markdown",
  --   -- Replace the above line with this if you only want to load obsidian.nvim for markdown files in your vault:
  --   -- event = {
  --   --   -- If you want to use the home shortcut '~' here you need to call 'vim.fn.expand'.
  --   --   -- E.g. "BufReadPre " .. vim.fn.expand "~" .. "/my-vault/**.md"
  --   --   "BufReadPre path/to/my-vault/**.md",
  --   --   "BufNewFile path/to/my-vault/**.md",
  --   -- },
  --   dependencies = {
  --     -- Required.
  --     "nvim-lua/plenary.nvim",
  --     -- see below for full list of optional dependencies 👇
  --   },
  --   opts = {
  --     workspaces = {
  --       {
  --         name = "personal",
  --         path = "/Users/dom/Library/Mobile Documents/iCloud~md~obsidian/Documents/Dom's 2nd Brain/",
  --       },
  --     },
  --
  --     -- see below for full list of options 👇
  --   },
  -- },
  {
    'MeanderingProgrammer/markdown.nvim',
    name = 'render-markdown', -- Only needed if you have another plugin named markdown.nvim
    dependencies = { 'nvim-treesitter/nvim-treesitter', 'echasnovski/mini.nvim' }, -- if you use the mini.nvim suite
    -- dependencies = { 'nvim-treesitter/nvim-treesitter', 'echasnovski/mini.icons' }, -- if you use standalone mini plugins
    -- dependencies = { 'nvim-treesitter/nvim-treesitter', 'nvim-tree/nvim-web-devicons' }, -- if you prefer nvim-web-devicons
    config = function()
        require('render-markdown').setup({})
    end,
  },
  {
    'yuttie/comfortable-motion.vim'
  }
  -- {
  --     "OXY2DEV/markview.nvim",
  --
  --     dependencies = {
  --         -- You may not need this if you don't lazy load
  --         -- Or if the parsers are in your $RUNTIMEPATH
  --         "nvim-treesitter/nvim-treesitter",
  --         "nvim-tree/nvim-web-devicons"
  --     },
  -- }
  -- Does not work with my font
  -- {
  --     "lukas-reineke/headlines.nvim",
  --     dependencies = "nvim-treesitter/nvim-treesitter",
  --     config = true, -- or `opts = {}`
  -- },
} end

-- every spec file under the "plugins" directory will be loaded automatically by lazy.nvim
--
-- In your plugin files, you can:
-- * add extra plugins
-- * disable/enabled LazyVim plugins
-- * override the configuration of LazyVim plugins
-- return {
--   -- add gruvbox
--   {
--     "navarasu/onedark.nvim",
--   },
--   { "ellisonleao/gruvbox.nvim" },
--
--   -- Configure LazyVim to load gruvbox
--   {
--     "LazyVim/LazyVim",
--     opts = {
--       colorscheme = "gruvbox",
--     },
--   },
--
--   -- change trouble config
--   -- {
--   --   "folke/trouble.nvim",
--   --   -- opts will be merged with the parent spec
--   --   opts = { use_diagnostic_signs = true },
--   -- },
--
--   -- disable trouble
--   { "folke/trouble.nvim", enabled = false },
--
--   -- override nvim-cmp and add cmp-emoji
--   {
--     "hrsh7th/nvim-cmp",
--     dependencies = { "hrsh7th/cmp-emoji" },
--     ---@param opts cmp.ConfigSchema
--     opts = function(_, opts)
--       table.insert(opts.sources, { name = "emoji" })
--     end,
--   },
--
--   -- change some telescope options and a keymap to browse plugin files
--   {
--     "nvim-telescope/telescope.nvim",
--     keys = {
--       -- add a keymap to browse plugin files
--       -- stylua: ignore
--       {
--         "<leader>fp",
--         function() require("telescope.builtin").find_files({ cwd = require("lazy.core.config").options.root }) end,
--         desc = "Find Plugin File",
--       },
--     },
--     -- change some options
--     opts = {
--       defaults = {
--         layout_strategy = "horizontal",
--         layout_config = { prompt_position = "top" },
--         sorting_strategy = "ascending",
--         winblend = 0,
--       },
--     },
--   },
--
--   -- add pyright to lspconfig
--   {
--     "neovim/nvim-lspconfig",
--     ---@class PluginLspOpts
--     opts = {
--       ---@type lspconfig.options
--       servers = {
--         -- pyright will be automatically installed with mason and loaded with lspconfig
--         pyright = {},
--       },
--     },
--   },
--
--   -- add tsserver and setup with typescript.nvim instead of lspconfig
--   {
--     "neovim/nvim-lspconfig",
--     dependencies = {
--       "jose-elias-alvarez/typescript.nvim",
--       init = function()
--         require("lazyvim.util").lsp.on_attach(function(_, buffer)
--           -- stylua: ignore
--           vim.keymap.set( "n", "<leader>co", "TypescriptOrganizeImports", { buffer = buffer, desc = "Organize Imports" })
--           vim.keymap.set("n", "<leader>cR", "TypescriptRenameFile", { desc = "Rename File", buffer = buffer })
--         end)
--       end,
--     },
--     ---@class PluginLspOpts
--     opts = {
--       ---@type lspconfig.options
--       servers = {
--         -- tsserver will be automatically installed with mason and loaded with lspconfig
--         tsserver = {},
--       },
--       -- you can do any additional lsp server setup here
--       -- return true if you don't want this server to be setup with lspconfig
--       ---@type table<string, fun(server:string, opts:_.lspconfig.options):boolean?>
--       setup = {
--         -- example to setup with typescript.nvim
--         tsserver = function(_, opts)
--           require("typescript").setup({ server = opts })
--           return true
--         end,
--         -- Specify * to use this function as a fallback for any server
--         -- ["*"] = function(server, opts) end,
--       },
--     },
--   },
--
--   -- for typescript, LazyVim also includes extra specs to properly setup lspconfig,
--   -- treesitter, mason and typescript.nvim. So instead of the above, you can use:
--   { import = "lazyvim.plugins.extras.lang.typescript" },
--
--   -- add more treesitter parsers
--   {
--     "nvim-treesitter/nvim-treesitter",
--     opts = {
--       ensure_installed = {
--         "bash",
--         "html",
--         "javascript",
--         "json",
--         "lua",
--         "markdown",
--         "markdown_inline",
--         "python",
--         "query",
--         "regex",
--         "tsx",
--         "typescript",
--         "vim",
--         "yaml",
--       },
--     },
--   },
--
--   -- since `vim.tbl_deep_extend`, can only merge tables and not lists, the code above
--   -- would overwrite `ensure_installed` with the new value.
--   -- If you'd rather extend the default config, use the code below instead:
--   {
--     "nvim-treesitter/nvim-treesitter",
--     opts = function(_, opts)
--       -- add tsx and treesitter
--       vim.list_extend(opts.ensure_installed, {
--         "tsx",
--         "typescript",
--       })
--     end,
--   },
--
--   -- the opts function can also be used to change the default opts:
--   {
--     "nvim-lualine/lualine.nvim",
--     event = "VeryLazy",
--     opts = function(_, opts)
--       table.insert(opts.sections.lualine_x, "😄")
--     end,
--   },
--
--   -- or you can return new options to override all the defaults
--   {
--     "nvim-lualine/lualine.nvim",
--     event = "VeryLazy",
--     opts = function()
--       return {
--         --[[add your custom lualine config here]]
--       }
--     end,
--   },
--
--   -- use mini.starter instead of alpha
--   { import = "lazyvim.plugins.extras.ui.mini-starter" },
--
--   -- add jsonls and schemastore packages, and setup treesitter for json, json5 and jsonc
--   { import = "lazyvim.plugins.extras.lang.json" },
--
--   -- add any tools you want to have installed below
--   {
--     "williamboman/mason.nvim",
--     opts = {
--       ensure_installed = {
--         "stylua",
--         "shellcheck",
--         "shfmt",
--         "flake8",
--       },
--     },
--   },
--
--   -- Use <tab> for completion and snippets (supertab)
--   -- first: disable default <tab> and <s-tab> behavior in LuaSnip
--   {
--     "L3MON4D3/LuaSnip",
--     keys = function()
--       return {}
--     end,
--   },
--   -- then: setup supertab in cmp
--   {
--     "hrsh7th/nvim-cmp",
--     dependencies = {
--       "hrsh7th/cmp-emoji",
--     },
--     ---@param opts cmp.ConfigSchema
--     opts = function(_, opts)
--       local has_words_before = function()
--         unpack = unpack or table.unpack
--         local line, col = unpack(vim.api.nvim_win_get_cursor(0))
--         return col ~= 0 and vim.api.nvim_buf_get_lines(0, line - 1, line, true)[1]:sub(col, col):match("%s") == nil
--       end
--
--       local luasnip = require("luasnip")
--       local cmp = require("cmp")
--
--       opts.mapping = vim.tbl_extend("force", opts.mapping, {
--         ["<Tab>"] = cmp.mapping(function(fallback)
--           if cmp.visible() then
--             cmp.select_next_item()
--             -- You could replace the expand_or_jumpable() calls with expand_or_locally_jumpable()
--             -- this way you will only jump inside the snippet region
--           elseif luasnip.expand_or_jumpable() then
--             luasnip.expand_or_jump()
--           elseif has_words_before() then
--             cmp.complete()
--           else
--             fallback()
--           end
--         end, { "i", "s" }),
--         ["<S-Tab>"] = cmp.mapping(function(fallback)
--           if cmp.visible() then
--             cmp.select_prev_item()
--           elseif luasnip.jumpable(-1) then
--             luasnip.jump(-1)
--           else
--             fallback()
--           end
--         end, { "i", "s" }),
--       })
--     end,
--   },
-- }
