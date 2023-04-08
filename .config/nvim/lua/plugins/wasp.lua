return {
  {
    "LeoRiether/wasp.nvim",
    opts = function(_)
      local wasp = require("wasp")
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
    end,
  },
}
