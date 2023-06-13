local autocmd = vim.api.nvim_create_autocmd

-- Auto resize panes when resizing nvim window
autocmd("VimResized", {
  pattern = "*",
  command = "tabdo wincmd =",
})

autocmd("BufWinLeave", {
  pattern = "*.*",
  command = "mkview",
})

autocmd("BufWinEnter", {
  pattern = "*.*",
  command = "silent! loadview",
})

vim.opt.sessionoptions="blank,buffers,curdir,folds,help,tabpages,winsize,winpos,terminal,localoptions"

-- https://github.com/fatih/vim-go/issues/502
-- For me, all the folds were deleted on write.
vim.g.go_fmt_autosave = 0

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
