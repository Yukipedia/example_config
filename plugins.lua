local overrides = require "custom.configs.overrides"

---@type NvPluginSpec[]
local plugins = {
  { import = "custom.configs.lspconfig" },

  {
    "nvim-treesitter/nvim-treesitter",
    opts = overrides.treesitter,
  },

  {
    "nvim-treesitter/nvim-treesitter-textobjects",
    dependencies = {
      "nvim-treesitter/nvim-treesitter",
    },
  },

  {
    "nvim-tree/nvim-tree.lua",
    opts = overrides.nvimtree,
  },

  -- Install a plugin
  {
    "max397574/better-escape.nvim",
    event = "InsertEnter",
    config = function()
      require("better_escape").setup()
    end,
  },

  {
    "chentoast/marks.nvim",
    event = "BufEnter",
    config = function()
      require("marks").setup()
    end,
  },

  {
    "ggandor/leap.nvim",
    dependencies = "tpope/vim-repeat",
    event = "BufEnter",
    config = function()
      local leap = require "leap"
      vim.api.nvim_set_hl(0, "LeapBackdrop", { link = "Comment" }) -- or some grey
      vim.api.nvim_set_hl(0, "LeapMatch", {
        -- For light themes, set to 'black' or similar.
        fg = "white",
        bold = true,
        nocombine = true,
      })
      -- Of course, specify some nicer shades instead of the default "red" and "blue".
      vim.api.nvim_set_hl(0, "LeapLabelPrimary", {
        fg = "red",
        bold = true,
        nocombine = true,
      })
      vim.api.nvim_set_hl(0, "LeapLabelSecondary", {
        fg = "blue",
        bold = true,
        nocombine = true,
      })
      -- Try it without this setting first, you might find you don't even miss it.
      -- leap.opts.highlight_unlabeled_phase_one_targets = true

      -- leap.opts.safe_labels = {}
      leap.add_default_mappings()
    end,
  },

  {
    "folke/todo-comments.nvim",
    event = "BufEnter",
    dependencies = "nvim-lua/plenary.nvim",
    opts = {
      colors = {
        info = { "DiagnosticInformation", "#2563EB" },
      },
    },
  },

  {
    "tzachar/local-highlight.nvim",
    event = "BufEnter",
    opts = {},
  },

  -- {
  --   "Civitasv/cmake-tools.nvim",
  --   event = "BufEnter",
  --   dependencies = "nvim-lua/plenary.nvim",
  -- },

  -- Language
  -- {
  --   "fatih/vim-go",
  --   lazy = false,
  -- },

  -- To make a plugin not be loaded
  -- {
  --   "NvChad/nvim-colorizer.lua",
  --   enabled = false
  -- },

  -- All NvChad plugins are lazy-loaded by default
  -- For a plugin to be loaded, you will need to set either `ft`, `cmd`, `keys`, `event`, or set `lazy = false`
  -- If you want a plugin to load on startup, add `lazy = false` to a plugin spec, for example
  {
    "mg979/vim-visual-multi",
    lazy = false,
  },

  {
    "petertriho/nvim-scrollbar",
    lazy = false,
    config = function()
      local theme = require("base46").get_theme_tb "base_16"
      local colors = require("base46").get_theme_tb "base_30"

      require("scrollbar").setup {
        show = true,
        handle = {
          color = theme.base03,
        },
        marks = {
          Cursor = {
            color = theme.base0F,
          },
          GitAdd = {
            color = colors.green,
          },
          GitChange = {
            color = colors.light_grey,
          },
          GitDelete = {
            text = "~",
            color = colors.red,
          },
        },
      }
      require("scrollbar.handlers.gitsigns").setup()
    end,
  },

  {
    "kevinhwang91/nvim-hlslens",
    dependencies = { "petertriho/nvim-scrollbar" },
    config = function()
      require("hlslens").setup {
        build_position_cb = function(plist, _, _, _)
          require("scrollbar.handlers.search").handler.show(plist.start_pos)
        end,
      }

      vim.cmd [[
          augroup scrollbar_search_hide
              autocmd!
              autocmd CmdlineLeave : lua require('scrollbar.handlers.search').handler.hide()
          augroup END
      ]]
    end,
  },

  -- To use a extras plugin
  { import = "custom.configs.extras.diffview" },
  { import = "custom.configs.extras.symbols-outline" },
  { import = "custom.configs.extras.trouble" },
  { import = "custom.configs.ufo" },
  { import = "custom.configs.auto-session" },

  -- To use local plugins
  -- { dir = "./plugins/restore_view.vim" },
}

return plugins
