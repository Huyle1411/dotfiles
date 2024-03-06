-- Keymaps are automatically loaded on the VeryLazy event
-- Default keymaps that are always set: https://github.com/LazyVim/LazyVim/blob/main/lua/lazyvim/config/keymaps.lua
-- Add any additional keymaps here
local keymap = vim.keymap.set
local opts = { silent = true }

-- vim.opt.makeprg = "cd build && time make"
keymap("n", "<F5>", ":%y+ <CR>", opts)
keymap("i", "<F5>", "<ESC> :%y+ <CR>", opts)
keymap("n", "<F8>", ':w <bar> :TermExec cmd="build %:r" <CR>', opts)
keymap("i", "<F8>", '<ESC> :w <bar> :TermExec cmd="build %:r" <CR>', opts)
keymap("n", "<F9>", ':w <bar> :TermExec cmd="dbrun %:r" <CR>', opts)
keymap("i", "<F9>", '<ESC> :w <bar> :TermExec cmd="dbrun %:r" <CR>', opts)
keymap("n", "<F10>", ':w <bar> :TermExec cmd="runsp %:r" <CR>', opts)
keymap("i", "<F10>", '<ESC> :w <bar> :TermExec cmd="runsp %:r" <CR>', opts)
keymap("n", "A-j", ":m .+1<CR>==", opts)
keymap("n", "A-k", ":m .-2<CR>==", opts)
keymap("i", "A-j", "<Esc>:m .+1<CR>==gi", opts)
keymap("i", "A-k", "<Esc>:m .-2<CR>==gi", opts)
keymap("v", "A-j", ":m '>+1<CR>gv=gv", opts)
keymap("v", "A-k", ":m '<-2<CR>gv=gv", opts)
