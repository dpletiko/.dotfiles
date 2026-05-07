return {
	"neovim/nvim-lspconfig",
	dependencies = {
		"stevearc/conform.nvim",
		"mason-org/mason.nvim",
		"mason-org/mason-lspconfig.nvim",
		"WhoIsSethDaniel/mason-tool-installer.nvim",
		"hrsh7th/cmp-nvim-lsp",
		"hrsh7th/cmp-buffer",
		"hrsh7th/cmp-path",
		"hrsh7th/cmp-cmdline",
		"hrsh7th/nvim-cmp",
		"L3MON4D3/LuaSnip",
		"saadparwaiz1/cmp_luasnip",
		"j-hui/fidget.nvim",
	},
	config = function()
		local project_root = vim.fn.getcwd()
		local capabilities = vim.tbl_deep_extend(
			"force",
			{},
			vim.lsp.protocol.make_client_capabilities(),
			require("cmp_nvim_lsp").default_capabilities()
		)

		require("fidget").setup({
			notification = {
				window = {
					winblend = 0,
				},
			},
		})
		require("mason").setup()
		require("mason-lspconfig").setup({
			automatic_enable = {
				exclude = {
					-- 'phpactor'
				},
			},
			ensure_installed = {
				-- 'ts_ls',
				"eslint",
				"oxlint",
				"lua_ls",
				"stylua",
				"rust_analyzer",
				"intelephense",
				"phpactor",
				"ansiblels",
				"yamlls",
				"docker_compose_language_service",
				"pyright",
				"dockerls",
				"html",
				-- 'emmet_ls',
				"emmet_language_server",
				"vtsls",
				"vue_ls",
				"cssls",
				"somesass_ls",
				"tailwindcss",
				"twiggy_language_server",
			},
		})
		require("mason-tool-installer").setup({
			ensure_installed = {
				"oxfmt",
				"php-cs-fixer",
				"pint",
				"prettierd",
				"prettier",
				"twigcs",
				"twig-cs-fixer",
				"blade-formatter",
			},
		})

		-- vim.lsp.enable('oxfmt')
		-- vim.lsp.enable('oxlint')

		vim.lsp.config("lua_ls", {
			settings = {
				Lua = {
					runtime = { version = "Lua 5.1" },
					diagnostics = {
						globals = { "bit", "vim", "it", "describe", "before_each", "after_each" },
					},
				},
			},
		})

		vim.lsp.config("ansiblels", {
			settings = {
				ansible = {
					ansible = {
						path = "ansible",
					},
					executionEnvironment = {
						enabled = false,
					},
					python = {
						interpreterPath = "python",
					},
					validation = {
						enabled = true,
						lint = {
							enabled = true,
							path = "ansible-lint",
						},
					},
				},
			},
		})

		vim.lsp.config("intelephense", {
			settings = {
				intelephense = {
					files = {
						maxSize = 10000000,
					},
					diagnostics = {
						enabled = true,
					},
					environment = {
						includePaths = { project_root .. "/vendor" },
						-- phpVersion = "7.3"
					},
					-- format = {
					-- 	-- braces = "k&r",
					-- },
				},
			},
		})
		vim.lsp.config("phpactor", {
			cmd = { "phpactor", "language-server" },
			init_options = {
				["language_server_worse_reflection.inlay_hints.enable"] = true,
				["language_server_worse_reflection.inlay_hints.types"] = true,
				["language_server_worse_reflection.inlay_hints.params"] = true,

				["completion.dedupe"] = true,

				["language_server_psalm.enabled"] = false,

				["language_server_phpstan.enabled"] = false,
				["language_server_phpstan.bin"] = vim.fn.expand("~") .. "/.local/share/nvim/mason/bin/phpstan",
			},
			settings = {
				phpactor = {},
			},
		})
		vim.lsp.config("phpantom", {
			cmd = { vim.fn.expand("~") .. "/dev/phpantom_lsp/target/release/phpantom_lsp" },
			filetypes = { "php" },
			root_markers = { "composer.json", ".git" },
		})
		-- vim.lsp.enable('phpantom')

		vim.lsp.config("ts_ls", {
			settings = {
				["ts_ls"] = {
					-- detached = false,
					init_options = {
						plugins = {
							{
								name = "@vue/typescript-plugin",
								-- location = vim.fn.expand("~") .. "/.nvm/versions/node/v22.16.0/lib/node_modules/@vue/language-server",
								-- location = vim.fn.expand("~") .. "/.nvm/versions/node/v22.16.0/lib/node_modules/@vue/typescript-plugin",
								location = vim.fn.stdpath("data")
									.. "/mason/packages/vue-language-server/node_modules/@vue/typescript-plugin",
								languages = { "javascript", "typescript", "vue" },
							},
						},
					},
					filetypes = { "typescript", "javascript", "javascriptreact", "typescriptreact", "vue" },
					settings = {
						documentFormatting = true,
						typescript = {
							tsserver = {
								useSyntaxServer = false,
							},
							inlayHints = {
								includeInlayParameterNameHints = "all",
								includeInlayParameterNameHintsWhenArgumentMatchesName = true,
								includeInlayFunctionParameterTypeHints = true,
								includeInlayVariableTypeHints = true,
								includeInlayVariableTypeHintsWhenTypeMatchesName = true,
								includeInlayPropertyDeclarationTypeHints = true,
								includeInlayFunctionLikeReturnTypeHints = true,
								includeInlayEnumMemberValueHints = true,
							},
						},
					},
				},
			},
		})
		vim.lsp.config("vtsls", {
			capabilities = vim.tbl_deep_extend("force", capabilities, {
				textDocument = {
					foldingRange = {
						dynamicRegistration = false,
						lineFoldingOnly = false,
					},
				},
			}),
			settings = {
				vtsls = {
					enableMoveToFileCodeAction = true,
					experimental = {
						maxInlayHintLength = 30,
						completion = {
							enableServerSideFuzzyMatch = true,
						},
					},
					tsserver = {
						globalPlugins = {
							{
								name = "@vue/typescript-plugin",
								location = vim.fn.stdpath("data")
									.. "/mason/packages/vue-language-server/node_modules/@vue/language-server",
								-- location = vim.fn.expand("~") .. "/.nvm/versions/node/v22.16.0/lib/node_modules/@vue/language-server",
								languages = { "vue" },
								configNamespace = "typescript",
								enableForWorkspaceTypeScriptVersions = true,
							},
						},
					},
				},
				javascript = {
					updateImportsOnFileMove = "always",
				},
				typescript = {
					inlayHints = {
						parameterNames = { enabled = "literals" },
						parameterTypes = { enabled = true },
						variableTypes = { enabled = true },
						propertyDeclarationTypes = { enabled = true },
						functionLikeReturnTypes = { enabled = true },
						enumMemberValues = { enabled = true },
					},
					updateImportsOnFileMove = { enabled = "always" },
					suggest = {
						completeFunctionCalls = true,
					},
					preferences = {
						includeCompletionsForModuleExports = true,
						includeCompletionsForImportStatements = true,
						importModuleSpecifier = "non-relative",
					},
				},
			},
			filetypes = { "typescript", "javascript", "javascriptreact", "typescriptreact", "vue" },
		})
		vim.lsp.config("vue_ls", {
			settings = {
				vtsls = {
					tsserver = {
						globalPlugins = {
							{
								name = "@vue/typescript-plugin",
								location = vim.fn.stdpath("data")
									.. "/mason/packages/vue-language-server/node_modules/@vue/language-server",
								-- location = vim.fn.expand("~") .. "/.nvm/versions/node/v22.16.0/lib/node_modules/@vue/language-server",
								languages = { "vue" },
								configNamespace = "typescript",
								enableForWorkspaceTypeScriptVersions = true,
							},
						},
					},
				},
			},
		})

		vim.lsp.config("volar", {
			settings = {
				volar = {
					init_options = {
						vue = {
							hybridMode = false,
						},
					},
					settings = {
						typescript = {
							inlayHints = {
								enumMemberValues = {
									enabled = true,
								},
								functionLikeReturnTypes = {
									enabled = true,
								},
								propertyDeclarationTypes = {
									enabled = true,
								},
								parameterTypes = {
									enabled = true,
									suppressWhenArgumentMatchesName = true,
								},
								variableTypes = {
									enabled = true,
								},
							},
						},
					},
				},
			},
		})

		vim.lsp.config("emmet_language_server", {
			-- capabilities = capabilities,
			filetypes = {
				"css",
				"html",
				"javascript",
				"javascriptreact",
				"less",
				"sass",
				"scss",
				"svelte",
				"pug",
				"typescriptreact",
				"vue",
				"typescriptvue",
				"blade",
				"twig",
			},
			settings = {
				init_options = {
					includeLanguages = {
						blade = "html",
						twig = "html",
					},
					html = {
						options = {
							-- For possible options, see: https://github.com/emmetio/emmet/blob/master/src/config.ts#L79-L267
							["bem.enabled"] = true,
						},
					},
					showAbbreviationSuggestions = false,
					showExpandedAbbreviation = "always",
					showSuggestionsAsSnippets = true,
				},
			},
		})

		vim.lsp.config("html", {
			capabilities = capabilities,
			filetypes = { "html", "css", "javascript", "twig" },
			root_markers = { "package.json", ".git" },
			settings = {
				init_options = {
					configurationSection = { "html", "css", "javascript" },
					embeddedLanguages = {
						css = true,
						javascript = true,
					},
					provideFormatter = true,
				},
			},
		})

		vim.lsp.config("twiggy_language_server", {
			cmd = { vim.fn.stdpath("data") .. "/mason/bin/twiggy-language-server", "--stdio" },
			root_markers = { "composer.json", "package.json", ".git" },
			filetypes = { "twig" },
			-- root_dir = function(bufnr, on_dir)
			--     on_dir(vim.fn.getcwd())
			-- end,
			settings = {
				twiggy = {
					-- symfony = false,
					-- framework = "symfony", -- or 'craft', omit if plain Twig
					-- phpExecutable = "/usr/bin/php", -- adjust to your path
					-- symfonyConsolePath = "bin/console",
					diagnostics = {
						twigCsFixer = true,
					},
				},
				twiggy_language_server = {
					diagnostics = {
						enable = true,
					},
				},
			},
		})

		vim.diagnostic.config({
			virtual_text = true, -- TODO: Verify my config value

			-- update_in_insert = true,
			float = {
				focusable = false,
				style = "minimal",
				border = "rounded",
				-- source = "always",
				source = true,
				header = "",
				prefix = "",
			},
		})

		vim.lsp.util.stylize_markdown = function(bufnr, contents, opts)
			contents = vim.lsp.util._normalize_markdown(contents, {
				width = vim.lsp.util._make_floating_popup_size(contents, opts),
			})

			vim.bo[bufnr].filetype = "markdown"
			vim.treesitter.start(bufnr)
			vim.api.nvim_buf_set_lines(bufnr, 0, -1, false, contents)

			return contents
		end
	end,
}
