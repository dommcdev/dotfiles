-- Set <space> as the leader key...see `:help mapleader`
--  NOTE: Must happen before plugins are loaded (otherwise wrong leader will be used)
vim.g.mapleader = ' '
vim.g.maplocalleader = ' '

-- Prevent side colume width changing if lsp shows/stops showing symbols
vim.opt.signcolumn="yes"

vim.g.have_nerd_font = true
vim.o.mouse = 'a'

-- Relative numbers + absolute number for current line
vim.o.number = true
vim.o.relativenumber = true

-- Indenting stuff
vim.opt.expandtab = true --use spaces instead of tabs
vim.opt.tabstop = 4      --render a tab character as 2 spaces
vim.opt.shiftwidth = 4   --number of spaces to use for autoindent
vim.opt.softtabstop = -1  --number of spaces inserted by <Tab> key

-- Make * register behave like + register
vim.keymap.set({ "n", "v" }, '"*', '"+', { remap = true })

-- Save undo history
vim.o.undofile = true

-- Case-insensitive searching UNLESS \C or one or more capital letters in the search term
vim.o.ignorecase = true
vim.o.smartcase = true

-- Preview substitutions live
vim.o.inccommand = 'split'

-- Show which line your cursor is on
vim.o.cursorline = true

-- Minimal number of screen lines to keep above and below the cursor.
vim.o.scrolloff = 8

-- raise save confirmation dialog instead of failing for some operations
vim.o.confirm = true

-- Clear highlights on search when pressing <Esc> in normal mode
vim.keymap.set('n', '<Esc>', '<cmd>nohlsearch<CR>')

-- Better home/end line movement
--vim.keymap.set({ 'n', 'v', 'o' }, 'L', '$', { noremap = true, desc = 'Move to end of line' })
--vim.keymap.set({ 'n', 'v', 'o' }, 'H', '^', { noremap = true, desc = 'Move to first nonblank character' })

-- Highlight when yanking (copying) text, try it with `yap` in normal mode
vim.api.nvim_create_autocmd('TextYankPost', {
  desc = 'Highlight when yanking (copying) text',
  group = vim.api.nvim_create_augroup('kickstart-highlight-yank', { clear = true }),
  callback = function()
    vim.hl.on_yank()
  end,
})



-- workaround for getting clipboard to work with ssh -> tmux -> nvim
-- clipboard works out-of-the-box for ssh -> nvim
-- copying works out-of-the-box for tmux -> ssh -> nvim, but pasting only works with ctrl+shift+v
vim.g.clipboard = {
  name = 'OSC 52',
  copy = {
    ['+'] = require('vim.ui.clipboard.osc52').copy('+'),
    ['*'] = require('vim.ui.clipboard.osc52').copy('*'),
  },
  paste = {
    ['+'] = require('vim.ui.clipboard.osc52').paste('+'),
    ['*'] = require('vim.ui.clipboard.osc52').paste('*'),
  },
}
if vim.env.TMUX ~= nil then
  local copy = {'tmux', 'load-buffer', '-w', '-'}
  local paste = {'bash', '-c', 'tmux refresh-client -l && sleep 0.05 && tmux save-buffer -'}
  vim.g.clipboard = {
    name = 'tmux',
    copy = {
      ['+'] = copy,
      ['*'] = copy,
    },
    paste = {
      ['+'] = paste,
      ['*'] = paste,
    },
    cache_enabled = 0,
  }
end
