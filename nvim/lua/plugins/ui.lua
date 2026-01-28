return {
  -- Disable bufferline (tab bar)
  { "akinsho/bufferline.nvim", enabled = false },
  -- Disable WhichKey
  { "folke/which-key.nvim", enabled = false },

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

  -- Configure Noice
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
      routes = {
        -- Filter out "yanked" notifications
        -- Note: The message is often "3 lines yanked" or similar, so we regex match
        {
          filter = {
            event = "msg_show",
            any = {
              { find = "%d+ lines yanked" },
            },
          },
          opts = { skip = true },
        },
      },
    },
  },
}
