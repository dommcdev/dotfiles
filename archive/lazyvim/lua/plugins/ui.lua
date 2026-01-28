return {
  -- Disable bufferline (tab bar)
  { "akinsho/bufferline.nvim", enabled = false },

  -- Disable WhichKey visual popup but keep plugin loaded
  {
    "folke/which-key.nvim",
    enabled = true, -- Must be true for deps
    event = "VeryLazy",
    opts = {
      -- Completely disable the automatic triggering
      triggers = {
        -- This empty table is the correct way to disable auto-triggers according to docs
      },
      plugins = {
        marks = false,     -- shows a list of your marks on ' and `
        registers = false, -- shows your registers on " in NORMAL or <C-r> in INSERT mode
        spelling = {
          enabled = false, -- enabling this will show WhichKey when pressing z= to select spelling suggestions
        },
        presets = {
          operators = false,    -- adds help for operators like d, y, ...
          motions = false,      -- adds help for motions
          text_objects = false, -- help for text objects triggered after entering an operator
          windows = false,      -- default bindings on <c-w>
          nav = false,          -- misc bindings to work with windows
          z = false,            -- bindings for folds, spelling and others prefixed with z
          g = false,            -- bindings for prefixed with g
        },
      },
    },
    keys = {
      -- Override default which-key toggle if you want
    },
  },

  -- Configure lualine to show modified status [+]
  {
    "nvim-lualine/lualine.nvim",
    opts = function(_, opts)
      opts.sections.lualine_c[4] = {
        "filename",
        path = 1, -- Relative path
        symbols = {
          modified = "[+]",
          readonly = "[-]",
          unnamed = "[No Name]",
          newfile = "[New]",
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
