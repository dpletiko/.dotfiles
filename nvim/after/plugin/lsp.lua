local lsp = require("lsp-zero")
local nlspsettings = require("nlspsettings")

nlspsettings.setup({
  -- config_home = vim.fn.stdpath('config') .. '/nlsp-settings',
  local_settings_dir = ".vscode",
  local_settings_root_markers_fallback = { '.git' },
  append_default_schemas = true,
  loader = 'json'
})

lsp.preset("recommended")

lsp.ensure_installed({
    'tsserver',
    'eslint',
    'sumneko_lua',
    'rust_analyzer',
    'intelephense',
    --'vuels',
    'volar'
})

-- Fix Undefined global 'vim'
lsp.configure('sumneko_lua', {
    settings = {
      Lua = {
        diagnostics = {
          globals = { 'vim' }
        },
        workspace = {
          library = {
            [vim.fn.expand("$VIMRUNTIME/lua")] = true,
            [vim.fn.stdpath("config") .. "/lua"] = true,
          },
        },
      }
    }
})

-- Configure intelephense
lsp.configure('intelephense', {
    on_init = function(client)

    end,
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
    }
})

-- Configure tsserver
lsp.configure('tsserver', {
    detached = false,
    settings = {
      documentFormatting = true
    },
})

-- Configure vue
-- lsp.configure('vuels', {
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
-- })
lsp.configure('volar', {
    detached = false,
    settings = {
      volar = {

      }
    }
})

-- local has_words_before = function()
--     local line, col = unpack(vim.api.nvim_win_get_cursor(0))
--     return col ~= 0 and vim.api.nvim_buf_get_lines(0, line - 1, line, true)[1]:sub(col, col):match("%s") == nil
-- end

local cmp = require('cmp')
local luasnip = require('luasnip')
local cmp_select = {behavior = cmp.SelectBehavior.Select}
local cmp_mappings = lsp.defaults.cmp_mappings({
    ['<C-p>'] = cmp.mapping.select_prev_item(cmp_select),
    ['<C-n>'] = cmp.mapping.select_next_item(cmp_select),
    ['<C-y>'] = cmp.mapping.confirm({ select = true }),
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
})

-- disable completion with tab
-- this helps with copilot setup
-- cmp_mappings['<Tab>'] = nil
-- cmp_mappings['<S-Tab>'] = nil

lsp.setup_nvim_cmp({
    mapping = cmp_mappings
})

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
  local opts = {buffer = bufnr, remap = false}

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
end)

lsp.setup()

vim.diagnostic.config({
    virtual_text = true,
})

