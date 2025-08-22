
-- Set mapleader before lazy.nvim
vim.g.mapleader = " "
vim.g.maplocalleader = "\\"

-- Set core options
require("core.options")
require("core.keymaps")
require("core.autocmd")

-- Bootstrap lazy.nvim
local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
if not vim.loop.fs_stat(lazypath) then
  vim.fn.system({
    "git",
    "clone",
    "--filter=blob:none",
    "https://github.com/folke/lazy.nvim.git",
    "--branch=stable",
    lazypath,
  })
end
vim.opt.rtp:prepend(lazypath)

-- Load and setup your plugins
require("lazy").setup({
  { import = "plugins" },
}, {})
