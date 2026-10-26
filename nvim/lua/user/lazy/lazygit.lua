return {
	"kdheepak/lazygit.nvim",
	lazy = true,
	cmd = {
		"LazyGit",
		"LazyGitConfig",
		"LazyGitCurrentFile",
		"LazyGitFilter",
		"LazyGitFilterCurrentFile",
	},
	-- optional for floating window border decoration
	dependencies = {
		"nvim-telescope/telescope.nvim",
		"nvim-lua/plenary.nvim",
	},
	-- setting the keybinding for LazyGit with 'keys' is recommended in
	-- order to load the plugin when the command is run for the first time
	keys = {
		{ "<leader>lg", "<cmd>LazyGit<cr>", desc = "LazyGit" },
	},
	config = function()
		require("telescope").load_extension("lazygit")

		-- vim.api.nvim_create_autocmd("BufEnter", {
		--     callback = function()
		--         require('lazygit.utils').project_root_dir()
		--     end,
		-- })

		-- require("telescope").extensions.lazygit.lazygit()
	end,
}
