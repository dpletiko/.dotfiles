return {
	"FeiyouG/commander.nvim",
	dependencies = {
		"nvim-telescope/telescope.nvim",
	},
	keys = {
		{ "<C-p>", "<CMD>Telescope commander<CR>", mode = "n" },
		{ "<leader>fc", "<CMD>Telescope commander<CR>", mode = "n" },
	},
	config = function()
		require("commander").setup({
			-- Specify what components are shown in the prompt;
			-- Order matters, and components may repeat
			components = {
				"DESC",
				"KEYS",
				-- "CMD",
				"CAT",
			},

			-- Specify by what components the commands is sorted
			-- Order does not matter
			sort_by = {
				"DESC",
				"KEYS",
				"CMD",
				"CAT",
			},

			-- Change the separator used to separate each component
			separator = " ",

			-- When set to true,
			-- The desc component will be populated with cmd if desc is empty or missing.
			auto_replace_desc_with_cmd = false,

			-- Default title of the prompt
			prompt_title = "Commander",

			integration = {
				telescope = {
					-- Set to true to use telescope instead of vim.ui.select for the UI
					enable = true,
					-- Can be any builtin or custom telescope theme
					theme = require("telescope.themes").commander,
				},
				lazy = {
					-- Set to true to automatically add all key bindings set through lazy.nvim
					enable = true,
					-- Set to true to use plugin name as category for each keybinding added from lazy.nvim
					set_plugin_name_as_cat = true,
				},
			},
		})
	end,
}
