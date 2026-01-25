return {
  "nvim-lualine/lualine.nvim",
  dependencies = { "nvim-tree/nvim-web-devicons" },
  config = function()
    -- Catppuccin Mocha Palette
    local colors = {
      blue      = "#89b4fa",
      green     = "#a6e3a1",
      mauve     = "#cba6f7",
      red       = "#f38ba8",
      peach     = "#fab387",
      text      = "#cdd6f4",
      surface0  = "#313244",
      mantle    = "#181825", -- Slightly darker than base (#1e1e2e)
    }

    local theme = {
      normal = {
        a = { fg = colors.mantle, bg = colors.blue, gui = "bold" },
        b = { fg = colors.text, bg = colors.surface0 },
        c = { fg = colors.text, bg = colors.mantle },
      },
      insert = { a = { fg = colors.mantle, bg = colors.green, gui = "bold" } },
      visual = { a = { fg = colors.mantle, bg = colors.mauve, gui = "bold" } },
      replace = { a = { fg = colors.mantle, bg = colors.red, gui = "bold" } },
      command = { a = { fg = colors.mantle, bg = colors.peach, gui = "bold" } },

      inactive = {
        a = { fg = colors.text, bg = colors.mantle },
        b = { fg = colors.text, bg = colors.mantle },
        c = { fg = colors.text, bg = colors.mantle },
      },
    }

    require("lualine").setup({
      options = {
        theme = theme,
        globalstatus = true,
        component_separators = { left = "|", right = "|" },
        section_separators = { left = "", right = "" },
      },
      sections = {
        lualine_a = {
          {
            "mode",
            fmt = function(str)
              return str:sub(1, 1)
            end,
          },
        },
        lualine_b = { "branch", "diff", "diagnostics" },
        lualine_c = { "filename" },
        lualine_x = { "encoding", "fileformat", "filetype" },
        lualine_y = { "progress" },
        lualine_z = { "location" },
      },
      inactive_sections = {
        lualine_a = {},
        lualine_b = {},
        lualine_c = { "filename" },
        lualine_x = { "location" },
        lualine_y = {},
        lualine_z = {},
      },
    })
  end,
}
