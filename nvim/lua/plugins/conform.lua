local php = require("utils.php")

return {
	"stevearc/conform.nvim",
	opts = {
		log_level = vim.log.levels.INFO,
		formatters = {
			pint = function(bufnr)
				return {
					condition = function(self, ctx)
						return php.satisfies_min_version("8.1")
					end,
				}
			end,

			php_cs_fixer = function(bufnr)
				return {
					condition = function(self, ctx)
						return php.satisfies_min_version("7.4")
					end,
				}
			end,
		},
		formatters_by_ft = {
			lua = { "stylua" },
			blade = { "blade-formatter" },
			vue = {
				"prettierd",
				-- "prettier",
				-- "oxfmt",
				-- "oxlint",
			},
			javascript = {
				"prettierd",
				-- "prettier",
				-- "oxfmt",
				-- "oxlint",
			},
			typescript = {
				"prettierd",
				-- "prettier",
				-- "oxfmt",
				-- "oxlint",
			},
			twig = {
				-- "twig-cs-fixer",
				"djlint",
			},
			json = {
				"prettierd",
				"prettier",
			},
			php = {
				"pint",
				"php_cs_fixer",
			},
		},
		default_format_opts = {
			stop_after_first = true,
			lsp_format = "fallback",
		},
	},
}
