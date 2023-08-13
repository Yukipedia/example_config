local on_attach = require("plugins.configs.lspconfig").on_attach
local capabilities = require("plugins.configs.lspconfig").capabilities
capabilities.textDocument.foldingRange = {
  dynamicRegistration = false,
  lineFoldingOnly = true,
}

local lspconfig = require "lspconfig"

local language_servers = lspconfig.util.available_servers() -- or list servers manually like {'gopls', 'clangd'}
for _, ls in ipairs(language_servers) do
  lspconfig[ls].setup {
    on_attach = function(client, bufnr)
      require("lsp-format").on_attach(client)
      return on_attach(client, bufnr)
    end,
    capabilities = capabilities,
  }
end
