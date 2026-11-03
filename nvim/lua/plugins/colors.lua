function ColorMyPencils(color)
	vim.cmd.colorscheme(color or "gruvbox")

	vim.api.nvim_set_hl(0, "UfoFoldedFg", { bg = "none" })
	vim.api.nvim_set_hl(0, "UfoFoldedBg", { bg = "none" })

	-- vim.api.nvim_set_hl(0, "Normal", { bg = "none" })
	-- vim.api.nvim_set_hl(0, "NormalFloat", { bg = "none" })

	-- -- Lualine colors
	-- vim.api.nvim_set_hl(0, "StatusLine", { bg = "none" })
	-- vim.api.nvim_set_hl(0, "TabLine", { bg = "none" })
	-- vim.api.nvim_set_hl(0, "TabLineFill", { bg = "none" })
end

return {
	{
		"folke/tokyonight.nvim",
		lazy = false,
		opts = {},
	},
	{
		"ellisonleao/gruvbox.nvim",
		name = "gruvbox",
		opts = {
			terminal_colors = true,
			undercurl = true,
			underline = true,
			bold = true,
			italic = {
				strings = true,
				emphasis = true,
				comments = true,
				operators = false,
				folds = true,
			},
			strikethrough = true,
			invert_selection = false,
			invert_signs = false,
			invert_tabline = false,
			invert_intend_guides = false,
			inverse = true, -- invert background for search, diffs, statuslines and errors
			contrast = "", -- can be "hard", "soft" or empty string
			palette_overrides = {},
			overrides = {
				StatusLine = { bg = "none" },
				-- StatusLineNC = { bg = "none" },
				TabLine = { bg = "none" },
				TabLineFill = { bg = "none" },
				-- TabLineSel = { bg = "none" },

				Normal = { bg = "none" },
				NormalFloat = { bg = "none" },

				Pmenu = { bg = "none" },
				PmenuSel = { bg = "none" },
				PmenuBorder = { bg = "none" },

				NormalNC = { bg = "none" }, -- inactive normal windows
				FloatBorder = { bg = "none" }, -- float borders
				FloatTitle = { bg = "none" }, -- float titles

				-- DAP UI specific
				NvimDapUIFloats = { bg = "none" },
				DapUIFloats = { bg = "none" },
			},
			dim_inactive = false,
			transparent_mode = true,
			transparent_background = true,
		},
	},
	{
		"folke/tokyonight.nvim",
		opts = {
			-- your configuration comes here
			-- or leave it empty to use the default settings
			style = "storm", -- The theme comes in three styles, `storm`, `moon`, a darker variant `night` and `day`
			transparent = true, -- Enable this to disable setting the background color
			terminal_colors = true, -- Configure the colors used when opening a `:terminal` in Neovim
			styles = {
				-- Style to be applied to different syntax groups
				-- Value is any valid attr-list value for `:help nvim_set_hl`
				comments = { italic = false },
				keywords = { italic = false },
				-- Background styles. Can be "dark", "transparent" or "normal"
				sidebars = "dark", -- style for sidebars, see below
				floats = "dark", -- style for floating windows
			},
		},
	},
	{
		"rose-pine/neovim",
		name = "rose-pine",
		opts = {
			variant = "auto", -- auto, main, moon, or dawn
			dark_variant = "main", -- main, moon, or dawn
			dim_inactive_windows = false,
			extend_background_behind_borders = true,

			enable = {
				terminal = true,
				legacy_highlights = true, -- Improve compatibility for previous versions of Neovim
				migrations = true, -- Handle deprecated options automatically
			},

			styles = {
				bold = true,
				italic = true,
				transparency = true,
			},

			groups = {
				border = "muted",
				link = "iris",
				panel = "surface",

				error = "love",
				hint = "iris",
				info = "foam",
				note = "pine",
				todo = "rose",
				warn = "gold",

				git_add = "foam",
				git_change = "rose",
				git_delete = "love",
				git_dirty = "rose",
				git_ignore = "muted",
				git_merge = "iris",
				git_rename = "pine",
				git_stage = "iris",
				git_text = "rose",
				git_untracked = "subtle",

				h1 = "iris",
				h2 = "foam",
				h3 = "rose",
				h4 = "gold",
				h5 = "pine",
				h6 = "foam",
			},

			palette = {
				-- Override the builtin palette per variant
				-- moon = {
				--     base = '#18191a',
				--     overlay = '#363738',
				-- },
			},

			-- NOTE: Highlight groups are extended (merged) by default. Disable this
			-- per group via `inherit = false`
			highlight_groups = {
				-- Comment = { fg = "foam" },
				-- StatusLine = { fg = "love", bg = "love", blend = 15 },
				-- VertSplit = { fg = "muted", bg = "muted" },
				-- Visual = { fg = "base", bg = "text", inherit = false },
			},

			before_highlight = function(group, highlight, palette)
				-- Disable all undercurls
				-- if highlight.undercurl then
				--     highlight.undercurl = false
				-- end
				--
				-- Change palette colour
				-- if highlight.fg == palette.pine then
				--     highlight.fg = palette.foam
				-- end
			end,
		},
	},
	{
		"catppuccin/nvim",
		name = "catppuccin",
		priority = 1000,
		opts = {
			flavour = "auto", -- latte, frappe, macchiato, mocha
			background = { -- :h background
				light = "latte",
				dark = "mocha",
			},
			transparent_background = true, -- disables setting the background color.
			float = {
				transparent = false, -- enable transparent floating windows
				solid = false, -- use solid styling for floating windows, see |winborder|
			},
			-- term_colors = false, -- sets terminal colors (e.g. `g:terminal_color_0`)
			term_colors = true, -- sets terminal colors (e.g. `g:terminal_color_0`)
			dim_inactive = {
				enabled = false, -- dims the background color of inactive window
				shade = "dark",
				percentage = 0.15, -- percentage of the shade to apply to the inactive window
			},
			no_italic = false, -- Force no italic
			no_bold = false, -- Force no bold
			no_underline = false, -- Force no underline
			styles = { -- Handles the styles of general hi groups (see `:h highlight-args`):
				comments = { "italic" }, -- Change the style of comments
				conditionals = { "italic" },
				loops = {},
				functions = {},
				keywords = {},
				strings = {},
				variables = {},
				numbers = {},
				booleans = {},
				properties = {},
				types = {},
				operators = {},
				-- miscs = {}, -- Uncomment to turn off hard-coded styles
			},
			lsp_styles = { -- Handles the style of specific lsp hl groups (see `:h lsp-highlight`).
				virtual_text = {
					errors = { "italic" },
					hints = { "italic" },
					warnings = { "italic" },
					information = { "italic" },
					ok = { "italic" },
				},
				underlines = {
					errors = { "underline" },
					hints = { "underline" },
					warnings = { "underline" },
					information = { "underline" },
					ok = { "underline" },
				},
				inlay_hints = {
					background = true,
				},
			},
			color_overrides = {},
			custom_highlights = {},
			default_integrations = true,
			auto_integrations = true,
			-- auto_integrations = false,
			integrations = {
				cmp = true,
				gitsigns = true,
				nvimtree = true,
				notify = false,
				mini = {
					enabled = true,
					indentscope_color = "",
				},
				bufferline = true,
				neotree = true,
				fidget = true,
				harpoon = true,
				-- lualine = true,
				dap = true,
				dap_ui = true,
				ufo = true,
				-- For more plugins integrations please scroll down (https://github.com/catppuccin/nvim#integrations)
			},
		},
	},
}
