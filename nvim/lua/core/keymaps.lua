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

-- Fast buffer switching with Shift+h and Shift+l
vim.keymap.set("n", "L", ":bnext<CR>", { noremap = true, silent = true })
vim.keymap.set("n", "H", ":bprevious<CR>", { noremap = true, silent = true })

-- ThePrimeagen's remaps
-- Keeps cursor centered when searching
vim.keymap.set("n", "n", "nzzzv")
vim.keymap.set("n", "N", "Nzzzv")

-- Keeps cursor in place when joining lines
vim.keymap.set("n", "J", "mzJ`z")

-- Yank to system clipboard
vim.keymap.set({ "n", "v" }, "<leader>y", [["+y]])
vim.keymap.set("n", "<leader>Y", 'gg"+yG')
