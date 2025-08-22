-- ~/.config/nvim/lua/plugins/lsp.lua

return {
  -- The core LSP configuration plugin
  { "neovim/nvim-lspconfig" },

  -- The installer for language servers
  { "williamboman/mason.nvim" },

  -- Bridge between mason.nvim and nvim-lspconfig
  { "williamboman/mason-lspconfig.nvim" },

  -- A nice UI for LSP progress
  { "j-hui/fidget.nvim", opts = {} },
}
