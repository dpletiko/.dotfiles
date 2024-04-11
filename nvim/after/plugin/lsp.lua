local lsp = require("lsp-zero")
local nlspsettings = require("nlspsettings")

nlspsettings.setup({
  -- config_home = vim.fn.stdpath('config') .. '/nlsp-settings',
  local_settings_dir = ".vscode",
  local_settings_root_markers_fallback = { '.git' },
  append_default_schemas = true,
  loader = 'json'
})


local cmp_lsp = require('cmp_nvim_lsp')
local capabilities = vim.tbl_deep_extend(
  "force",
  {},
  vim.lsp.protocol.make_client_capabilities(),
  cmp_lsp.default_capabilities()
)

require('mason').setup({})
require('mason-lspconfig').setup({
  ensure_installed = {
    'tsserver',
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
  },
  handlers = {
    lsp.default_setup,

    -- function(server_name) -- default handler (optional)
    --
    --   require("lspconfig")[server_name].setup {
    --     capabilities = capabilities
    --   }
    -- end,

    ansiblels = function()
      require('lspconfig').ansiblels.setup({
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
      require('lspconfig').intelephense.setup({
        settings = {
          intelephense = {
            files = {
              maxSize = 10000000
            },
--        root_dir = require('lspconfig.util').root_pattern('composer.json', '.git'),
--         environment = {
--           phpVersion = "7.3"
--         }
          }
        },
      })
    end,

    tsserver = function()
      local vue_ts_plugin = require('mason-registry')
        .get_package('vue-language-server')
        :get_install_path()
      .. '/node_modules/@vue/language-server'
      .. '/node_modules/@vue/typescript-plugin'

      require('lspconfig').tsserver.setup({
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
      require('lspconfig').volar.setup({
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
      require('lspconfig').emmet_ls.setup({
        -- on_attach = on_attach,
        capabilities = capabilities,
        filetypes = { "css", "eruby", "html", "javascript", "javascriptreact", "less", "sass", "scss", "svelte", "pug", "typescriptreact", "vue" },
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

    -- dartls = function()
    --   require('lspconfig').dartls.setup({
    --     force_setup = true,
    --     on_attach = function()
    --       print('hello dartls')
    --     end,
    --     cmd = { 'dart',  '/home/dpleti/git/flutter/bin/cache/dart-sdk/bin/snapshots/analysis_server.dart.snapshot', '--lsp' },
    --     default_config = {
    --       cmd = { 'dart',  '/home/dpleti/git/flutter/bin/cache/dart-sdk/bin/snapshots/analysis_server.dart.snapshot', '--lsp' },
    --       filetypes = { 'dart' },
    --       root_dir = require('lspconfig.util').root_pattern 'pubspec.yaml',
    --       init_options = {
    --         onlyAnalyzeProjectsWithOpenFiles = true,
    --         suggestFromUnimportedLibraries = true,
    --         closingLabels = true,
    --         outline = true,
    --         flutterOutline = true,
    --       },
    --       settings = {
    --         dart = {
    --           completeFunctionCalls = true,
    --           showTodos = true,
    --         },
    --       },
    --     },
    --     docs = {
    --       description = [[
    --         https://github.com/dart-lang/sdk/tree/master/pkg/analysis_server/tool/lsp_spec
    --         Language server for dart.
    --       ]],
    --       default_config = {
    --         root_dir = [[root_pattern("pubspec.yaml")]],
    --       },
    --     },
    --   })
    -- end,

    -- vuels = function()
    --   require('lspconfig').vuels.setup({
    --     settings = {
    --       vetur = {
    --         ignoreProjectWarning = true,
    --
    --         completion = {
    --           autoImport = true,
    --           useScaffoldSnippets = true
    --         },
    --         format = {
    --           defaultFormatter = {
    --             html = "none",
    --             js = "prettier",
    --             ts = "prettier",
    --           }
    --         },
    --         validation = {
    --           template = true,
    --           script = true,
    --           style = true,
    --           templateProps = true,
    --           interpolation = true
    --         },
    --         experimental = {
    --           templateInterpolationService = true
    --         }
    --       },
    --     }
    --   })
    -- end,
  },
})


-- local has_words_before = function()
--     local line, col = unpack(vim.api.nvim_win_get_cursor(0))
--     return col ~= 0 and vim.api.nvim_buf_get_lines(0, line - 1, line, true)[1]:sub(col, col):match("%s") == nil
-- end

local cmp = require('cmp')
local luasnip = require('luasnip')
local cmp_select = {behavior = cmp.SelectBehavior.Select}

cmp.setup({
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
    ['<C-y>'] = cmp.mapping.confirm({ select = false }),
    ["<C-Space>"] = cmp.mapping.complete(),

    -- go to next placeholder in the snippet
    ['<Tab>'] = cmp.mapping(function(fallback)
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
  --   { name = 'nvim_lsp' },
  --   { name = 'luasnip' }, -- For luasnip users.
  -- }, {
  --   { name = 'buffer' },
  -- })
})

-- disable completion with tab
-- this helps with copilot setup
-- cmp_mappings['<Tab>'] = nil
-- cmp_mappings['<S-Tab>'] = nil


lsp.set_preferences({
    suggest_lsp_servers = false,
    -- sign_icons = {
    --   error = 'E',
    --   warn = 'W',
    --   hint = 'H',
    --   info = 'I'
    -- }
})

lsp.on_attach(function(client, bufnr)
  local opts = {buffer = bufnr}

  -- if client.name == "eslint" then
  --   vim.cmd.LspStop('eslint')
  --   return
  -- end

  if client.name == "intelephense" then
    -- insert line comment
    -- vim.keymap.set("n", "<leader>lc", "<S-v>:s/^/\\/\\/<CR>", opts)
    vim.keymap.set("n", "<leader>lc", "<S-i>// <Esc>", opts)
  end

  vim.keymap.set("n", "gd", vim.lsp.buf.definition, opts)
  vim.keymap.set("n", "gD", vim.lsp.buf.declaration, opts)
  vim.keymap.set("n", "K", vim.lsp.buf.hover, opts)
  vim.keymap.set("n", "<leader>vws", vim.lsp.buf.workspace_symbol, opts)
  vim.keymap.set("n", "<leader>vd", vim.diagnostic.open_float, opts)
  vim.keymap.set("n", "[d", vim.diagnostic.goto_next, opts)
  vim.keymap.set("n", "]d", vim.diagnostic.goto_prev, opts)
  vim.keymap.set("n", "<leader>vi", vim.lsp.buf.implementation, opts)
  vim.keymap.set("n", "<leader>vca", vim.lsp.buf.code_action, opts)
  vim.keymap.set("n", "<leader>vrr", vim.lsp.buf.references, opts)
  vim.keymap.set("n", "<leader>vrn", vim.lsp.buf.rename, opts)
  vim.keymap.set("n", "<leader>f", function()
    vim.lsp.buf.format({ async = true })
  end, opts)
  vim.keymap.set("i", "<C-h>", vim.lsp.buf.signature_help, opts)


  -- lsp.default_keymaps({buffer = bufnr})
end)

lsp.setup()

vim.diagnostic.config({
    virtual_text = true,
})

