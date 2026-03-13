return {
  "zbirenbaum/copilot.lua",
  cmd = "Copilot",
  event = "InsertEnter",
  config = function()
    local copilot = require("copilot.suggestion")

    require("copilot").setup({
      suggestion = {
        enabled = true,
        auto_trigger = true,
        keymap = {
          accept = false, -- Handled by our custom Supertab below
          next = "<M-]>",
          prev = "<M-[>",
          dismiss = "<C-]>",
        },
      },
      -- Security: Don't attach to sensitive files
      filetypes = {
        markdown = true,
        help = false,
        gitcommit = false,
        sh = function()
          if string.match(vim.fs.basename(vim.api.nvim_buf_get_name(0)), "^%.env.*") then
            return false
          end
          return true
        end,
      },
    })

    -- THE SUPERTAB LOGIC
    vim.keymap.set("i", "<Tab>", function()
      if copilot.is_visible() then
        copilot.accept()
      else
        vim.api.nvim_feedkeys(vim.api.nvim_replace_termcodes("<Tab>", true, false, true), "n", false)
      end
    end, { desc = "Supertab" })
  end,
}
