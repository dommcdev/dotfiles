return {
  "ThePrimeagen/harpoon",
  branch = "harpoon2",
  dependencies = { "nvim-lua/plenary.nvim" },
  keys = {
    {
      "<leader>a",
      function()
        require("harpoon"):list():add()
      end,
      desc = "Harpoon Add File",
    },
    {
      "<C-e>",
      function()
        local harpoon = require("harpoon")
        harpoon.ui:toggle_quick_menu(harpoon:list())
      end,
      desc = "Harpoon Quick Menu",
    },
    {
      "<C-j>",
      function()
        require("harpoon"):list():select(1)
      end,
      desc = "Harpoon Select 1",
    },
    {
      "<C-k>",
      function()
        require("harpoon"):list():select(2)
      end,
      desc = "Harpoon Select 2",
    },
    {
      "<C-l>",
      function()
        require("harpoon"):list():select(3)
      end,
      desc = "Harpoon Select 3",
    },
    {
      "<C-h>",
      function()
        require("harpoon"):list():select(4)
      end,
      desc = "Harpoon Select 4",
    },
  },
}
