local status_ok, vimtex = pcall(require, "vimtex")
if not status_ok then
	return
end

vim.g.maplocalleader = ","
vim.g.vimtex_view_method = "zathura"
