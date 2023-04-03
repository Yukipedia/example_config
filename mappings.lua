---@type MappingsTable
local M = {}

M.general = {
  n = {
    [";"] = { ":", "enter command mode", opts = { nowait = true } },
  },
  v = {
    [">"] = { ">gv", "indent"},
  },
}

-- Extras example
-- M.symbols_outline = {
--   n = {
--     ["<leader>cs"] = { "<cmd>SymbolsOutline<cr>", "Symbols Outline" },
--   },
-- }

-- more keybinds!

return M
