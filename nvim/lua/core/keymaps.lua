vim.api.nvim_create_user_command("ClangFormat", function()
    vim.cmd('!clang-format -i -style="{BasedOnStyle: Google, IndentWidth: 4}" %')
end, {})

vim.keymap.set("n", "<C-t>", "<cmd>silent !tmux neww tmux-sessionizer<CR>")
vim.keymap.set("n", "<M-h>", "<cmd>silent !tmux neww tmux-sessionizer -s 0<CR>")
vim.keymap.set("n", "<M-j>", "<cmd>silent !tmux neww tmux-sessionizer -s 1<CR>")
vim.keymap.set("n", "<M-k>", "<cmd>silent !tmux neww tmux-sessionizer -s 2<CR>")
vim.keymap.set("n", "<M-l>", "<cmd>silent !tmux neww tmux-sessionizer -s 3<CR>")
