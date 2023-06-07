---@type MappingsTable
local M = {}

M.general = {
  n = {
    [";"] = { ":", "enter command mode", opts = { nowait = true } },
  },
  t = {
    ["<Esc>"] = {"<C-\\><C-n>", "escape terminal mode"}
  },
}

M.telescope = {
  n = {
    ["<leader>fs"] = {"<cmd>Telescope lsp_dynamic_workspace_symbols<CR>", "find symbols"},
  },
}

M.symbols_outline = {
  n = {
    ["<leader>cs"] = { "<cmd>SymbolsOutline<cr>", "Symbols Outline" },
  },
}

M.persistence = {
  n = {
    ["<leader>qs"] = {'<cmd>lua require("persistence").load()<CR>', "restore the session for the current directory"},
    ["<leader>ql"] = {'<cmd>lua require("persistence").load({ last = true })<CR>', "restore the last session"},
    ["<leader>qd"] = {'<cmd>lua require("persistence").load()<CR>', "stop persistence"},
  }
}

M.todo_comments = {
  n = {
    ["<leader>tl"] = {'<cmd>TodoTelescope<CR>', "todo telescope"},
    ["<leader>tq"] = {'<cmd>TodoQuickFix<CR>', "todo quickfix list"},
    ["<leader>tt"] = {'<cmd>TodoTrouble<CR>', "todo trouble"},
  },
}

return M
