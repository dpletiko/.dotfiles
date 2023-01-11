local lsp = require("lsp-zero")

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
    settings = {
      intelephense = {
        files = {
          maxSize = 10000000
        },
        environment = {
          phpVersion = "7.3"
        }
      }
    }
})

-- Configure tsserver
lsp.configure('tsserver', {
    settings = {
      documentFormatting = true
    },
})

-- Configure vue
lsp.configure('vuels', {
    settings = {
      vetur = {
        ignoreProjectWarning = true,

        completion = {
          autoImport = true,
          useScaffoldSnippets = true
        },
        format = {
          defaultFormatter = {
            html = "none",
            js = "prettier",
            ts = "prettier",
          }
        },
        validation = {
          template = true,
          script = true,
          style = true,
          templateProps = true,
          interpolation = true
        },
        experimental = {
          templateInterpolationService = true
        }
      },
    }
})


local cmp = require('cmp')
local cmp_select = {behavior = cmp.SelectBehavior.Select}
local cmp_mappings = lsp.defaults.cmp_mappings({
    ['<C-p>'] = cmp.mapping.select_prev_item(cmp_select),
    ['<C-n>'] = cmp.mapping.select_next_item(cmp_select),
    ['<C-y>'] = cmp.mapping.confirm({ select = true }),
    ["<C-Space>"] = cmp.mapping.complete(),
})

-- disable completion with tab
-- this helps with copilot setup
cmp_mappings['<Tab>'] = nil
cmp_mappings['<S-Tab>'] = nil

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

  if client.name == "eslint" then
    vim.cmd.LspStop('eslint')
    return
  end

  vim.keymap.set("n", "gd", vim.lsp.buf.definition, opts)
  vim.keymap.set("n", "K", vim.lsp.buf.hover, opts)
  vim.keymap.set("n", "<leader>vws", vim.lsp.buf.workspace_symbol, opts)
  vim.keymap.set("n", "<leader>vd", vim.diagnostic.open_float, opts)
  vim.keymap.set("n", "[d", vim.diagnostic.goto_next, opts)
  vim.keymap.set("n", "]d", vim.diagnostic.goto_prev, opts)
  vim.keymap.set("n", "<leader>vi", vim.lsp.buf.implementation, opts)
  vim.keymap.set("n", "<leader>vca", vim.lsp.buf.code_action, opts)
  vim.keymap.set("n", "<leader>vrr", vim.lsp.buf.references, opts)
  vim.keymap.set("n", "<leader>vrn", vim.lsp.buf.rename, opts)
  vim.keymap.set("i", "<C-h>", vim.lsp.buf.signature_help, opts)
end)

lsp.setup()

vim.diagnostic.config({
    virtual_text = true,
})

