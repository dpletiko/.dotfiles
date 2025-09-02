local Util = require("user.utils.path")

return {
    'nvim-lualine/lualine.nvim',
    dependencies = {
        'nvim-tree/nvim-web-devicons',
        "folke/trouble.nvim",
    },
    opts = {
        options = {
            icons_enabled = true,
            theme = 'auto',
            component_separators = { left = '', right = ''},
            section_separators = { left = '', right = ''},
            disabled_filetypes = {
                statusline = {},
                winbar = {},
            },
            ignore_focus = {},
            always_divide_middle = true,
            always_show_tabline = true,
            globalstatus = false,
            refresh = {
                statusline = 1000,
                tabline = 1000,
                winbar = 1000,
                refresh_time = 16, -- ~60fps
                events = {
                    'WinEnter',
                    'BufEnter',
                    'BufWritePost',
                    'SessionLoadPost',
                    'FileChangedShellPost',
                    'VimResized',
                    'Filetype',
                    'CursorMoved',
                    'CursorMovedI',
                    'ModeChanged',
                },
            }
        },
        sections = {
            lualine_a = {'mode'},
            lualine_b = {'branch', 'diff', 'diagnostics'},
            lualine_c = {
                -- 'filename'
                { Util.pretty_path() },
            },
            lualine_x = {'encoding', 'fileformat', 'filetype'},
            lualine_y = {'progress'},
            lualine_z = {'location'}
        },
        inactive_sections = {
            lualine_a = {},
            lualine_b = {},
            lualine_c = {'filename'},
            lualine_x = {'location'},
            lualine_y = {},
            lualine_z = {}
        },
        tabline = {
            lualine_a = {'buffers'},
            lualine_b = {},
            lualine_c = {},
            lualine_x = {},
            lualine_y = {},
            lualine_z = {'tabs'}
        },
        winbar = {},
        inactive_winbar = {},
        extensions = { "neo-tree", "lazy", "fzf", "fugitive", "mason", "nvim-dap-ui", "trouble" },
    },
    config = function(_, opts)
        -- do not add trouble symbols if aerial is enabled
        -- And allow it to be overriden for some buffer types (see autocmds)
        -- if vim.g.trouble_lualine and LazyVim.has("trouble.nvim") then
            local trouble = require("trouble")
            local symbols = trouble.statusline({
                -- mode = "symbols",
                mode = "lsp_document_symbols",
                groups = {},
                title = false,
                filter = {
                    range = true,
                },
                format = "{kind_icon}{symbol.name:Normal}",
                hl_group = "lualine_c_normal",
            })
            table.insert(opts.sections.lualine_c, 2, {
                symbols and symbols.get,
                cond = function()
                    return vim.b.trouble_lualine ~= false and symbols.has()
                end,
            })
        -- end

        local custom_gruvbox = require'lualine.themes.gruvbox_dark'
        -- custom_gruvbox.normal.c.bg = '#112233'
        custom_gruvbox.normal.c.bg = 'None'
        opts.options.theme = custom_gruvbox

        require('lualine').setup(opts)
    end,
}
