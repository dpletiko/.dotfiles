return {
    "neovim/nvim-lspconfig",
    dependencies = {
        "stevearc/conform.nvim",
        "mason-org/mason.nvim",
        "mason-org/mason-lspconfig.nvim",
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
        -- capabilities.textDocument.completion.completionItem.snippetSupport = true

        require("fidget").setup({
            notification = {
                window = {
                    winblend = 0,
                },
            },
        })
        require("mason").setup()

        -- lint/formatters: php-cs-fixer, pint, prettierd, prettier
        require("mason-lspconfig").setup({
            automatic_enable = true,
            ensure_installed = {
                -- 'ts_ls',
                'eslint',
                'lua_ls',
                'rust_analyzer',
                'intelephense',
                'phpactor',
                'ansiblels',
                'yamlls',
                'docker_compose_language_service',
                'pyright',
                'dockerls',
                'html',
                -- 'emmet_ls',
                'emmet_language_server',
                'vtsls',
                'vue_ls',
                'cssls',
                'somesass_ls',
                'tailwindcss'
            },
        })

        vim.lsp.config('lua_ls', {
            -- capabilities = capabilities,
            settings = {
                Lua = {
                    runtime = { version = "Lua 5.1" },
                    diagnostics = {
                        globals = { "bit", "vim", "it", "describe", "before_each", "after_each" },
                    }
                }
            }
        })

        vim.lsp.config('ansiblels', {
          settings = {
            ansible = {
              ansible = {
                path = "ansible"
              },
              executionEnvironment = {
                enabled = false
              },
              python = {
                interpreterPath = "python"
              },
              validation = {
                enabled = true,
                lint = {
                  enabled = true,
                  path = "ansible-lint"
                }
              }
            },
          },
        })

        vim.lsp.config('intelephense', {
            -- cmd = {
            --     vim.fn.expand("~") .. "/.nvm/versions/node/v22.16.0/bin/node",
            --     vim.fn.exepath("intelephense"),
            --     -- 'intelephense',
            --     '--stdio'
            -- },
            settings = {
                intelephense = {
                    files = {
                        maxSize = 10000000
                    },
                    diagnostics = {
                        enabled = true
                    },
                    environment = {
                        includePaths = { project_root .. "/vendor" },
                        -- phpVersion = "7.3"
                    },
                    -- cmd = { 'intelephense', '--stdio' },
                    -- root_dir = function(pattern)
                    --   local cwd = vim.uv.cwd()
                    --   local root = util.root_pattern('composer.json', '.git')(pattern)
                    --
                    --   -- prefer cwd if root is a descendant
                    --   return util.path.is_descendant(cwd, root) and cwd or root
                    -- end,
                }
            },
        })
        vim.lsp.config('phpactor', {
            -- enabled = false,
            -- cmd = { 'phpactor', 'language-server', '-vvv' },
            init_options = {
                ['language_server_worse_reflection.inlay_hints.enable'] = true,
                ['language_server_worse_reflection.inlay_hints.types'] = true,
                ['language_server_worse_reflection.inlay_hints.params'] = true,

                ['completion.dedupe'] = true,

                ['language_server_psalm.enabled'] = false,
                ['language_server_phpstan.enabled'] = true,
            },
            settings = {
                phpactor = {
                }
            },
        })


        vim.lsp.config('ts_ls', {
            -- cmd = {
            --     -- vim.fn.expand("~") .. "/.nvm/versions/node/v22.16.0/bin/node",
            --     vim.fn.expand("~") .. "/.local/share/nvim/mason/packages/typescript-language-server/node_modules/.bin/typescript-language-server",
            --     "--stdio"
            -- },
            settings = {
                ['ts_ls'] = {
                    -- detached = false,
                    init_options = {
                        plugins = {
                            {
                                name = '@vue/typescript-plugin',
                                -- location = vim.fn.expand("~") .. "/.nvm/versions/node/v22.16.0/lib/node_modules/@vue/language-server",
                                -- location = vim.fn.expand("~") .. "/.nvm/versions/node/v22.16.0/lib/node_modules/@vue/typescript-plugin",
                                location = vim.fn.stdpath 'data' .. '/mason/packages/vue-language-server/node_modules/@vue/typescript-plugin',
                                languages = { 'javascript', 'typescript', 'vue' },
                            },
                        },
                    },
                    filetypes = { 'typescript', 'javascript', 'javascriptreact', 'typescriptreact', 'vue' },
                    settings = {
                        documentFormatting = true,
                        typescript = {
                            tsserver = {
                                useSyntaxServer = false,
                            },
                            inlayHints = {
                                includeInlayParameterNameHints = 'all',
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
                }
            },
        })
        vim.lsp.config('vtsls', {
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
                                name = '@vue/typescript-plugin',
                                location = vim.fn.stdpath('data') .. "/mason/packages/vue-language-server/node_modules/@vue/language-server",
                                -- location = vim.fn.expand("~") .. "/.nvm/versions/node/v22.16.0/lib/node_modules/@vue/language-server",
                                languages = { 'vue' },
                                configNamespace = 'typescript',
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
            filetypes = { 'typescript', 'javascript', 'javascriptreact', 'typescriptreact', 'vue' },
            -- init_options = {
            --     plugins = {
            --         {
            --             name = '@vue/typescript-plugin',
            --             -- location = vim.fn.stdpath('data') .. "/mason/packages/vue-language-server/node_modules/@vue/language-server",
            --             location = vim.fn.expand("~") .. "/.nvm/versions/node/v22.16.0/lib/node_modules/@vue/language-server",
            --             languages = { 'vue' },
            --             configNamespace = 'typescript',
            --             enableForWorkspaceTypeScriptVersions = true,
            --         },
            --     },
            -- },
        })
        vim.lsp.config('vue_ls', {
            -- cmd = {
            --     vim.fn.expand("~") .. "/.nvm/versions/node/v22.16.0/bin/node",
            --     vim.fn.expand("~") .. "/.nvm/versions/node/v22.16.0/lib/node_modules/@vue/language-server",
            --     "--stdio"
            -- },
            settings = {
                vtsls = {
                    tsserver = {
                        globalPlugins = {
                            {
                                name = '@vue/typescript-plugin',
                                location = vim.fn.stdpath('data') .. "/mason/packages/vue-language-server/node_modules/@vue/language-server",
                                -- location = vim.fn.expand("~") .. "/.nvm/versions/node/v22.16.0/lib/node_modules/@vue/language-server",
                                languages = { 'vue' },
                                configNamespace = 'typescript',
                                enableForWorkspaceTypeScriptVersions = true,
                            },
                        },
                    },
                },
            },
            --     on_init = function(client)
            --         client.handlers['tsserver/request'] = function(_, result, context)
            --             local clients = vim.lsp.get_clients({ bufnr = context.bufnr, name = 'vtsls' })
            --             if #clients == 0 then
            --                 vim.notify('Could not found `vtsls` lsp client, vue_lsp would not work without it.', vim.log.levels.ERROR)
            --                 return
            --             end
            --             local ts_client = clients[1]

            --             local param = unpack(result)
            --             local id, command, payload = unpack(param)
            --             ts_client:exec_cmd({
            --                 command = 'typescript.tsserverRequest',
            --                 arguments = {
            --                     command,
            --                     payload,
            --                 },
            --             }, { bufnr = context.bufnr }, function(_, r)
            --                     local response_data = { { id, r.body } }
            --                     ---@diagnostic disable-next-line: param-type-mismatch
            --                     client:notify('tsserver/response', response_data)
            --                 end)
            --         end
            --     end,
        })
        vim.lsp.config('volar', {
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

        vim.lsp.config('emmet_ls', {
            -- on_attach = on_attach,
            capabilities = capabilities,
            filetypes = { "css", "html", "javascript", "javascriptreact", "less", "sass", "scss", "svelte", "pug", "typescriptreact", "vue", "typescriptvue", "blade" },
            init_options = {
                html = {
                    options = {
                        -- For possible options, see: https://github.com/emmetio/emmet/blob/master/src/config.ts#L79-L267
                        ["bem.enabled"] = true,
                    },
                },
            }
        })

		capabilities.textDocument.completion.completionItem.snippetSupport = true
        vim.lsp.config('html', {
            -- cmd = {
            --     vim.fn.expand("~") .. "/.nvm/versions/node/v22.16.0/bin/node",
            --     vim.fn.expand("~") .. "/.nvm/versions/node/v22.16.0/lib/node_modules/vscode-langservers-extracted/bin/vscode-html-language-server",
            --     "--stdio"
            -- },
            -- on_attach = on_attach,
            capabilities = capabilities,
            filetypes = { "html", "blade" },
			init_options = {
				configurationSection = { "html", "css", "javascript" },
				embeddedLanguages = {
					css = true,
					javascript = true
				},
				provideFormatter = true
			}
		})

        --     handlers = {
        --         function(server_name) -- default handler (optional)
        --             require("lspconfig")[server_name].setup {
        --                 capabilities = capabilities
        --             }
        --         end,

        --         ["lua_ls"] = function()
        --             local lspconfig = require("lspconfig")
        --             lspconfig.lua_ls.setup {
        --                 capabilities = capabilities,
        --                 settings = {
        --                     Lua = {
        --                         runtime = { version = "Lua 5.1" },
        --                         diagnostics = {
        --                             globals = { "bit", "vim", "it", "describe", "before_each", "after_each" },
        --                         }
        --                     }
        --                 }
        --             }
        --         end,

        --         ansiblels = function()
        --             local lspconfig = require("lspconfig")
        --             lspconfig.ansiblels.setup({
        --               settings = {
        --                 ansible = {
        --                   ansible = {
        --                     path = "ansible"
        --                   },
        --                   executionEnvironment = {
        --                     enabled = false
        --                   },
        --                   python = {
        --                     interpreterPath = "python"
        --                   },
        --                   validation = {
        --                     enabled = true,
        --                     lint = {
        --                       enabled = true,
        --                       path = "ansible-lint"
        --                     }
        --                   }
        --                 },
        --               },
        --             })
        --         end,

        --         intelephense = function()
        --             local lspconfig = require("lspconfig")
        --             local project_root = vim.fn.getcwd()
        --             lspconfig.intelephense.setup({
        --                 settings = {
        --                     intelephense = {
        --                         files = {
        --                             maxSize = 10000000
        --                         },
        --                         diagnostics = {
        --                             enabled = true
        --                         },
        --                         environment = {
        --                             includePaths = { project_root .. "/vendor" },
        --                             -- phpVersion = "7.3"
        --                         },
        --                         -- cmd = { 'intelephense', '--stdio' },
        --                         -- root_dir = function(pattern)
        --                         --   local cwd = vim.uv.cwd()
        --                         --   local root = util.root_pattern('composer.json', '.git')(pattern)
        --                         --
        --                         --   -- prefer cwd if root is a descendant
        --                         --   return util.path.is_descendant(cwd, root) and cwd or root
        --                         -- end,
        --                     }
        --                 },
        --             })
        --         end,

        --         -- phpactor = function()
        --         --     local lspconfig = require("lspconfig")
        --         --     local project_root = vim.fn.getcwd()
        --         --     lspconfig.phpactor.setup({
        --         --         settings = {

        --         --         },
        --         --     })
        --         -- end,

        --         ts_ls = function()
        --             local vue_ts_plugin = require('mason-registry')
        --                 .get_package('vue-language-server')
        --                 :get_install_path()
        --                 .. '/node_modules/@vue/language-server'
        --                 .. '/node_modules/@vue/typescript-plugin'

        --             local lspconfig = require("lspconfig")
        --             lspconfig.ts_ls.setup({
        --                 -- detached = false,
        --                 init_options = {
        --                 plugins = {
        --                     {
        --                     name = '@vue/typescript-plugin',
        --                     location = vue_ts_plugin,
        --                     -- location = '/home/dpleti/.nvm/versions/node/v21.5.0/lib/node_modules/@vue/typescript-plugin',
        --                     -- languages = { 'typescript', 'javascript', 'vue' },
        --                     languages = { 'vue' },
        --                     },
        --                 },
        --                 },
        --                 filetypes = { 'typescript', 'javascript', 'javascriptreact', 'typescriptreact', 'vue' },
        --                 settings = {
        --                 documentFormatting = true
        --                 },
        --             })
        --         end,

        --         volar = function()
        --             local lspconfig = require("lspconfig")
        --             lspconfig.volar.setup({
        --                 -- detached = false,
        --                 -- filetypes = {'typescript', 'javascript', 'javascriptreact', 'typescriptreact', 'vue', 'json'},
        --                 -- init_options = {
        --                 --   vue = {
        --                 --     hybridMode = false,
        --                 --   },
        --                 -- },
        --                 -- settings = {
        --                 --   volar = {
        --                 --
        --                 --   }
        --                 -- }
        --             })
        --         end,

        --         emmet_ls = function()
        --             local lspconfig = require("lspconfig")
        --             lspconfig.emmet_ls.setup({
        --                 -- on_attach = on_attach,
        --                 capabilities = capabilities,
        --                 filetypes = { "css", "html", "javascript", "javascriptreact", "less", "sass", "scss", "svelte", "pug", "typescriptreact", "vue", "typescriptvue" },
        --                 init_options = {
        --                 html = {
        --                     options = {
        --                     -- For possible options, see: https://github.com/emmetio/emmet/blob/master/src/config.ts#L79-L267
        --                     ["bem.enabled"] = true,
        --                     },
        --                 },
        --                 }
        --             })
        --         end,

        --         rust_analyzer = function()
        --             local lspconfig = require("lspconfig")
        --             lspconfig.rust_analyzer.setup({
        --                 -- on_attach = on_attach,
        --                 capabilities = capabilities,
        --             })
        --         end,

        --         -- dartls = function()
        --         --     local lspconfig = require("lspconfig")
        --         --     lspconfig.dartls.setup({
        --         --         force_setup = true,
        --         --         on_attach = function()
        --         --         print('hello dartls')
        --         --         end,
        --         --         cmd = { 'dart',  '/home/dpleti/git/flutter/bin/cache/dart-sdk/bin/snapshots/analysis_server.dart.snapshot', '--lsp' },
        --         --         default_config = {
        --         --         cmd = { 'dart',  '/home/dpleti/git/flutter/bin/cache/dart-sdk/bin/snapshots/analysis_server.dart.snapshot', '--lsp' },
        --         --         filetypes = { 'dart' },
        --         --         root_dir = require('lspconfig.util').root_pattern 'pubspec.yaml',
        --         --         init_options = {
        --         --             onlyAnalyzeProjectsWithOpenFiles = true,
        --         --             suggestFromUnimportedLibraries = true,
        --         --             closingLabels = true,
        --         --             outline = true,
        --         --             flutterOutline = true,
        --         --         },
        --         --         settings = {
        --         --             dart = {
        --         --             completeFunctionCalls = true,
        --         --             showTodos = true,
        --         --             },
        --         --         },
        --         --         },
        --         --         docs = {
        --         --         description = [[
        --         --             https://github.com/dart-lang/sdk/tree/master/pkg/analysis_server/tool/lsp_spec
        --         --             Language server for dart.
        --         --         ]],
        --         --         default_config = {
        --         --             root_dir = [[root_pattern("pubspec.yaml")]],
        --         --         },
        --         --         },
        --         --     })
        --         -- end,

        --         -- vuels = function()
        --         --     local lspconfig = require("lspconfig")
        --         --     lspconfig.vuels.setup({
        --         --         settings = {
        --         --         vetur = {
        --         --             ignoreProjectWarning = true,

        --         --             completion = {
        --         --             autoImport = true,
        --         --             useScaffoldSnippets = true
        --         --             },
        --         --             format = {
        --         --             defaultFormatter = {
        --         --                 html = "none",
        --         --                 js = "prettier",
        --         --                 ts = "prettier",
        --         --             }
        --         --             },
        --         --             validation = {
        --         --             template = true,
        --         --             script = true,
        --         --             style = true,
        --         --             templateProps = true,
        --         --             interpolation = true
        --         --             },
        --         --             experimental = {
        --         --             templateInterpolationService = true
        --         --             }
        --         --         },
        --         --         }
        --         --     })
        --         -- end,
        --     }
        -- })

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
    end
}
