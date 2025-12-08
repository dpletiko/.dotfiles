require("user.set")
require("user.remap")
require("user.lazy_init")

local augroup = vim.api.nvim_create_augroup
local TheGroup = augroup('TheGroup', {})

local autocmd = vim.api.nvim_create_autocmd
local yank_group = augroup('HighlightYank', {})

function R(name)
    require("plenary.reload").reload_module(name)
end

autocmd('TextYankPost', {
    group = yank_group,
    pattern = '*',
    callback = function()
        vim.hl.on_yank({
            higroup = 'IncSearch',
            timeout = 40,
        })
    end,
})

autocmd({"BufWritePre"}, {
    group = TheGroup,
    pattern = "*",
    command = [[%s/\s\+$//e]],
})

local IndentGruop = augroup("IndentSettings", {})
autocmd("FileType", {
  group = IndentGruop,
  nested = true,
  pattern = { "vue", "typescript", "javascript" },
  callback = function()
    vim.bo.tabstop = 2
    vim.bo.shiftwidth = 2
    vim.bo.softtabstop = 2
    vim.bo.expandtab = true
  end,
})

autocmd('LspAttach', {
    group = TheGroup,
    callback = function(e)
        local opts = { buffer = e.buf }
        vim.keymap.set("n", "gd", function() vim.lsp.buf.definition() end, opts)
        vim.keymap.set("n", "gD", function() vim.lsp.buf.declaration() end, opts)
        vim.keymap.set("n", "K", function() vim.lsp.buf.hover() end, opts)
        vim.keymap.set("n", "<leader>vws", function() vim.lsp.buf.workspace_symbol() end, opts)
        vim.keymap.set("n", "<leader>vd", function() vim.diagnostic.open_float() end, opts)
        vim.keymap.set("n", "<leader>vi", function() vim.diagnostic.implementation() end, opts)
        vim.keymap.set("n", "<leader>vca", function() vim.lsp.buf.code_action() end, opts)
        vim.keymap.set("n", "<leader>vrr", function() vim.lsp.buf.references() end, opts)

        vim.keymap.set("n", "<leader>vfa", function()
            vim.lsp.buf.code_action({
                context = {
                    only = { "source.fixAll", "source.organizeImports" },
                    diagnostics = vim.diagnostic.get(0), -- current buffer diagnostics
                },
                apply = true,
            })
        end, { desc = 'Fix all' })

        vim.keymap.set("n", "<leader>vrn", function() vim.lsp.buf.rename() end, opts)
        vim.keymap.set("n", "<F2>", function() vim.lsp.buf.rename() end, opts)

        vim.keymap.set("i", "<C-h>", function() vim.lsp.buf.signature_help() end, opts)
        vim.keymap.set("n", "[d", function() vim.diagnostic.goto_next() end, opts)
        vim.keymap.set("n", "]d", function() vim.diagnostic.goto_prev() end, opts)

        -- vim.keymap.set("n", "<leader>f", function() vim.lsp.buf.format({ async = true }) end, opts)
        vim.keymap.set("n", "<leader>f", function(args)
            require("conform").format({
                async = true,
                -- bufnr = args.buf,
                lsp_fallback = true
            })
        end, opts)
    end
})

local CloseWithQ = augroup("CloseWithQ", { clear = true })
autocmd('FileType', {
  group = CloseWithQ,
  pattern = {
    'PlenaryTestPopup',
    'checkhealth',
    'dbout',
    'gitsigns-blame',
    'grug-far',
    'help',
    'lspinfo',
    'neotest-output',
    'neotest-output-panel',
    'neotest-summary',
    'notify',
    'git',
    'qf',
    'spectre_panel',
    'startuptime',
    'tsplayground',
    'fugitive',
    'gitsigns',
    'git',
    'diff',
    'fugitiveblame',
    'fugitiveblamediff',
    'fugitivelog',
    'fugitivepatch',
    'fugitivepreview',
  },
  callback = function(event)
    vim.bo[event.buf].buflisted = false
    vim.schedule(function()
      vim.keymap.set('n', 'q', function()
        vim.cmd 'close'
        pcall(vim.api.nvim_buf_delete, event.buf, { force = true })
      end, {
        buffer = event.buf,
        silent = true,
        desc = 'Quit buffer',
      })
    end)
  end,
})

-- vim.g.node_host_prog = '~/.nvm/versions/node/v22.16.0/lib/node_modules'
vim.g.node_host_prog = '~/.nvm/versions/node/v22.16.0/bin/neovim-node-host'
vim.g.copilot_node_command = '~/.nvm/versions/node/v22.16.0/bin/node'

vim.g.python_recommended_style = 0

-- vim.g.netrw_keepdir = 0
vim.g.netrw_banner = 0
vim.g.netrw_winsize = 25
-- vim.g.netrw_liststyle = 3
vim.g.netrw_browse_split = 0
