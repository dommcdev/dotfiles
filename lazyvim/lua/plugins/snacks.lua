return {
  "folke/snacks.nvim",
  opts = {
    -- Disable indent guides by default
    indent = { enabled = false },
    dashboard = {
      preset = {
        -- The default snacks.nvim header (Neovim logo)
        header = [[
███╗   ██╗███████╗██████╗ ██╗   ██╗██╗███╗   ███╗
████╗  ██║██╔════╝██╔══██╗██║   ██║██║████╗ ████║
██╔██╗ ██║█████╗  ██║  ██║██║   ██║██║██╔████╔██║
██║╚██╗██║██╔══╝  ██║  ██║╚██╗ ██╔╝██║██║╚██╔╝██║
██║ ╚████║███████╗██████╔╝ ╚████╔╝ ██║██║ ╚═╝ ██║
╚═╝  ╚═══╝╚══════╝╚═════╝   ╚═══╝  ╚═╝╚═╝     ╚═╝
]],
      },
    },
    scroll = {
      enabled = true,
      animate = {
        duration = { step = 15, total = 100 },
        easing = "linear",
      },
    },
    picker = {
      sources = {
        buffers = {
          on_show = function()
            vim.cmd.stopinsert()
          end,
        },
      },
    },
  },
  keys = {
    {
      "<leader>sf",
      function()
        Snacks.picker.files()
      end,
      desc = "Find Files",
    },
    {
      "<leader>,",
      function()
        Snacks.picker.buffers()
      end,
      desc = "Buffers",
    },
    {
      "<leader>n",
      function()
        Snacks.notifier.show_history()
      end,
      desc = "Notification History",
    },
    {
      "<leader>un",
      function()
        Snacks.notifier.hide()
      end,
      desc = "Dismiss All Notifications",
    },
  },
}
