return {
  {
    "chomosuke/typst-preview.nvim",
    -- ft-only: defer setup/download to first typst file; no `keys` so it can't early-load elsewhere.
    ft = "typst",
    version = "1.*",
    opts = {},
    config = function(_, opts)
      require("typst-preview").setup(opts)

      vim.keymap.set("n", "<leader>tp", "<cmd>TypstPreviewToggle<CR>", {
        desc = "[T]ypst [P]review Toggle",
        silent = true,
      })
    end,
  },
}
