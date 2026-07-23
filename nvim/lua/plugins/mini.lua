return {
  {
    "nvim-mini/mini.nvim",
    enabled = false,
    config = function()
      -- Autopairs
      require("mini.pairs").setup()
    end,
  },
}
