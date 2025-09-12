vim.api.nvim_create_autocmd("FileType", {
  pattern = { "c", "cpp", "java" },
  callback = function()
    vim.bo.shiftwidth = 4
    vim.bo.tabstop = 4
  end,
})
