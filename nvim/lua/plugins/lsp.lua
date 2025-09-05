
return {
  -- Core LSP
  {
    "neovim/nvim-lspconfig",
    config = function()

      -- Setup diagnostic display
      vim.diagnostic.config({
        virtual_text = true,
        signs = true,
        underline = true,
        update_in_insert = false,
      })

      -- Keymaps for LSP actions
      local opts = { noremap=true, silent=true }
      vim.keymap.set('n', 'K', vim.lsp.buf.hover, opts)
      vim.keymap.set('n', 'gd', vim.lsp.buf.definition, opts)
      vim.keymap.set('n', 'gD', vim.lsp.buf.declaration, opts)
      vim.keymap.set('n', 'gi', vim.lsp.buf.implementation, opts)
      vim.keymap.set('n', 'gr', vim.lsp.buf.references, opts)
      vim.keymap.set('n', '<leader>rn', vim.lsp.buf.rename, opts)
      vim.keymap.set('n', '<leader>ca', vim.lsp.buf.code_action, opts)
      vim.keymap.set('n', '[d', vim.diagnostic.goto_prev, opts)
      vim.keymap.set('n', ']d', vim.diagnostic.goto_next, opts)
      vim.keymap.set('n', '<leader>q', vim.diagnostic.setloclist, opts)
    end
  },

  -- Mason installer
  {
    "williamboman/mason.nvim",
    config = function()
      require("mason").setup()
    end
  },


  -- Mason-LSP bridge
  {
    "williamboman/mason-lspconfig.nvim",
    config = function()
      local capabilities = require("cmp_nvim_lsp").default_capabilities()

      require("mason-lspconfig").setup({
        ensure_installed = { "lua_ls", "clangd" },
        handlers = {
          function(server_name)
            require("lspconfig")[server_name].setup {
              capabilities = capabilities
            }
          end,
        },
      })
    end
  },


  -- Trouble for diagnostics UI (optional but nice)
  {
    "folke/trouble.nvim",
    dependencies = "nvim-tree/nvim-web-devicons",
    opts = {}
  },

  -- Autocompletion setup
  {
    "hrsh7th/nvim-cmp",
    dependencies = {
      "hrsh7th/cmp-nvim-lsp",  -- LSP completions
      "hrsh7th/cmp-buffer",    -- buffer words
      "hrsh7th/cmp-path",      -- file paths
      "L3MON4D3/LuaSnip",      -- snippet engine
      "saadparwaiz1/cmp_luasnip", -- snippet completions
    },
    config = function()
      local cmp = require("cmp")
      local luasnip = require("luasnip")

      cmp.setup({
        snippet = {
          expand = function(args)
            luasnip.lsp_expand(args.body)
          end,
        },
        mapping = cmp.mapping.preset.insert({
          ["<C-Space>"] = cmp.mapping.complete(),
          ["<CR>"] = cmp.mapping.confirm({ select = true }),
          ["<Tab>"] = cmp.mapping(function(fallback)
            if cmp.visible() then
              cmp.select_next_item()
            elseif luasnip.expand_or_jumpable() then
              luasnip.expand_or_jump()
            else
              fallback()
            end
          end, { "i", "s" }),
          ["<S-Tab>"] = cmp.mapping(function(fallback)
            if cmp.visible() then
              cmp.select_prev_item()
            elseif luasnip.jumpable(-1) then
              luasnip.jump(-1)
            else
              fallback()
            end
          end, { "i", "s" }),
        }),
        sources = cmp.config.sources({
          { name = "nvim_lsp" },
          { name = "luasnip" },
          { name = "buffer" },
          { name = "path" },
        }),
      })
    end,
  },
}
