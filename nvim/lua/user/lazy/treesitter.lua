return {
	{
		"nvim-treesitter/nvim-treesitter",
		dependencies = {
			"JoosepAlviste/nvim-ts-context-commentstring",
		},
		lazy = false,
		build = ":TSUpdate",
		init = function()
			vim.api.nvim_create_autocmd("FileType", {
				-- pattern = { '<filetype>' },
				callback = function()
					-- Enable treesitter highlighting and disable regex syntax
					pcall(vim.treesitter.start)
					-- Enable treesitter-based indentation
					vim.bo.indentexpr = "v:lua.require'nvim-treesitter'.indentexpr()"

					vim.wo[0][0].foldexpr = "v:lua.vim.treesitter.foldexpr()"
					vim.wo[0][0].foldmethod = "expr"
				end,
			})
		end,
		config = function()
			require("nvim-treesitter").install({
				"javascript",
				"typescript",
				"c",
				"lua",
				"rust",
				"php",
				"phpdoc",
				"php_only",
				"json",
				"bash",
				"html",
				"scss",
				"css",
				"vue",
				"sql",
				"python",
				"vimdoc",
				"jsdoc",
				"blade",
				"dockerfile",
				"twig",
			})
		end,
	},
	{
		"nvim-treesitter/nvim-treesitter-textobjects",
		branch = "main",
		init = function()
			-- Disable entire built-in ftplugin mappings to avoid conflicts.
			-- See https://github.com/neovim/neovim/tree/master/runtime/ftplugin for built-in ftplugins.
			-- vim.g.no_plugin_maps = true

			-- Or, disable per filetype (add as you like)
			-- vim.g.no_python_maps = true
			-- vim.g.no_ruby_maps = true
			-- vim.g.no_rust_maps = true
			-- vim.g.no_go_maps = true
		end,
		config = function()
			-- configuration
			require("nvim-treesitter-textobjects").setup({
				highlight = {
					enable = true,
				},
				indent = {
					enable = true,
				},
				select = {
					enable = true,
					lookahead = true,
					keymaps = {
						["at"] = "@tag.outer",
						["it"] = "@tag.inner",

						["af"] = "@function.outer",
						["if"] = "@function.inner",

						["ac"] = "@class.outer",
						["ic"] = "@class.inner",
					},
					selection_modes = {
						["@parameter.outer"] = "v", -- charwise
						["@function.outer"] = "V", -- linewise
						-- ['@class.outer'] = '<c-v>', -- blockwise
					},
					include_surrounding_whitespace = false,
				},
				move = {
					enable = true,
					set_jumps = true,

					goto_next_start = {
						["]e"] = "@element.outer",
						["]t"] = "@tag.outer",
						["]m"] = "@function.outer",
						["]]"] = "@class.outer",
					},
					goto_next_end = {
						["]E"] = "@element.outer",
						["]T"] = "@tag.outer",
						["]M"] = "@function.outer",
						["]["] = "@class.outer",
					},
					goto_previous_start = {
						["[e"] = "@element.outer",
						["[t"] = "@tag.outer",
						["[m"] = "@function.outer",
						["[["] = "@class.outer",
					},
					goto_previous_end = {
						["[E"] = "@element.outer",
						["[T"] = "@tag.outer",
						["[M"] = "@function.outer",
						["[]"] = "@class.outer",
					},
				},
			})

			-- go to START of current Treesitter node (element/function/class/etc.)
			vim.keymap.set({ "n", "v" }, "gs", function()
				local node = vim.treesitter.get_node()
				if not node then
					return
				end

				while node do
					local type = node:type()

					if
						type == "element"
						or type == "jsx_element"
						or type == "function_declaration"
						or type == "function"
						or type == "method_definition"
						or type == "class_declaration"
						or type == "class"
					then
						local start_row, start_col = node:range()
						vim.api.nvim_win_set_cursor(0, { start_row + 1, start_col })
						return
					end

					node = node:parent()
				end
			end)

			-- go to END of current Treesitter node
			vim.keymap.set({ "n", "v" }, "ge", function()
				local node = vim.treesitter.get_node()
				if not node then
					return
				end

				while node do
					local type = node:type()

					if
						type == "element"
						or type == "jsx_element"
						or type == "function_declaration"
						or type == "function"
						or type == "method_definition"
						or type == "class_declaration"
						or type == "class"
					then
						local _, _, end_row, end_col = node:range()
						vim.api.nvim_win_set_cursor(0, { end_row + 1, end_col })
						return
					end

					node = node:parent()
				end
			end)

			vim.keymap.set({ "x", "o" }, "as", function()
				require("nvim-treesitter-textobjects.select").select_textobject("@local.scope", "locals")
			end)

			vim.keymap.set("n", "<leader>a", function()
				require("nvim-treesitter-textobjects.swap").swap_next("@parameter.inner")
			end)
			vim.keymap.set("n", "<leader>A", function()
				require("nvim-treesitter-textobjects.swap").swap_previous("@parameter.outer")
			end)

			vim.keymap.set({ "n", "x", "o" }, "]o", function()
				require("nvim-treesitter-textobjects.move").goto_next_start(
					{ "@loop.inner", "@loop.outer" },
					"textobjects"
				)
			end)
			vim.keymap.set({ "n", "x", "o" }, "]O", function()
				require("nvim-treesitter-textobjects.move").goto_next_end(
					{ "@loop.inner", "@loop.outer" },
					"textobjects"
				)
			end)
			vim.keymap.set({ "n", "x", "o" }, "[o", function()
				require("nvim-treesitter-textobjects.move").goto_previous_start(
					{ "@loop.inner", "@loop.outer" },
					"textobjects"
				)
			end)
			vim.keymap.set({ "n", "x", "o" }, "[O", function()
				require("nvim-treesitter-textobjects.move").goto_previous_end(
					{ "@loop.inner", "@loop.outer" },
					"textobjects"
				)
			end)

			vim.keymap.set({ "n", "x", "o" }, "]d", function()
				require("nvim-treesitter-textobjects.move").goto_next("@conditional.outer", "textobjects")
			end)
			vim.keymap.set({ "n", "x", "o" }, "[d", function()
				require("nvim-treesitter-textobjects.move").goto_previous("@conditional.outer", "textobjects")
			end)
		end,
	},
}
