return {
  "mbbill/undotree",
  keys = {
    { "<leader>ut", vim.cmd.UndotreeToggle, desc = "Toggle UndoTree" },
  },
  config = function()
    -- Persistent undo is already handled in core/options.lua
  end,
}
