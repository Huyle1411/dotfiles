-- Options are automatically loaded before lazy.nvim startup
-- Default options that are always set: https://github.com/LazyVim/LazyVim/blob/main/lua/lazyvim/config/options.lua
-- Add any additional options here
vim.opt.clipboard = "unnamedplus"
vim.opt.cmdheight = 1
vim.opt.completeopt = { "menuone", "noselect" }
vim.opt.conceallevel = 2 -- so that `` is visible in markdown files
vim.opt.fileencoding = "utf-8" -- the encoding written to a file
vim.opt.hlsearch = true -- highlight all matches on previous search pattern
vim.opt.ignorecase = true -- ignore case in search patterns
vim.opt.mouse = "a" -- allow the mouse to be used in neovim
vim.opt.pumheight = 10 -- pop up menu height
vim.opt.showmode = false -- we don't need to see things like -- INSERT -- anymore
vim.opt.showtabline = 2 -- always show tabs
vim.opt.smartcase = true -- smart case
vim.opt.smartindent = true -- make indenting smarter again
vim.opt.splitbelow = true -- force all horizontal splits to go below current window
vim.opt.splitright = true -- force all vertical splits to go to the right of current window
vim.opt.swapfile = false -- creates a swapfile
vim.opt.termguicolors = true -- set term gui colors (most terminals support this)
vim.opt.timeoutlen = 500 -- time to wait for a mapped sequence to complete (in milliseconds)
vim.opt.undofile = true -- enable persistent undo
vim.opt.updatetime = 300 -- faster completion (4000ms default)
vim.opt.expandtab = true -- convert tabs to spaces
vim.opt.shiftwidth = 4 -- the number of spaces inserted for each indentation
vim.opt.tabstop = 4 -- insert 2 spaces for a tab
vim.opt.cursorline = false -- highlight the current line
vim.opt.number = true -- set numbered lines
vim.opt.laststatus = 3
vim.opt.showcmd = true
vim.opt.showmatch = true
vim.opt.ruler = true
vim.opt.relativenumber = false
vim.opt.title = true
vim.opt.numberwidth = 4 -- set number column width to 2 {default 4}
vim.opt.signcolumn = "yes" -- always show the sign column, otherwise it would shift the text each time
vim.opt.wrap = false -- display lines as one long line
vim.opt.scrolloff = 8 -- is one of my fav
vim.opt.sidescrolloff = 8
vim.opt.fillchars.eob = " "
-- vim.opt.shortmess:append "c"
-- vim.opt.whichwrap:append("<,>,[,],h,l")
vim.opt.iskeyword:append("-")

vim.cmd([[
  let &errorformat="%f:%l:%c: %t%*[^:]:%m,%f:%l: %t%*[^:]:%m," . &errorformat
]])

vim.cmd([[
  autocmd BufEnter * silent! lcd %:p:h
  let g:neoterm_autoinsert = 1
]])

-- colorscheme
vim.o.background = "light"
-- vim.g.tokyonight_style = "storm"
-- vim.cmd("colorscheme onedark_vivid")
-- vim.api.nvim_set_hl(0, "Normal", { bg = "none" })
-- vim.api.nvim_set_hl(0, "NormalFloat", { bg = "none" })
-- vim.cmd([[
-- let g:airline_theme='dracula'
-- ]])

-- treesitter
-- local status_ok, configs = pcall(require, "nvim-treesitter.configs")
-- if not status_ok then
--   return
-- end
--
-- configs.setup({
--   ensure_installed = { "cpp", "python", "lua" }, -- one of "all" or a list of languages
--   ignore_install = { "" }, -- List of parsers to ignore installing
--   highlight = {
--     enable = true, -- false will disable the whole extension
--   },
--   autopairs = {
--     enable = true,
--   },
--   indent = { enable = true, disable = { "python", "css" } },
-- })

-- python3 env
vim.cmd([[
let g:python3_host_prog = "/usr/bin/python3"
]])

----- Customize for vim-airlines -----
--enable tabline
vim.cmd([[
  let g:airline#extensions#tabline#enabled = 0
  let g:airline_powerline_fonts = 1
]])

-- vim.cmd([[
--   highlight Cursor guifg=white guibg=green
--   highlight iCursor guifg=white guibg=green
--   set guicursor=n-v:block-Cursor
--   set guicursor+=i-c:ver10-iCursor
--   set guicursor+=n-v-c-i:blinkon0
-- ]])
vim.g.vimtex_view_method = "zathura"
-- custome icon youcompleteme
-- vim.cmd([[
-- let g:ycm_error_symbol = ''
-- let g:ycm_warning_symbol = ''
-- let g:ycm_autoclose_preview_window_after_completion = 1
-- let g:ycm_autoclose_preview_window_after_insertion = 1
-- ]])
