return {
	{
		"nvim-mini/mini.nvim",
		enabled = true,
		config = function()
			-- Statusline
			require("mini.statusline").setup({ use_icons = true })

			-- Autopairs
			require("mini.pairs").setup()
		end,
	},
}
