
return {
  "nvim-treesitter/nvim-treesitter",
  build = ":TSUpdate",
  opts = {
    ensure_installed = { "lua", "vim", "python" },
    highlight = { enable = true },
    indent = { enable = true },
  },
}
