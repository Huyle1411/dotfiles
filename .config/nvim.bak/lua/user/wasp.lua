local status_ok, wasp = pcall(require, "wasp")
if not status_ok then
	return
end

wasp.setup({
	template_path = function()
		return "~/.template/template." .. vim.fn.expand("%:e")
	end,
	lib = {
		finder = "telescope", -- or 'telescope'
		path = "~/library/",
	},
	competitive_companion = { file = "inp" },
})

wasp.set_default_keymaps()
