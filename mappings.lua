---@type MappingsTable
local M = {}

M.general = {
  n = {
    [";"] = { ":", "enter command mode", opts = { nowait = true } },
  },
  t = {
    -- Using NvChad mapping <C-x> to Escape terminal mode
    -- ["jk"] = {"<C-\\><C-n>", "escape terminal mode"}
  }
}

M.telescope = {
  n = {
    ["<leader>fs"] = {"<cmd>Telescope lsp_dynamic_workspace_symbols<CR>", "find symbols"},
    ["<leader>fds"] = {"<cmd>Telescope lsp_document_symbols<CR>", "find document symbols"}
  },
}

M.symbols_outline = {
  n = {
    ["<leader>cs"] = { "<cmd>SymbolsOutline<CR>", "Symbols Outline" },
  },
}

M.todo_comments = {
  n = {
    ["<leader>tl"] = {'<cmd>TodoTelescope<CR>', "todo telescope"},
    ["<leader>tq"] = {'<cmd>TodoQuickFix<CR>', "todo quickfix list"},
    ["<leader>tt"] = {'<cmd>TodoTrouble<CR>', "todo trouble"},
  },
}

return M
