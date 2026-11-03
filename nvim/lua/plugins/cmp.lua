return {
	"hrsh7th/nvim-cmp",
	version = false, -- last release is way too old
	event = "InsertEnter",
	dependencies = {
		"hrsh7th/cmp-nvim-lsp",
		"hrsh7th/cmp-nvim-lua",
		"hrsh7th/cmp-buffer",
		"hrsh7th/cmp-path",
		"hrsh7th/cmp-cmdline",
		"L3MON4D3/LuaSnip",
		"saadparwaiz1/cmp_luasnip",
	},
	opts = function()
		vim.api.nvim_set_hl(0, "CmpGhostText", { link = "Comment", default = true })

		local cmp = require("cmp")
		local luasnip = require("luasnip")
		local defaults = require("cmp.config.default")()
		local auto_select = true

		return {
			auto_brackets = {}, -- configure any filetype to auto add brackets
			completion = {
				completeopt = "menu,menuone,noinsert" .. (auto_select and "" or ",noselect"),
			},
			snippet = {
				expand = function(args)
					luasnip.lsp_expand(args.body) -- For `luasnip` users.
				end,
			},
			window = {
				-- completion = cmp.config.window.bordered(),
				-- documentation = cmp.config.window.bordered(),

				completion = {
					winhighlight = "Normal:Pmenu,FloatBorder:Pmenu,Search:None",
				},

				documentation = {
					border = "rounded",
					winhighlight = "FloatBorder:FloatBorder",
					winblend = vim.o.pumblend,
				},
			},
			preselect = auto_select and cmp.PreselectMode.Item or cmp.PreselectMode.None,
			mapping = cmp.mapping.preset.insert({
				["<C-n>"] = cmp.mapping.select_next_item({ behavior = cmp.SelectBehavior.Insert }),
				["<C-p>"] = cmp.mapping.select_prev_item({ behavior = cmp.SelectBehavior.Insert }),
				["<C-y>"] = cmp.mapping.confirm({
					-- behavior = cmp.ConfirmBehavior.Insert, -- TODO: Verify my config value
					select = true, -- Set `select` to `false` to only confirm explicitly selected items.
				}),
				["<C-e>"] = function(fallback)
					cmp.abort()
					fallback()
				end,
				-- ["<C-Space>"] = cmp.mapping.complete(),
				["<C-Space>"] = cmp.mapping(function(fallback)
					if cmp.visible() then
						cmp.confirm({ select = true }) -- same idea as <C-y>
					else
						cmp.complete()
					end
				end, { "i", "c" }),
			}),
			sources = cmp.config.sources({
				-- { name = "copilot" },
				{ name = "supermaven" },
				{
					name = "nvim_lsp",
					option = {
						php = {
							keyword_pattern = [=[[\%(\$\k*\)\|\k\+]]=],
						},
					},
					-- entry_filter = function(entry, ctx)
					-- 	-- block phpactor completions
					-- 	return entry.source.source.client.name ~= "phpactor"
					-- end,
				},
				{ name = "lazydev" },
				{ name = "luasnip" }, -- For luasnip users.
				{ name = "path" },
			}, {
				{ name = "buffer" },
			}),
			experimental = {
				-- only show ghost text when we show ai completions
				ghost_text = vim.g.ai_cmp and {
					hl_group = "CmpGhostText",
				} or false,
			},
			sorting = defaults.sorting,
		}
	end,
}
