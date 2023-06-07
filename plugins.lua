local overrides = require("custom.configs.overrides")

---@type NvPluginSpec[]
local plugins = {

  -- Override plugin definition options

  {
    "neovim/nvim-lspconfig",
    dependencies = {
      -- format & linting
      {
        "jose-elias-alvarez/null-ls.nvim",
        config = function()
          require "custom.configs.null-ls"
        end,
      },
    },
    config = function()
      require "plugins.configs.lspconfig"
      require "custom.configs.lspconfig"
    end, -- Override to setup mason-lspconfig
  },

  -- override plugin configs
  {
    "williamboman/mason.nvim",
    opts = overrides.mason
  },

  {
    "nvim-treesitter/nvim-treesitter",
    opts = overrides.treesitter,
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
    "ggandor/leap.nvim",
    dependencies = "tpope/vim-repeat",
    lazy = false,
    config = function()
      local leap = require("leap")
      vim.api.nvim_set_hl(0, 'LeapBackdrop', { link = 'Comment' }) -- or some grey
      vim.api.nvim_set_hl(0, 'LeapMatch', {
        -- For light themes, set to 'black' or similar.
        fg = 'white', bold = true, nocombine = true,
      })
      -- Of course, specify some nicer shades instead of the default "red" and "blue".
      vim.api.nvim_set_hl(0, 'LeapLabelPrimary', {
        fg = 'red', bold = true, nocombine = true,
      })
      vim.api.nvim_set_hl(0, 'LeapLabelSecondary', {
        fg = 'blue', bold = true, nocombine = true,
      })
      -- Try it without this setting first, you might find you don't even miss it.
      -- leap.opts.highlight_unlabeled_phase_one_targets = true

      -- leap.opts.safe_labels = {}
      leap.add_default_mappings()
    end
  },

  {
    "folke/persistence.nvim",
    event = "BufReadPre",
    module = "persistence",
    opts = {},
  },

  {
    "folke/todo-comments.nvim",
    event = "BufEnter",
    dependencies = "nvim-lua/plenary.nvim",
    opts = {},
  },

  {
    "kevinhwang91/nvim-ufo",
    event = { "BufEnter" },
    dependencies = { "kevinhwang91/promise-async" },
    config = function ()
      ---@param bufnr number
      ---@return Promise
      local function customizeSelector(bufnr)
          local function handleFallbackException(err, providerName)
              if type(err) == 'string' and err:match('UfoFallbackException') then
                  return require('ufo').getFolds(bufnr, providerName)
              else
                  return require('promise').reject(err)
              end
          end

          return require('ufo').getFolds(bufnr, 'lsp'):catch(function(err)
              return handleFallbackException(err, 'treesitter')
          end):catch(function(err)
              return handleFallbackException(err, 'indent')
          end)
      end

      local fold_virt_text_handler = function(virtText, lnum, endLnum, width, truncate)
          local newVirtText = {}
          local suffix = ('  %d '):format(endLnum - lnum)
          local sufWidth = vim.fn.strdisplaywidth(suffix)
          local targetWidth = width - sufWidth
          local curWidth = 0
          for _, chunk in ipairs(virtText) do
              local chunkText = chunk[1]
              local chunkWidth = vim.fn.strdisplaywidth(chunkText)
              if targetWidth > curWidth + chunkWidth then
                  table.insert(newVirtText, chunk)
              else
                  chunkText = truncate(chunkText, targetWidth - curWidth)
                  local hlGroup = chunk[2]
                  table.insert(newVirtText, {chunkText, hlGroup})
                  chunkWidth = vim.fn.strdisplaywidth(chunkText)
                  -- str width returned from truncate() may less than 2nd argument, need padding
                  if curWidth + chunkWidth < targetWidth then
                      suffix = suffix .. (' '):rep(targetWidth - curWidth - chunkWidth)
                  end
                  break
              end
              curWidth = curWidth + chunkWidth
          end
          table.insert(newVirtText, {suffix, 'MoreMsg'})
          return newVirtText
      end

      vim.o.foldcolumn = '1' -- '0' is not bad
      vim.o.foldlevel = 99 -- Using ufo provider need a large value, feel free to decrease the value
      vim.o.foldlevelstart = 99
      vim.o.foldenable = true

      vim.keymap.set('n', 'zR', require('ufo').openAllFolds)
      vim.keymap.set('n', 'zM', require('ufo').closeAllFolds)      
      vim.keymap.set('n', 'zr', require('ufo').openFoldsExceptKinds)
      vim.keymap.set('n', 'zm', require('ufo').closeFoldsWith) -- closeAllFolds == closeFoldsWith(0)
      vim.keymap.set('n', 'K', function()
          local winid = require('ufo').peekFoldedLinesUnderCursor()
          if not winid then
              vim.lsp.buf.hover()
          end
      end)      

      require('ufo').setup({
          provider_selector = function(bufnr, filetype, buftype)
              return customizeSelector
          end,
          fold_virt_text_handler = fold_virt_text_handler
      })
    end
  },

  -- Language
  {
    "fatih/vim-go",
    event = "BufEnter",
  },

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

  -- To use a extras plugin
  { import = "custom.configs.extras.copilot", },
  { import = "custom.configs.extras.diffview", },
  { import = "custom.configs.extras.mason-extras", },
  { import = "custom.configs.extras.symbols-outline", },
  { import = "custom.configs.extras.trouble", },
}

return plugins
