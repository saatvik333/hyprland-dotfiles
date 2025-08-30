-- bootstrap lazy.nvim, LazyVim and your plugins
require("config.lazy")
vim.opt.autochdir = true
vim.api.nvim_set_hl(0, "StatusLine", { bg = "#07070A", fg = "#ADADB2" })
vim.api.nvim_set_hl(0, "StatusLineNC", { bg = "", fg = "#828288" })
vim.api.nvim_set_hl(0, "StatusLineTerm", { bg = "#07070A", fg = "#ADADB2" })
vim.cmd.colorscheme("neopywal")