return {
  -- Disable bufferline (tab bar)
  { "akinsho/bufferline.nvim", enabled = false },

  -- Configure lualine to show modified status [+]
  {
    "nvim-lualine/lualine.nvim",
    opts = function(_, opts)
      -- Override lualine_c to show filename with [+] modified symbol
      opts.sections.lualine_c = {
        {
          "filename",
          path = 1, -- Relative path
          symbols = {
            modified = "[+]",
            readonly = "[-]",
            unnamed = "[No Name]",
            newfile = "[New]",
          },
        },
      }
    end,
  },

  -- Configure Noice to put the command line in the bottom left (classic cmdline)
  {
    "folke/noice.nvim",
    opts = {
      cmdline = {
        enabled = true, -- Enable Noice cmdline
        view = "cmdline", -- Use the classic bottom cmdline view
      },
      messages = {
        enabled = true, -- Keep message handling enabled
      },
      popupmenu = {
        enabled = true, -- Keep fancy popupmenu
      },
    },
  },
}
