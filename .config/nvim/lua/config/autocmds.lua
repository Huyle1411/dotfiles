-- Autocmds are automatically loaded on the VeryLazy event
-- Default autocmds that are always set: https://github.com/LazyVim/LazyVim/blob/main/lua/lazyvim/config/autocmds.lua
-- Add any additional autocmds here
-- change the highlight style
vim.api.nvim_set_hl(0, "IlluminatedWordText", { link = "Visual" })
vim.api.nvim_set_hl(0, "IlluminatedWordRead", { link = "Visual" })
vim.api.nvim_set_hl(0, "IlluminatedWordWrite", { link = "Visual" })

--- auto update the highlight style on colorscheme change
vim.api.nvim_create_autocmd({ "ColorScheme" }, {
  pattern = { "*" },
  callback = function(ev)
    vim.api.nvim_set_hl(0, "IlluminatedWordText", { link = "Visual" })
    vim.api.nvim_set_hl(0, "IlluminatedWordRead", { link = "Visual" })
    vim.api.nvim_set_hl(0, "IlluminatedWordWrite", { link = "Visual" })
  end,
})
vim.api.nvim_set_hl(0, "IlluminatedCurWord", { bg = "#B2D4FC" })
vim.cmd([[
augroup illuminate_augroup
    autocmd!
    autocmd VimEnter * hi illuminatedCurWord cterm=italic gui=italic
augroup END
]])

function Setup_cpp_keybindings()
  -- Define your keybindings here
  vim.api.nvim_set_keymap(
    "n",
    "<F9>",
    ':w <bar> :TermExec cmd="cd %:p:h/build && time make %:r" go_back=1 <CR>',
    { noremap = true, silent = true }
  )
  vim.api.nvim_set_keymap(
    "i",
    "<F9>",
    '<ESC> :w <bar> :TermExec cmd="cd %:p:h/build && time make %:r" go_back=1 <CR>',
    { noremap = true, silent = true }
  )
  vim.api.nvim_set_keymap(
    "n",
    "<F8>",
    ':TermExec cmd="cd %:p:h/build && run_solution.sh %:r cpp" go_back=0 <CR>',
    { noremap = true, silent = true }
  )
  vim.api.nvim_set_keymap(
    "n",
    "<F10>",
    ':w <bar> :TermExec cmd="cd %:p:h && test_solution.sh %:r cpp" go_back=1 <CR>',
    { noremap = true, silent = true }
  )
end

function Setup_python_keybindings()
  -- Define your keybindings here
  vim.api.nvim_set_keymap(
    "n",
    "<F9>",
    ':w <bar> :TermExec cmd="cd %:p:h && run_solution.sh %:r python" go_back=0 <CR>',
    { noremap = true, silent = true }
  )
  vim.api.nvim_set_keymap(
    "i",
    "<F9>",
    '<ESC> :w <bar> :TermExec cmd="cd %:p:h && run_solution.sh %:r python" go_back=0 <CR>',
    { noremap = true, silent = true }
  )
  vim.api.nvim_set_keymap(
    "n",
    "<F8>",
    ':w <bar> :TermExec cmd="cd %:p:h && run_solution.sh %:r python" go_back=0 <CR>',
    { noremap = true, silent = true }
  )
  vim.api.nvim_set_keymap(
    "n",
    "<F10>",
    ':w <bar> :TermExec cmd="cd %:p:h && test_solution.sh %:r python" go_back=1 <CR>',
    { noremap = true, silent = true }
  )
end

-- Autocmd to trigger the function for Markdown files
vim.cmd([[
  autocmd FileType cpp lua Setup_cpp_keybindings()
  autocmd FileType python lua Setup_python_keybindings()
]])
