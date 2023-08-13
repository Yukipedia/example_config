local function restore_nvim_tree()
  local api = require "nvim-tree.api"
  local view = require "nvim-tree.view"

  if not view.is_visible() then
    api.tree.open()
  end
end

local function close_nvim_tree()
  local api = require "nvim-tree.api"

  api.tree.close()
end

---@type NvPluginSpec
local spec = {
  "rmagatti/auto-session",
  lazy = false,
  config = function()
    require("auto-session").setup {
      auto_save_enabled = true,
      auto_restore_enabled = true,
      auto_session_use_git_branch = true,
      session_lens = {
        load_on_setup = true,
      },
      -- post_restore_cmds = { restore_nvim_tree },
      pre_save_cmds = { close_nvim_tree },
    }

    -- using vim api instead keys opts
    -- because session-lens is loaded after setup
    vim.keymap.set("n", "<leader>ts", require("auto-session.session-lens").search_session, {
      noremap = true,
    })
  end,
}

return spec
