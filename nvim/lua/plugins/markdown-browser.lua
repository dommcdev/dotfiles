return {
  "toppair/peek.nvim",
  event = { "VeryLazy" },
  -- Only enable if Deno is available to avoid build errors
  enabled = vim.fn.executable("deno") == 1,
  build = "deno task --quiet build:fast",
  keys = {
    {
      "<leader>md",
      function()
        local peek = require("peek")
        if peek.is_open() then
          peek.close()
        else
          peek.open()
        end
      end,
      desc = "Toggle Peek Preview",
    },
  },
  opts = {
    theme = "dark",
    app = "browser",
  },
}
