local status_ok, configs = pcall(require, "nvim-treesitter.configs")
if not status_ok then
	return
end

configs.setup({
	ensure_installed = { "cpp", "python", "lua", "cmake" }, -- one of "all" or a list of languages
	highlight = {
		enable = true, -- false will disable the whole extension
	},
  ignore_install = {"latex"},
    rainbow = {
    enable = true,
    extended_mode = true, -- Also highlight non-bracket delimiters like html tags, boolean or table: lang -> boolean
    max_file_lines = nil, -- Do not enable for files with more than n lines, int
  },
	autopairs = {
		enable = true,
	},
	indent = { enable = false, disable = { "python", "css" } },
})
