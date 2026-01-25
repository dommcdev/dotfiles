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

-- Backup: markdown-preview.nvim
-- return {
--     "iamcco/markdown-preview.nvim",
--     cmd = { "MarkdownPreviewToggle", "MarkdownPreview", "MarkdownPreviewStop" },
--     ft = { "markdown" },
--     build = "cd app && npm install",
--     keys = {
--         { "<leader>mp", "<cmd>MarkdownPreviewToggle<CR>", desc = "Toggle Markdown Preview" },
--     },
--     init = function()
--         vim.g.mkdp_theme = "dark" -- or "light"
--     end,
-- }
