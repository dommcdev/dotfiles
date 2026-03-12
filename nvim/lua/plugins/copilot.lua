return {
  "zbirenbaum/copilot.lua",
  cmd = "Copilot", -- Lazy loads on the :Copilot command
  event = "InsertEnter", -- Lazy loads when you start typing (Official recommendation)
  config = function()
    require("copilot").setup({
      suggestion = {
        enabled = true,
        auto_trigger = true,
        hide_during_completion = true,
        debounce = 75,
        keymap = {
          accept = "<Tab>",
          next = "<M-]>",
          prev = "<M-[>",
          dismiss = "<C-]>",
        },
      },
      -- The panel is the official ghost-text preview window
      panel = { enabled = true },
    })
  end,
}
