-- Shorten function name
local keymap = vim.keymap.set
-- Silent keymap option
local opts = { silent = true }

--Remap space as leader key
keymap("", "<Space>", "<Nop>", opts)
vim.g.mapleader = " "
vim.g.maplocalleader = ","

-- Modes
--   normal_mode = "n",
--   insert_mode = "i",
--   visual_mode = "v",
--   visual_block_mode = "x",
--   term_mode = "t",
--   command_mode = "c",

-- Normal --
-- Better window navigation
keymap("n", "<C-h>", "<C-w>h", opts)
keymap("n", "<C-j>", "<C-w>j", opts)
keymap("n", "<C-k>", "<C-w>k", opts)
keymap("n", "<C-l>", "<C-w>l", opts)

--- Navigate buffers
keymap("n", "<S-l>", ":bnext<CR>", opts)
keymap("n", "<S-h>", ":bprevious<CR>", opts)

-- Close buffers
keymap("n", "<S-q>", "<cmd>Bdelete!<CR>", opts)

-- Stay in indent mode
keymap("v", "<", "<gv", opts)
keymap("v", ">", ">gv", opts)

-- NvimTree
keymap("n", "<leader>e", ":NvimTreeToggle<CR>", opts)

-- Map <CR> to :nohl, except in quickfix windows
vim.cmd([[nnoremap <silent> <expr> <CR> &buftype ==# 'quickfix' ? "\<CR>" : ":nohl\<CR>"]])

-- tnoremap <silent> <C-[><C-[> <C-\><C-n>
keymap("t", "<ESC>", "<C-\\><C-n>", opts)

--Compile and run
vim.opt.makeprg = "cd build && time make"
keymap("n", "<F5>", ":%y+ <CR>", opts)
keymap("i", "<F5>", "<ESC> :%y+ <CR>", opts)
-- keymap("n", "<F8>", ":vert T cd build && ./%:r <CR>", opts)
-- keymap("n", "<F8>", ":TermExec cmd=\"./../build/%:r\" go_back=0 <CR>", opts)
-- keymap("n", "<F9>", ":w <bar> Make %:r <CR>", opts)
-- keymap("i", "<F9>", "<ESC> :w <bar> Make %:r <CR>", opts)
-- keymap("n", "<F10>", '<ESC> :w <bar> :TermExec cmd="run_problem.sh %:r" go_back=0 <CR>', opts)
keymap("n", "<F7>", "<ESC> :CompetiTestRunNC <CR>", opts)

vim.cmd([[
autocmd filetype cpp nnoremap <F9> :w <bar> Make %:r <CR>
autocmd filetype cpp inoremap <F9> <ESC> :w <bar> Make %:r <CR>
autocmd filetype cpp nnoremap <F8> :TermExec cmd="./build/%:r" go_back=0 <CR>
autocmd filetype cpp nnoremap <F10> :TermExec cmd="run_problem.sh %:r cpp" go_back=0 <CR>
autocmd filetype python nnoremap <F9> :w <bar> :TermExec cmd="pypy3 -W ignore %:r.py < input" go_back=0 <CR>
autocmd filetype python inoremap <F9> <ESC> :w <bar> :TermExec cmd="pypy3 -W ignore %:r.py < input" go_back=0 <CR>
autocmd filetype python nnoremap <F10> :TermExec cmd="run_problem.sh %:r python" go_back=0 <CR>
]])

keymap("n", "<leader>c", ":%y+ <CR>", opts)
-- keymap("n", "<leader>r", ":vert T cd build && ./%:r <CR>", opts)
-- keymap("n", "<leader>r", ":TermExec cmd=\"./%:r\" dir=build <CR>", opts)
-- keymap("n", "<leader>b", ":w <bar> Make <CR>", opts)
-- keymap("n", "<leader>t", ":vert T h -t <CR>", opts)
-- keymap("n", "<leader>t", ":TermExec cmd=\"h %:r -t\" go_back=0 <CR>", opts)

-- NvimTree
keymap("n", "<leader>e", ":NvimTreeToggle<CR>", opts)

-- youcompleteme
keymap("n", "<leader>yy", ":YcmCompleter GoTo<CR>", opts)
keymap("n", "<leader>yr", ":YcmCompleter GoToReferences<CR>", opts)
keymap("n", "<leader>yd", ":YcmDiags<CR>", opts)
keymap("n", "<leader>yf", ":YcmCompleter FixIt<CR>", opts)
keymap("n", "<leader>y:", ":YcmCompleter<Space>", opts)

-- Telescope
keymap("n", "<leader>ff", ":Telescope find_files<CR>", opts)
keymap("n", "<leader>ft", ":Telescope live_grep<CR>", opts)
keymap("n", "<leader>fp", ":Telescope projects<CR>", opts)
keymap("n", "<leader>fb", ":Telescope buffers<CR>", opts)
