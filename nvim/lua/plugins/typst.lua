return {
  {
    "chomosuke/typst-preview.nvim",
    ft = "typst",
    version = "1.*",
    build = function() require("typst-preview").update() end,
    keys = {
      { "<leader>tp", "<cmd>TypstPreviewToggle<CR>", desc = "[T]ypst [P]review Toggle" },
    },
  },
}
