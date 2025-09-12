vim.api.nvim_create_user_command("ClangFormat", function()
    vim.cmd('!clang-format -i -style="{BasedOnStyle: Google, IndentWidth: 4}" %')
end, {})
