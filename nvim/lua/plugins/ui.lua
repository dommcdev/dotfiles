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
}
