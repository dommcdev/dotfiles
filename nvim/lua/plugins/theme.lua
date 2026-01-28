return {
  {
    "catppuccin/nvim",
    name = "catppuccin",
    priority = 1000,
    opts = {
      flavour = "mocha",
      transparent_background = true,
      show_end_of_buffer = false,
      styles = {
        comments = { "italic" },
        conditionals = { "italic" },
      },
      integrations = {
        blink_cmp = true,
        gitsigns = true,
        mason = true,
        treesitter = true,
        snacks = true,
        mini = true,
      },
      -- Manually override highlights to ensure Snacks Picker is transparent
      custom_highlights = function(colors)
        return {
          -- Force standard floats to be transparent
          NormalFloat = { bg = "NONE" },
          FloatBorder = { bg = "NONE" },
          FloatTitle = { bg = "NONE" },

          -- Snacks Picker Components
          SnacksPicker = { bg = "NONE" },
          SnacksPickerNormal = { bg = "NONE" },
          SnacksPickerBorder = { bg = "NONE" },
          SnacksPickerTitle = { bg = "NONE" },
          SnacksPickerFooter = { bg = "NONE" },

          -- Input
          SnacksPickerInput = { bg = "NONE" },
          SnacksPickerInputNormal = { bg = "NONE" },
          SnacksPickerInputBorder = { bg = "NONE" },
          SnacksPickerInputTitle = { bg = "NONE" },

          -- List
          SnacksPickerList = { bg = "NONE" },
          SnacksPickerListNormal = { bg = "NONE" },
          SnacksPickerListBorder = { bg = "NONE" },
          SnacksPickerListCursorLine = { bg = "NONE" }, -- Optional: keep cursor line visible? usually fg/bg differs. keeping bg NONE might make it invisible if selection isn't handled. leaving default for cursorline is safer.

          -- Preview
          SnacksPickerPreview = { bg = "NONE" },
          SnacksPickerPreviewNormal = { bg = "NONE" },
          SnacksPickerPreviewBorder = { bg = "NONE" },
          SnacksPickerPreviewTitle = { bg = "NONE" },
        }
      end,
    },
  },
  {
    "LazyVim/LazyVim",
    opts = {
      colorscheme = "catppuccin",
    },
  },
}
