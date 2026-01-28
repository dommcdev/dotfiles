return {
  {
    "saghen/blink.cmp",
    opts = {
      keymap = {
        preset = "super-tab",
        ["<CR>"] = { "fallback" }, -- Disable Enter accepting completion
        ["<C-y>"] = { "select_and_accept" }, -- Use C-y to accept
      },
    },
  },
}
