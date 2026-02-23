-- Read the docs: https://www.lunarvim.org/docs/configuration
-- Video Tutorials: https://www.youtube.com/watch?v=sFA9kX-Ud_c&list=PLhoH5vyxr6QqGu0i7tt_XoVK9v-KvZ3m6
-- Forum: https://www.reddit.com/r/lunarvim/
-- Discord: https://discord.com/invite/Xb9B4Ny

vim.o.guifont = "MonaspiceNe Nerd Font Propo:h16"
lvim.transparent_window = true
vim.opt.shiftwidth = 2
vim.opt.tabstop = 4
vim.opt.relativenumber = true
lvim.leader = "space"
lvim.keys.normal_mode["<C-s>"] = ":w<cr>"
-- vim.keymap.del("n", "<C-Up>")
lvim.keys.normal_mode["<S-l>"] = ":bnext<cr>"
lvim.keys.normal_mode["<S-h>"] = ":bprev<cr>"
vim.cmd "let g:neovide_cursor_vfx_mode = \"railgun\""
vim.cmd "let g:neovide_transparency=0.85"
vim.cmd "let g:neovide_refresh_rate=120"
vim.cmd "let g:neovide_refresh_rate_idle=120"
vim.cmd "let g:neovide_floating_blur_amount_x=30"
vim.cmd "let g:neovide_floating_blur_amount_y=30"
vim.cmd "let g:neovide_input_macos_alt_is_meta=v:true"
vim.cmd "let g:comfortable_motion_scroll_down_key = \"j\""
vim.cmd "let g:comfortable_motion_scroll_up_key = \"k\""
vim.cmd "let g:neovide_floating_blur_amount_x = 2.0"
vim.cmd "let g:neovide_floating_blur_amount_y = 2.0"

vim.cmd "let g:closetag_filenames = '*.html,*.ts,*.js,*.jsx,*.tsx'"
vim.cmd "let g:closetag_shortcut = '>'"
vim.cmd ":set linebreak"

vim.g.transparent_background = true        -- transparent background(Default: false)
vim.g.italic_comments = true               -- italic comments(Default: true)
vim.g.italic_keywords = true               -- italic keywords(Default: true)
vim.g.italic_functions = true              -- italic functions(Default: false)
vim.g.italic_variables = true              -- italic variables(Default: false)

lvim.colorscheme="onedark"

lvim.plugins = {
  {
    "lunarvim/colorschemes"
  },
  {
    "phaazon/hop.nvim",
    event = "BufRead",
    config = function()
      require("hop").setup()
      vim.api.nvim_set_keymap("n", "s", ":HopChar2<cr>", { silent = true })
      vim.api.nvim_set_keymap("n", "S", ":HopWord<cr>", { silent = true })
    end,
  },
  -- {
  --   "navarasu/onedark.nvim",
  --   config = function()
  --     require('onedark').setup {
  --       style = 'darker'
  --     }
  --   end,
  -- },
}


