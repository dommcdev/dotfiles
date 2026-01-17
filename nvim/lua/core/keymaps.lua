vim.keymap.set("n", "<C-t>", "<cmd>silent !tmux neww tmux-sessionizer<CR>")
vim.keymap.set("n", "<M-h>", "<cmd>silent !tmux neww tmux-sessionizer -s 0<CR>")
vim.keymap.set("n", "<M-j>", "<cmd>silent !tmux neww tmux-sessionizer -s 1<CR>")
vim.keymap.set("n", "<M-k>", "<cmd>silent !tmux neww tmux-sessionizer -s 2<CR>")
vim.keymap.set("n", "<M-l>", "<cmd>silent !tmux neww tmux-sessionizer -s 3<CR>")

vim.keymap.set("n", "<leader>t", function()
  Snacks.terminal.toggle(nil, {
    cwd = vim.fn.expand("%:p:h"),
    win = {
      position = "float",
      height = 0.9,
      width = 0.9,
      border = "rounded",
    },
  })
end, { desc = "Toggle Terminal" })
