---@type MappingsTable
local M = {}

M.general = {
  n = {
    [";"] = { ":", "enter command mode", opts = { nowait = true } },
  },
  v = {
    [">"] = { ">gv", "indent"},
  },
  t = {
    -- Using NvChad mapping <C-x> to Escape terminal mode
    -- ["jk"] = {"<C-\\><C-n>", "escape terminal mode"}
  }
}

M.telescope = {
  n = {
    ["<leader>fws"] = {"<cmd>Telescope lsp_dynamic_workspace_symbols<CR>", "find workspace symbols"},
    ["<leader>fs"] = {"<cmd>Telescope lsp_document_symbols<CR>", "find document symbols"}
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
