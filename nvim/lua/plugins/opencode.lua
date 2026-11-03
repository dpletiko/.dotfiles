return {
	"nickjvandyke/opencode.nvim",
	-- version = "*", -- Latest stable release
	dependencies = {
		{
			-- `snacks.nvim` integration is recommended, but optional
			---@module "snacks" <- Loads `snacks.nvim` types for configuration intellisense
			"folke/snacks.nvim",
			lazy = false,
			priority = 1000, -- Load before `opencode.nvim`
			-- optional = true,
			opts = {
				input = {}, -- Enhances `ask()`
				picker = { -- Enhances `select()`
					actions = {
						opencode_send = function(...)
							return require("opencode").snacks_picker_send(...)
						end,
					},
					win = {
						input = {
							keys = {
								["<a-a>"] = { "opencode_send", mode = { "n", "i" } },
							},
						},
					},
				},
			},
		},
	},
	config = function()
		local opencode_cmd = "opencode"

		---@type snacks.terminal.Opts
		local snacks_terminal_opts = {
			win = {
				position = "right",
				enter = false,
			},
		}
		---@type opencode.Opts
		vim.g.opencode_opts = {
			lsp = {
				enable = true,
			},
			server = {
				start = function()
					require("snacks.terminal").open(opencode_cmd, snacks_terminal_opts)
				end,
			},
		}

		vim.o.autoread = true -- Required for `opts.events.reload`

		-- Recommended/example keymaps
		vim.keymap.set({ "n", "x" }, "<leader>oa", function()
			require("opencode").ask("@this: ")
		end, { desc = "Ask OpenCode…" })
		vim.keymap.set({ "n", "x" }, "<leader>os", function()
			require("opencode").select()
		end, { desc = "Select OpenCode…" })

		vim.keymap.set({ "n", "x" }, "go", function()
			return require("opencode").operator("@this ")
		end, { desc = "Append range to OpenCode", expr = true })
		vim.keymap.set("n", "goo", function()
			return require("opencode").operator("@this ") .. "_"
		end, { desc = "Append line to OpenCode", expr = true })

		vim.keymap.set("n", "<S-C-u>", function()
			require("opencode").command("session.half.page.up")
		end, { desc = "Scroll OpenCode up" })
		vim.keymap.set("n", "<S-C-d>", function()
			require("opencode").command("session.half.page.down")
		end, { desc = "Scroll OpenCode down" })

		-- Can also leverage toggle functionality.
		-- If you use <leader> here, remove 't' — otherwise Neovim will add input delay to your <leader> when typing in the terminal to watch for the mapping.
		vim.keymap.set({ "n", "t" }, "<C-.>", function()
			require("snacks.terminal").toggle(opencode_cmd, snacks_terminal_opts)
		end, { desc = "Toggle OpenCode" })
	end,
}
