-- Keymaps are automatically loaded on the VeryLazy event
-- Default keymaps that are always set: https://github.com/LazyVim/LazyVim/blob/main/lua/lazyvim/config/keymaps.lua
-- Add any additional keymaps here

-- DO NOT USE `LazyVim.safe_keymap_set` IN YOUR OWN CONFIG!!
-- use `vim.keymap.set` instead

local map = vim.keymap.set
map("n", "<leader>/", "<cmd>normal gcc<cr>", { desc = "Add Comment" })
