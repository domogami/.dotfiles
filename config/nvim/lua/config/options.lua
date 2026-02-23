-- Options are automatically loaded before lazy.nvim startup
-- Default options that are always set: https://github.com/LazyVim/LazyVim/blob/main/lua/lazyvim/config/options.lua
-- Add any additional options here

vim.opt.winbar = "%=%m %f"

vim.cmd("xnoremap p pgvy")
vim.cmd('let g:neovide_cursor_vfx_mode = "railgun"')
vim.cmd("let g:neovide_refresh_rate=120")
vim.cmd('let g:comfortable_motion_scroll_down_key = "j"')
vim.cmd('let g:comfortable_motion_scroll_up_key = "k"')
vim.cmd("let g:neovide_floating_blur_amount_x = 2.0")
vim.cmd("let g:neovide_input_macos_option_key_is_meta = 'both'")
vim.cmd("let g:neovide_no_idle = v:true")
vim.cmd("let g:neovide_cursor_vfx_particle_density=10.0")
vim.cmd("let g:neovide_cursor_vfx_particle_speed=20.0")

if vim.g.neovide then
    vim.opt.guifont = "FiraCode Nerd Font Propo:h14"
    -- vim.opt.guifont = "MonaspiceNe Nerd Font Propo:h14"
    -- vim.opt.guifont = "Hack Nerd Font Propo:h16"
    vim.g.neovide_scale_factor = 1
end
