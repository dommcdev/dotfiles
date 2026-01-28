return {
  -- Typst Preview
  {
    "chomosuke/typst-preview.nvim",
    ft = "typst",
    version = "1.*",
    build = function() require("typst-preview").update() end,
    keys = {
      { "<leader>tp", "<cmd>TypstPreviewToggle<CR>", desc = "Toggle Typst Preview" },
    },
  },

  -- LSP Config
  {
    "neovim/nvim-lspconfig",
    opts = {
      servers = {
        tinymist = {
          -- tinymist configuration matches what was used in the old config
          offset_encoding = "utf-8",
          single_file_support = true,
        },
      },
    },
  },

  -- Mason (Ensure LSP and Formatter are installed)
  {
    "mason-org/mason.nvim",
    opts = function(_, opts)
      opts.ensure_installed = opts.ensure_installed or {}
      vim.list_extend(opts.ensure_installed, { "tinymist", "typstyle" })
    end,
  },

  -- Conform (Formatting)
  {
    "stevearc/conform.nvim",
    opts = {
      formatters_by_ft = {
        typst = { "typstyle" },
      },
    },
  },
}
