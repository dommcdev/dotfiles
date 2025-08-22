return {
  'nvim-telescope/telescope.nvim',
  tag = '0.1.8',
  dependencies = { 'nvim-lua/plenary.nvim' },
  -- Add the keymap configuration here
  config = function()
    local telescope = require("telescope.builtin")
    vim.keymap.set("n", "<space>sf", telescope.find_files, { desc = "Find files" })
  end,
}
