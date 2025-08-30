-- Options are automatically loaded before lazy.nvim startup
-- Default options that are always set: https://github.com/LazyVim/LazyVim/blob/main/lua/lazyvim/config/options.lua
-- Add any additional options here

-- File handling: Swap, Backup, Undo
-- Store swap files in the same directory as the file being edited
vim.opt.swapfile = true
vim.opt.directory = "."

-- Store backup files in the same directory as the file being edited
vim.opt.backup = false -- Disable backups if you prefer (they can clutter directories)
-- If you want backups, uncomment the lines below and comment the line above
-- vim.opt.backup = true
-- vim.opt.backupdir = "."

-- Persistent undo history (stored in a central location)
vim.opt.undofile = true
vim.opt.undodir = vim.fn.stdpath("data") .. "/undo//" -- Use Neovim's data directory for undo files

-- Ensure terminal opens in current working directory
vim.api.nvim_create_autocmd("TermOpen", {
  callback = function()
    vim.opt_local.number = false
    vim.opt_local.relativenumber = false
    vim.opt_local.signcolumn = "no"
  end,
})

vim.cmd.colorscheme = nil
vim.opt.termguicolors = false
vim.cmd("set t_Co=256")

-- Ensure format on save is enabled
vim.api.nvim_create_autocmd("BufWritePre", {
  pattern = "*",
  callback = function(args)
    require("conform").format({ bufnr = args.buf })
  end,
})