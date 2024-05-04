return {
  { "ellisonleao/gruvbox.nvim" },
  { "vim-illuminate", opts = {
    under_cursor = false,
  } },
  {
    "LazyVim/LazyVim",
    opts = {
      colorscheme = "noctis_hibernus",
    },
  },
  {
    "talha-akram/noctis.nvim",
  },
  {
    "akinsho/bufferline.nvim",
    opts = {
      options = {
        always_show_bufferline = true,
      },
    },
  },
  {
    "michaeljsmith/vim-indent-object",
  },
  -- {
  --   "folke/tokyonight.nvim",
  --   opts = {
  --     transparent = true,
  --     styles = {
  --       sidebars = "transparent",
  --       floats = "transparent",
  --     },
  --   },
  -- },
  -- {
  --   "nvim-treesitter/nvim-treesitter",
  --   opts = {
  --     highlight = { enable = true },
  --     indent = { enable = true, disable = { "python" } },
  --     dependencies = {
  --       "JoosepAlviste/nvim-ts-context-commentstring",
  --     },
  --     context_commentstring = {
  --       enable = true,
  --       enable_autocmd = false,
  --       config = {
  --         cpp = "// %s",
  --       },
  --     },
  -- ensure_installed = {
  --   "bash",
  --   "c",
  --   "lua",
  --   "markdown",
  --   "markdown_inline",
  --   "python",
  --   "vim",
  -- },
  -- incremental_selection = {
  --   enable = true,
  --   keymaps = {
  --     init_selection = "<C-space>",
  --     node_incremental = "<C-space>",
  --     scope_incremental = "<nop>",
  --     node_decremental = "<bs>",
  --   },
  -- },
  -- },
  -- },
  {
    "neovim/nvim-lspconfig",
    opts = {
      servers = {
        -- Ensure mason installs the server
        clangd = {
          keys = {
            { "<leader>cR", "<cmd>ClangdSwitchSourceHeader<cr>", desc = "Switch Source/Header (C/C++)" },
          },
          root_dir = function(fname)
            return require("lspconfig.util").root_pattern(
              "Makefile",
              "configure.ac",
              "configure.in",
              "config.h.in",
              "meson.build",
              "meson_options.txt",
              "build.ninja"
            )(fname) or require("lspconfig.util").root_pattern("compile_commands.json", "compile_flags.txt")(
              fname
            ) or require("lspconfig.util").find_git_ancestor(fname)
          end,
          capabilities = {
            offsetEncoding = { "utf-16" },
          },
          cmd = {
            "clangd",
            "--background-index",
            "--clang-tidy",
            "--header-insertion=iwyu",
            "--completion-style=detailed",
            "--function-arg-placeholders",
            "--fallback-style=llvm",
          },
          init_options = {
            usePlaceholders = true,
            completeUnimported = true,
            clangdFileStatus = true,
          },
        },
      },
      setup = {
        clangd = function(_, opts)
          local clangd_ext_opts = LazyVim.opts("clangd_extensions.nvim")
          require("clangd_extensions").setup(vim.tbl_deep_extend("force", clangd_ext_opts or {}, { server = opts }))
          return false
        end,
      },
    },
  },
  {
    "rcarriga/nvim-notify",
    opts = {
      background_colour = "#000000",
    },
  },
  {
    "lewis6991/gitsigns.nvim",
    opts = {
      current_line_blame = true, -- Toggle with `:Gitsigns toggle_current_line_blame`
      current_line_blame_opts = {
        virt_text = true,
        virt_text_pos = "eol", -- 'eol' | 'overlay' | 'right_align'
        delay = 1000,
        ignore_whitespace = false,
      },
      current_line_blame_formatter = "<author>, <author_time:%Y-%m-%d> - <summary>",
      yadm = {
        enable = true,
      },
    },
  },
  -- add this to your lua/plugins.lua, lua/plugins/init.lua,  or the file you keep your other plugins:
  {
    "numToStr/Comment.nvim",
    opts = {
      -- add any options here
      -- ---Add a space b/w comment and the line
      padding = true,
      ---Whether the cursor should stay at its position
      sticky = true,
      ---Lines to be ignored while (un)comment
      ignore = nil,
      ---LHS of toggle mappings in NORMAL mode
      toggler = {
        ---Line-comment toggle keymap
        line = "gcc",
        ---Block-comment toggle keymap
        block = "gbc",
      },
    },
    lazy = false,
  },
  {
    "stevearc/conform.nvim",
    opts = { formatters_by_ft = {
      python = { "black" },
    } },
  },
}
