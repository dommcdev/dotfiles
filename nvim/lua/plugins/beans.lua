return {
  -- Add Beancount filetype detection
  {
    "nvim-treesitter/nvim-treesitter",
    opts = function(_, opts)
      if type(opts.ensure_installed) == "table" then
        vim.list_extend(opts.ensure_installed, { "beancount" })
      end
    end,
  },
  
  -- Register filetype extension
  {
    "neovim/nvim-lspconfig",
    opts = {
      servers = {
        beancount = {
          init_options = {
            journal_file = vim.fn.expand("~/dev/beans/ledger.beancount"),
          },
        },
      },
      setup = {
        beancount = function()
            -- Add filetype detection
            vim.filetype.add({
                extension = {
                    beancount = "beancount",
                    bean = "beancount",
                },
            })
        end,
      }
    },
  },
}
