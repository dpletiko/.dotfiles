return {
	"github/copilot.vim",
	enabled = false,
	init = function()
		vim.g.copilot_no_tab_map = true

		vim.keymap.set("i", "<S-Tab>", 'copilot#Accept("\\<CR>")', {
			expr = true,
			replace_keycodes = false,
			silent = true,
		})

		-- vim.keymap.set("i", "<C-Space>", 'copilot#Accept("\\<CR>")', {
		--     expr = true,
		--     replace_keycodes = false,
		--     silent = true,
		-- })

		vim.keymap.set("i", "<C-L>", "<Plug>(copilot-accept-word)")
	end,
}
