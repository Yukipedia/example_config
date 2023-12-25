local setup = function(_, opts)
  local on_attach = require("plugins.configs.lspconfig").on_attach
  local capabilities = require("plugins.configs.lspconfig").capabilities

  capabilities.textDocument.foldingRange = {
    dynamicRegistration = false,
    lineFoldingOnly = true,
  }

  local lspconfig = require "lspconfig"

  -- List of servers to install
  -- local servers = { "html", "cssls", "tsserver", "clangd" }

  require("mason").setup(opts)

  require("mason-lspconfig").setup {
    -- ensure_installed = servers,
  }

  -- This will setup lsp for servers you listed above
  -- And servers you install through mason UI
  -- So defining servers in the list above is optional
  require("mason-lspconfig").setup_handlers {
    -- Default setup for all servers, unless a custom one is defined below
    function(server_name)
      lspconfig[server_name].setup {
        on_attach = function(client, bufnr)
          on_attach(client, bufnr)
          -- Add your other things here
          -- Example being format on save or something
        end,
        capabilities = capabilities,
      }
    end,
    -- custom setup for a server goes after the function above
    -- Example, override rust_analyzer
    -- ["rust_analyzer"] = function ()
    --   require("rust-tools").setup {}
    -- end,
    -- Another example with clangd
    -- Users usually run into different offset_encodings issue,
    -- so this is how to bypass it (kindof)
    ["clangd"] = function()
      lspconfig.clangd.setup {
        cmd = {
          "clangd",
          "--offset-encoding=utf-16", -- To match null-ls
          --  With this, you can configure server with
          --    - .clangd files
          --    - global clangd/config.yaml files
          --  Read the `--enable-config` option in `clangd --help` for more information
          "--enable-config",
        },
        on_attach = function(client, bufnr)
          on_attach(client, bufnr)
        end,
        capabilities = capabilities,
      }
    end,

    -- Example: disable auto configuring an LSP
    -- Here, we disable lua_ls so we can use NvChad's default config
    ["lua_ls"] = function() end,
  }

  -- EFM General purpose language server setup
  --

  -- Register linters and formatters per language
  -- javascript & typescript
  local xo = require "efmls-configs.linters.xo"
  local xo_formatter = require "efmls-configs.formatters.xo"
  xo["lint-ignore-exit-code"] = true

  local eslint = require "efmls-configs.linters.eslint"
  local eslint_formatter = require "efmls-configs.formatters.eslint"

  -- json
  local jq = require "efmls-configs.linters.jq"
  jq["lint-ignore-exit-code"] = true
  local jq_formatter = require "efmls-configs.formatters.jq"

  -- Extend default languages configs instead empty table
  local languages = require("efmls-configs.defaults").languages()
  languages = vim.tbl_extend("force", languages, {
    typescript = { xo, xo_formatter },
    javascript = { xo, xo_formatter },
    json = { jq, jq_formatter },
  })

  local efmls_config = {
    filetypes = vim.tbl_keys(languages),
    settings = {
      rootMarkers = { ".git/" },
      languages = languages,
    },
    init_options = {
      documentFormatting = true,
      documentRangeFormatting = true,
      hover = true,
      documentSymbol = true,
      codeAction = true,
      completion = true,
    },
  }

  lspconfig.efm.setup(vim.tbl_extend("force", efmls_config, {
    on_attach = require("lsp-format").on_attach,
  }))
end

---@type NvPluginSpec
local spec = {
  "neovim/nvim-lspconfig",
  -- BufRead is to make sure if you do nvim some_file then this is still going to be loaded
  event = { "VeryLazy", "BufRead" },
  config = function()
    require "plugins.configs.lspconfig"
  end, -- Override to make sure load order is correct
  dependencies = {
    {
      "williamboman/mason.nvim",
      config = function(plugin, opts)
        setup(plugin, opts)
      end,
    },
    "williamboman/mason-lspconfig",
    {
      "creativenull/efmls-configs-nvim",
      version = "v1.x.x", -- version is optional, but recommended
    },
    "lukas-reineke/lsp-format.nvim",
    -- TODO: Add mason-null-ls? mason-dap?
  },
}

return spec
