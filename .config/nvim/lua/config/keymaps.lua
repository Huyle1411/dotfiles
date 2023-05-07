-- Keymaps are automatically loaded on the VeryLazy event
-- Default keymaps that are always set: https://github.com/LazyVim/LazyVim/blob/main/lua/lazyvim/config/keymaps.lua
-- Add any additional keymaps here
local keymap = vim.keymap.set
local opts = { silent = true }

vim.opt.makeprg = "cd build && time make"
keymap("n", "<F5>", ":%y+ <CR>", opts)
keymap("i", "<F5>", "<ESC> :%y+ <CR>", opts)
vim.cmd([[
" autocmd filetype cpp nnoremap <F9> :w <bar> make %:r <CR>
" autocmd filetype cpp inoremap <F9> <ESC> :w <bar> make %:r <CR>
autocmd filetype cpp nnoremap <F9> :w <bar> :TermExec cmd="cd %:p:h/build && time make %:r" go_back=1 <CR>
autocmd filetype cpp inoremap <F9> <ESC> :w <bar> :TermExec cmd="cd %:p:h/build && time make %:r" go_back=1 <CR>
autocmd filetype cpp nnoremap <F8> :TermExec cmd="cd %:p:h/build && run_solution.sh %:r" go_back=0 <CR> <CR>
autocmd filetype cpp nnoremap <F10> :w <bar> :TermExec cmd="cd %:p:h && test_solution.sh %:r cpp" go_back=1 <CR>
autocmd filetype python nnoremap <F9> :w <bar> :TermExec cmd="cd %:p:h && pypy3 -W ignore %:r.py < input" go_back=0 <CR>
autocmd filetype python inoremap <F9> <ESC> :w <bar> :TermExec cmd="cd %:p:h && pypy3 -W ignore %:r.py < input" go_back=0 <CR>
autocmd filetype python nnoremap <F10> :w <bar> :TermExec cmd="cd %:p:h && test_solution.sh %:r python" go_back=1 <CR>
]])
