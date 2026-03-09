-- Keymaps are automatically loaded on the VeryLazy event
-- Default keymaps that are always set: https://github.com/LazyVim/LazyVim/blob/main/lua/lazyvim/config/keymaps.lua
-- Add any additional keymaps here

-- DO NOT USE `LazyVim.safe_keymap_set` IN YOUR OWN CONFIG!!
-- use `vim.keymap.set` instead

local map = vim.keymap.set
map("n", "<leader>/", "<cmd>normal gcc<cr>", { desc = "Add Comment" })

-- Window navigation with Option+h/j/k/l, including Neo-tree windows.
pcall(vim.keymap.del, "n", "<A-j>")
pcall(vim.keymap.del, "n", "<A-k>")
pcall(vim.keymap.del, "i", "<A-j>")
pcall(vim.keymap.del, "i", "<A-k>")
pcall(vim.keymap.del, "v", "<A-j>")
pcall(vim.keymap.del, "v", "<A-k>")

map("n", "<A-h>", "<C-w>h", { desc = "Go to left window", remap = true })
map("n", "<A-j>", "<C-w>j", { desc = "Go to lower window", remap = true })
map("n", "<A-k>", "<C-w>k", { desc = "Go to upper window", remap = true })
map("n", "<A-l>", "<C-w>l", { desc = "Go to right window", remap = true })

map("i", "<A-h>", "<Esc><C-w>h", { desc = "Go to left window", remap = true })
map("i", "<A-j>", "<Esc><C-w>j", { desc = "Go to lower window", remap = true })
map("i", "<A-k>", "<Esc><C-w>k", { desc = "Go to upper window", remap = true })
map("i", "<A-l>", "<Esc><C-w>l", { desc = "Go to right window", remap = true })

map("t", "<A-h>", [[<C-\><C-n><C-w>h]], { desc = "Go to left window" })
map("t", "<A-j>", [[<C-\><C-n><C-w>j]], { desc = "Go to lower window" })
map("t", "<A-k>", [[<C-\><C-n><C-w>k]], { desc = "Go to upper window" })
map("t", "<A-l>", [[<C-\><C-n><C-w>l]], { desc = "Go to right window" })
