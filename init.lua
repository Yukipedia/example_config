local opt = vim.opt
local autocmd = vim.api.nvim_create_autocmd

IN_WSL = os.getenv "WSL_DISTRO_NAME" ~= nil

-- Auto resize panes when resizing nvim window
autocmd("VimResized", {
  pattern = "*",
  command = "tabdo wincmd =",
})

-- Disable ufo in some buffer
vim.api.nvim_create_autocmd("FileType", {
  pattern = { "nvcheatsheet", "neo-tree", "Outline" },
  callback = function()
    require("ufo").detach()
    vim.opt_local.foldenable = false
    vim.wo.foldcolumn = "0"
  end,
})

-- autocmd("BufWinLeave", {
--   pattern = "*.*",
--   command = "mkview",
-- })
--
-- autocmd("BufWinEnter", {
--   pattern = "*.*",
--   command = "silent! loadview",
-- })

--  sessionoptions removed localoptions
vim.o.sessionoptions = "blank,buffers,curdir,folds,help,tabpages,winsize,winpos,terminal"

opt.relativenumber = true
-- vim.wo.wrap = false

-- override NvChad default options
-- clipboard
opt.clipboard = ""

-- tabs and spaces
opt.expandtab = false

-- list characters
-- opt.list = true
-- opt.listchars:append "space:⋅"
-- opt.listchars:append "eol:↴"

-- https://github.com/fatih/vim-go/issues/502
-- For me, all the folds were deleted on write.
vim.g.go_fmt_autosave = 0

-- LSP debug logging
-- vim.lsp.set_log_level("debug")

if vim.loop.os_uname().sysname == "Windows_NT" then
  local powershell_options = {
    shell = vim.fn.executable "pwsh" == 1 and "pwsh" or "powershell",
    shellcmdflag = "-NoLogo -NoProfile -ExecutionPolicy RemoteSigned -Command [Console]::InputEncoding=[Console]::OutputEncoding=[System.Text.Encoding]::UTF8;",
    shellredir = "-RedirectStandardOutput %s -NoNewWindow -Wait",
    shellpipe = "2>&1 | Out-File -Encoding UTF8 %s; exit $LastExitCode",
    shellquote = "",
    shellxquote = "",
  }
  for option, value in pairs(powershell_options) do
    vim.opt[option] = value
  end
end

if IN_WSL then
  vim.g.clipboard = {
    name = "WslClipboard",
    copy = {
      ["+"] = { "clip.exe" },
      ["*"] = { "clip.exe" },
    },
    paste = {
      ["+"] = 'powershell.exe -c [Console]::Out.Write($(Get-Clipboard -Raw).tostring().replace("`r", ""))',
      ["*"] = 'powershell.exe -c [Console]::Out.Write($(Get-Clipboard -Raw).tostring().replace("`r", ""))',
    },
    cache_enabled = 1,
  }
end
