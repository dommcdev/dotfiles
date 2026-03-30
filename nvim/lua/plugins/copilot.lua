return {
  "zbirenbaum/copilot.lua",
  cmd = "Copilot",
  event = "InsertEnter",
  keys = {
    {
      "<leader>ct",
      function()
        -- Inline suggestions only (keeps Copilot LSP running). See :h copilot.txt
        -- copilot_suggestion_hidden / copilot_suggestion_auto_trigger.
        vim.g.copilot_inline_suggestions_off = not (vim.g.copilot_inline_suggestions_off == true)
        local off = vim.g.copilot_inline_suggestions_off == true
        for _, buf in ipairs(vim.api.nvim_list_bufs()) do
          if vim.api.nvim_buf_is_valid(buf) then
            vim.b[buf].copilot_suggestion_hidden = off
            vim.b[buf].copilot_suggestion_auto_trigger = off and false or nil
          end
        end
        if off then
          require("copilot.suggestion").dismiss()
        end
      end,
      mode = { "n", "i" },
      desc = "[Copilot] [T]oggle inline",
    },
  },
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
