local null_ls = require "null-ls"

local b = null_ls.builtins
local cspell = require("cspell")
local cspell_config = {
  --- Callback after a successful execution of a code action.
  ---@param cspell_config_file_path string|nil
  ---@param params GeneratorParams
  ---@action_name 'use_suggestion'|'add_to_json'|'add_to_dictionary'
  on_success = function(cspell_config_file_path, _, action_name)
    -- For example, you can format the cspell config file after you add a word
    if action_name == 'add_to_json' then
      os.execute(
        string.format(
          "cat %s | jq -S '.words |= sort' | tee %s > /dev/null",
          cspell_config_file_path,
          cspell_config_file_path
        )
      )
    end

    -- Note: The cspell_config_file_path param could be nil for the
    -- 'use_suggestion' action
  end
}

local sources = {
  -- cspell.diagnostics.with({ config = cspell_config }),
  -- cspell.code_actions.with({ config = cspell_config }),
  -- cspell.diagnostics,
  -- cspell.code_actions,

  -- webdev stuff
  b.formatting.deno_fmt, -- choosed deno for ts/js files cuz its very fast!
  b.formatting.prettier.with { filetypes = { "html", "markdown", "css" } }, -- so prettier works only on these filetypes

  -- Lua
  b.formatting.stylua,

  -- golang
  b.formatting.gofumpt,
  b.formatting.goimports,
  b.formatting.goimports_reviser,

  -- cpp
  b.formatting.clang_format,
  b.formatting.cmake_format,

  --python
}

null_ls.setup {
  debug = true,
  sources = sources,
}
