-- ~/.config/nvim/lua/plugins/lsp.lua

return {
  -- The core LSP configuration plugin
  { "neovim/nvim-lspconfig",
  config = function()
    local lspconfig = require("lspconfig")
    lspconfig.lua_ls.setup({})
    lspconfig.clangd.setup({})
    vim.keymap.set('n', 'K', vim.lsp.buf.hover, {})
  end
  },

  -- The installer for language servers
  { "williamboman/mason.nvim",
  config = function()
    require("mason").setup()
  end
  },

  -- Bridge between mason.nvim and nvim-lspconfig
  { "williamboman/mason-lspconfig.nvim",
    config = function()
      require("mason-lspconfig").setup({
        ensure_installed = {"lua_ls" }
      })
    end
  },

  -- A nice UI for LSP progress
  { "j-hui/fidget.nvim", opts = {} },
}
