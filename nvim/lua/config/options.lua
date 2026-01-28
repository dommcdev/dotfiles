-- Default options that are always set: https://github.com/LazyVim/LazyVim/blob/main/lua/lazyvim/config/options.lua

-- Set <space> as the leader key...see `:help mapleader`
--  NOTE: Must happen before plugins are loaded (otherwise wrong leader will be used)
vim.g.mapleader = " "
vim.g.maplocalleader = " "

-- Prevent side colume width changing if lsp shows/stops showing symbols
vim.opt.signcolumn = "yes"

vim.g.have_nerd_font = true
vim.o.mouse = "a"

-- Relative numbers + absolute number for current line
vim.o.number = true
vim.o.relativenumber = true

-- Indenting stuff
vim.opt.expandtab = true --use spaces instead of tabs
vim.opt.tabstop = 4 --render a tab character as 2 spaces
vim.opt.shiftwidth = 4 --number of spaces to use for autoindent
vim.opt.softtabstop = -1 --number of spaces inserted by <Tab> key

-- Make * register behave like + register
vim.keymap.set({ "n", "v" }, '"*', '"+', { remap = true })

-- Save undo history
vim.o.undofile = true

-- Case-insensitive searching...
vim.o.ignorecase = true
vim.o.smartcase = true --UNLESS \C or one or more capital letters in the search ter

-- Preview substitutions live
vim.o.inccommand = "split"

-- Show which line your cursor is on
vim.o.cursorline = true

-- Minimal number of screen lines to keep above and below the cursor.
vim.o.scrolloff = 4

-- raise save confirmation dialog instead of failing for some operations
vim.o.confirm = true
