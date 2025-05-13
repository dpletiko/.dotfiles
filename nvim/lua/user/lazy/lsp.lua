return {
    "neovim/nvim-lspconfig",
    dependencies = {
        "tamago324/nlsp-settings.nvim",
        "stevearc/conform.nvim",
        "williamboman/mason.nvim",
        "williamboman/mason-lspconfig.nvim",
        "hrsh7th/cmp-nvim-lsp",
        "hrsh7th/cmp-nvim-lua",
        "hrsh7th/cmp-buffer",
        "hrsh7th/cmp-path",
        "hrsh7th/cmp-cmdline",
        "hrsh7th/nvim-cmp",
        "L3MON4D3/LuaSnip",
        "saadparwaiz1/cmp_luasnip",
        "j-hui/fidget.nvim",
    },

    config = function()
        require("conform").setup({
            formatters_by_ft = {
            }
        })
        local cmp = require('cmp')
        local cmp_lsp = require("cmp_nvim_lsp")
        local capabilities = vim.tbl_deep_extend(
            "force",
            {},
            vim.lsp.protocol.make_client_capabilities(),
            cmp_lsp.default_capabilities()
        )
        -- capabilities.textDocument.completion.completionItem.snippetSupport = true

        require("nlspsettings").setup({
            -- config_home = vim.fn.stdpath('config') .. '/nlsp-settings',
            local_settings_dir = ".vscode",
            local_settings_root_markers_fallback = { '.git' },
            append_default_schemas = true,
            loader = 'json'
        })

        require("fidget").setup({})
        require("mason").setup()
        require("mason-lspconfig").setup({
            -- automatic_enable = false,
            ensure_installed = {
                'ts_ls',
                'eslint',
                'lua_ls',
                'rust_analyzer',
                'intelephense',
                --'vuels',
                'volar',
                'ansiblels',
                'yamlls',
                'docker_compose_language_service',
                'pyright',
                'emmet_ls',
                'dockerls',
                -- 'emmet_language_server'
            },
            handlers = {
                function(server_name) -- default handler (optional)
                    require("lspconfig")[server_name].setup {
                        capabilities = capabilities
                    }
                end,

                ["lua_ls"] = function()
                    local lspconfig = require("lspconfig")
                    lspconfig.lua_ls.setup {
                        capabilities = capabilities,
                        settings = {
                            Lua = {
                                runtime = { version = "Lua 5.1" },
                                diagnostics = {
                                    globals = { "bit", "vim", "it", "describe", "before_each", "after_each" },
                                }
                            }
                        }
                    }
                end,

                ansiblels = function()
                    local lspconfig = require("lspconfig")
                    lspconfig.ansiblels.setup({
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
                end,

                intelephense = function()
                    local lspconfig = require("lspconfig")
                    lspconfig.intelephense.setup({
                      settings = {
                        intelephense = {
                          files = {
                            maxSize = 10000000
                          },
                          -- cmd = { 'intelephense', '--stdio' },
                          -- root_dir = function(pattern)
                          --   local cwd = vim.uv.cwd()
                          --   local root = util.root_pattern('composer.json', '.git')(pattern)
                          --
                          --   -- prefer cwd if root is a descendant
                          --   return util.path.is_descendant(cwd, root) and cwd or root
                          -- end,
              --        root_dir = require('lspconfig.util').root_pattern('composer.json', '.git'),
              --         environment = {
              --           phpVersion = "7.3"
              --         }
                        }
                      },
                    })
                end,

                ts_ls = function()
                    local vue_ts_plugin = require('mason-registry')
                        .get_package('vue-language-server')
                        :get_install_path()
                        .. '/node_modules/@vue/language-server'
                        .. '/node_modules/@vue/typescript-plugin'

                    local lspconfig = require("lspconfig")
                    lspconfig.ts_ls.setup({
                        -- detached = false,
                        init_options = {
                        plugins = {
                            {
                            name = '@vue/typescript-plugin',
                            location = vue_ts_plugin,
                            -- location = '/home/dpleti/.nvm/versions/node/v21.5.0/lib/node_modules/@vue/typescript-plugin',
                            -- languages = { 'typescript', 'javascript', 'vue' },
                            languages = { 'vue' },
                            },
                        },
                        },
                        filetypes = { 'typescript', 'javascript', 'javascriptreact', 'typescriptreact', 'vue' },
                        settings = {
                        documentFormatting = true
                        },
                    })
                end,

                volar = function()
                    local lspconfig = require("lspconfig")
                    lspconfig.volar.setup({
                        -- detached = false,
                        -- filetypes = {'typescript', 'javascript', 'javascriptreact', 'typescriptreact', 'vue', 'json'},
                        -- init_options = {
                        --   vue = {
                        --     hybridMode = false,
                        --   },
                        -- },
                        -- settings = {
                        --   volar = {
                        --
                        --   }
                        -- }
                    })
                end,

                emmet_ls = function()
                    local lspconfig = require("lspconfig")
                    lspconfig.emmet_ls.setup({
                        -- on_attach = on_attach,
                        capabilities = capabilities,
                        filetypes = { "css", "html", "javascript", "javascriptreact", "less", "sass", "scss", "svelte", "pug", "typescriptreact", "vue", "typescriptvue" },
                        init_options = {
                        html = {
                            options = {
                            -- For possible options, see: https://github.com/emmetio/emmet/blob/master/src/config.ts#L79-L267
                            ["bem.enabled"] = true,
                            },
                        },
                        }
                    })
                end,

                rust_analyzer = function()
                    local lspconfig = require("lspconfig")
                    lspconfig.rust_analyzer.setup({
                        -- on_attach = on_attach,
                        capabilities = capabilities,
                    })
                end,

                -- dartls = function()
                --     local lspconfig = require("lspconfig")
                --     lspconfig.dartls.setup({
                --         force_setup = true,
                --         on_attach = function()
                --         print('hello dartls')
                --         end,
                --         cmd = { 'dart',  '/home/dpleti/git/flutter/bin/cache/dart-sdk/bin/snapshots/analysis_server.dart.snapshot', '--lsp' },
                --         default_config = {
                --         cmd = { 'dart',  '/home/dpleti/git/flutter/bin/cache/dart-sdk/bin/snapshots/analysis_server.dart.snapshot', '--lsp' },
                --         filetypes = { 'dart' },
                --         root_dir = require('lspconfig.util').root_pattern 'pubspec.yaml',
                --         init_options = {
                --             onlyAnalyzeProjectsWithOpenFiles = true,
                --             suggestFromUnimportedLibraries = true,
                --             closingLabels = true,
                --             outline = true,
                --             flutterOutline = true,
                --         },
                --         settings = {
                --             dart = {
                --             completeFunctionCalls = true,
                --             showTodos = true,
                --             },
                --         },
                --         },
                --         docs = {
                --         description = [[
                --             https://github.com/dart-lang/sdk/tree/master/pkg/analysis_server/tool/lsp_spec
                --             Language server for dart.
                --         ]],
                --         default_config = {
                --             root_dir = [[root_pattern("pubspec.yaml")]],
                --         },
                --         },
                --     })
                -- end,

                -- vuels = function()
                --     local lspconfig = require("lspconfig")
                --     lspconfig.vuels.setup({
                --         settings = {
                --         vetur = {
                --             ignoreProjectWarning = true,

                --             completion = {
                --             autoImport = true,
                --             useScaffoldSnippets = true
                --             },
                --             format = {
                --             defaultFormatter = {
                --                 html = "none",
                --                 js = "prettier",
                --                 ts = "prettier",
                --             }
                --             },
                --             validation = {
                --             template = true,
                --             script = true,
                --             style = true,
                --             templateProps = true,
                --             interpolation = true
                --             },
                --             experimental = {
                --             templateInterpolationService = true
                --             }
                --         },
                --         }
                --     })
                -- end,
            }
        })

        local cmp_select = { behavior = cmp.SelectBehavior.Select }

        cmp.setup({
            snippet = {
                expand = function(args)
                    require('luasnip').lsp_expand(args.body) -- For `luasnip` users.
                end,
            },
            window = {
              completion = cmp.config.window.bordered(),
              documentation = cmp.config.window.bordered()
            },
            -- snippet = {
            --   expand = function(args)
            --     require('luasnip').lsp_expand(args.body) -- For `luasnip` users.
            --   end,
            -- },
            mapping = cmp.mapping.preset.insert({
                ['<C-p>'] = cmp.mapping.select_prev_item(cmp_select),
                ['<C-n>'] = cmp.mapping.select_next_item(cmp_select),
                -- ['<C-y>'] = cmp.mapping.confirm({ select = false }),
                ['<C-y>'] = cmp.mapping.confirm({
                    behavior = cmp.ConfirmBehavior.Insert, -- TODO: Verify my config value
                    select = true
                }),
                ["<C-Space>"] = cmp.mapping.complete(),

                -- go to next placeholder in the snippet
                ['<C-Tab>'] = cmp.mapping(function(fallback)
                    if cmp.visible() then
                        cmp.select_next_item()
                    elseif luasnip.expand_or_locally_jumpable() then
                        luasnip.expand_or_jump()
                    -- elseif has_words_before() then
                    --   cmp.complete()
                    else
                        fallback()
                    end
                    -- if luasnip.jumpable(1) then
                    --   luasnip.jump(1)
                    -- else
                    --   fallback()
                    -- end
                end, {'i', 's'}),

                -- go to previous placeholder in the snippet
                ['<S-Tab>'] = cmp.mapping(function(fallback)
                    if cmp.visible() then
                        cmp.select_prev_item()
                    elseif luasnip.jumpable(-1) then
                        luasnip.jump(-1)
                    else
                        fallback()
                    end
                end, {'i', 's'}),
            }),
            -- sources = cmp.config.sources({
            --   { name = 'supermanen' },
            --   { name = 'nvim_lsp' },
            --   { name = 'luasnip' }, -- For luasnip users.
            --   { name = 'buffer' },
            --   { name = 'emmet_ls' },
            -- }),
            sources = cmp.config.sources({
                { name = 'supermanen' },
                { name = 'nvim_lsp' },
                { name = 'luasnip' }, -- For luasnip users.
            }, {
                { name = 'buffer' },
                { name = 'emmet_ls' },
            })
        })

        vim.diagnostic.config({
            virtual_text = true, -- TODO: Verify my config value

            -- update_in_insert = true,
            float = {
                focusable = false,
                style = "minimal",
                border = "rounded",
                source = "always",
                header = "",
                prefix = "",
            },
        })
    end
}
