return {
	{
		"nvim-mini/mini.nvim",
		enabled = true,
		config = function()
			-- Autopairs
			require("mini.pairs").setup()
		end,
	},
}
