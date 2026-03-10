-- Keymaps are automatically loaded on the VeryLazy event
-- Default keymaps that are always set: https://github.com/LazyVim/LazyVim/blob/main/lua/lazyvim/config/keymaps.lua
-- Add any additional keymaps here

-- DO NOT USE `LazyVim.safe_keymap_set` IN YOUR OWN CONFIG!!
-- use `vim.keymap.set` instead

local map = vim.keymap.set
map("n", "<leader>/", "<cmd>normal gcc<cr>", { desc = "Add Comment" })

local function with_smart_splits(method)
  return function()
    require("smart-splits")[method]()
  end
end

local function with_smart_splits_from_insert(method)
  return function()
    vim.cmd.stopinsert()
    vim.schedule(with_smart_splits(method))
  end
end

local function with_smart_splits_from_terminal(method)
  return function()
    local esc = vim.api.nvim_replace_termcodes("<C-\\><C-n>", true, false, true)
    vim.api.nvim_feedkeys(esc, "n", false)
    vim.schedule(with_smart_splits(method))
  end
end

local function previous_window()
  vim.cmd.wincmd("p")
end

local function previous_window_from_insert()
  vim.cmd.stopinsert()
  vim.schedule(previous_window)
end

local function previous_window_from_terminal()
  local esc = vim.api.nvim_replace_termcodes("<C-\\><C-n>", true, false, true)
  vim.api.nvim_feedkeys(esc, "n", false)
  vim.schedule(previous_window)
end

-- Window navigation with Option+h/j/k/l, including tmux panes via smart-splits.
pcall(vim.keymap.del, "n", "<A-j>")
pcall(vim.keymap.del, "n", "<A-k>")
pcall(vim.keymap.del, "i", "<A-j>")
pcall(vim.keymap.del, "i", "<A-k>")
pcall(vim.keymap.del, "v", "<A-j>")
pcall(vim.keymap.del, "v", "<A-k>")

map("n", "<A-h>", with_smart_splits("move_cursor_left"), { desc = "Go to left window" })
map("n", "<A-j>", with_smart_splits("move_cursor_down"), { desc = "Go to lower window" })
map("n", "<A-k>", with_smart_splits("move_cursor_up"), { desc = "Go to upper window" })
map("n", "<A-l>", with_smart_splits("move_cursor_right"), { desc = "Go to right window" })
map("n", "<A-o>", previous_window, { desc = "Go to previous window" })

map("i", "<A-h>", with_smart_splits_from_insert("move_cursor_left"), { desc = "Go to left window" })
map("i", "<A-j>", with_smart_splits_from_insert("move_cursor_down"), { desc = "Go to lower window" })
map("i", "<A-k>", with_smart_splits_from_insert("move_cursor_up"), { desc = "Go to upper window" })
map("i", "<A-l>", with_smart_splits_from_insert("move_cursor_right"), { desc = "Go to right window" })
map("i", "<A-o>", previous_window_from_insert, { desc = "Go to previous window" })

map("t", "<A-h>", with_smart_splits_from_terminal("move_cursor_left"), { desc = "Go to left window" })
map("t", "<A-j>", with_smart_splits_from_terminal("move_cursor_down"), { desc = "Go to lower window" })
map("t", "<A-k>", with_smart_splits_from_terminal("move_cursor_up"), { desc = "Go to upper window" })
map("t", "<A-l>", with_smart_splits_from_terminal("move_cursor_right"), { desc = "Go to right window" })
map("t", "<A-o>", previous_window_from_terminal, { desc = "Go to previous window" })

map("n", "<A-H>", with_smart_splits("resize_left"), { desc = "Resize split left" })
map("n", "<A-J>", with_smart_splits("resize_down"), { desc = "Resize split down" })
map("n", "<A-K>", with_smart_splits("resize_up"), { desc = "Resize split up" })
map("n", "<A-L>", with_smart_splits("resize_right"), { desc = "Resize split right" })
