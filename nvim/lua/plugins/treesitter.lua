return {
    "nvim-treesitter/nvim-treesitter",
    branch = "main",
    lazy = false,
    build = ":TSUpdate",
    config = function()
        -- Enable treesitter highlighting for all filetypes with a parser
        vim.api.nvim_create_autocmd("FileType", {
            callback = function()
                pcall(vim.treesitter.start)
            end,
        })
    end,
    -- To install parsers, run :TSInstall <language>
    -- Or install all at once:
    -- :TSInstall lua vim vimdoc python java c cpp html css javascript typescript tsx sql go json yaml toml bash markdown markdown_inline
}
