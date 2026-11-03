return {
    "akinsho/bufferline.nvim",
    enabled = false,
    -- keys = {
    --     { "<leader>bp", "<Cmd>BufferLineTogglePin<CR>",            desc = "Toggle Pin" },
    --     { "<leader>bP", "<Cmd>BufferLineGroupClose ungrouped<CR>", desc = "Delete Non-Pinned Buffers" },
    --     { "<leader>br", "<Cmd>BufferLineCloseRight<CR>",           desc = "Delete Buffers to the Right" },
    --     { "<leader>bl", "<Cmd>BufferLineCloseLeft<CR>",            desc = "Delete Buffers to the Left" },
    --     { "<S-h>",      "<cmd>BufferLineCyclePrev<cr>",            desc = "Prev Buffer" },
    --     { "<S-l>",      "<cmd>BufferLineCycleNext<cr>",            desc = "Next Buffer" },
    --     { "[b",         "<cmd>BufferLineCyclePrev<cr>",            desc = "Prev Buffer" },
    --     { "]b",         "<cmd>BufferLineCycleNext<cr>",            desc = "Next Buffer" },
    --     { "[B",         "<cmd>BufferLineMovePrev<cr>",             desc = "Move buffer prev" },
    --     { "]B",         "<cmd>BufferLineMoveNext<cr>",             desc = "Move buffer next" },
    -- },
    opts = {

        options = {
            -- stylua: ignore
            -- close_command = function(n) Snacks.bufdelete(n) end,
            -- stylua: ignore
            -- right_mouse_command = function(n) Snacks.bufdelete(n) end,
            diagnostics = "nvim_lsp",
            always_show_bufferline = false,
            show_tab_indicators = true,
            enforce_regular_tabs = false,
            themable = true,
            indicator = {
                style = "underline",
            },
            separator_style = "thin",
            view = "multiwindow",
            -- max_name_length = 14,
            -- max_prefix_length = 13,
            -- tab_size = 10,

            -- diagnostics_indicator = function(_, _, diag)
            --     local icons = LazyVim.config.icons.diagnostics
            --     local ret = (diag.error and icons.Error .. diag.error .. " " or "")
            --         .. (diag.warning and icons.Warn .. diag.warning or "")
            --     return vim.trim(ret)
            -- end,
            offsets = {
                {
                    filetype = "neo-tree",
                    text = "Neo-tree",
                    highlight = "Directory",
                    text_align = "left",
                },
                -- {
                --     filetype = "snacks_layout_box",
                -- },
            },
            -- ---@param opts bufferline.IconFetcherOpts
            -- get_element_icon = function(opts)
            --     return LazyVim.config.icons.ft[opts.filetype]
            -- end,
        },
    },
    config = function(_, opts)
        opts.options.highlights = require("catppuccin.groups.integrations.bufferline").get_theme({})
		local C = require("catppuccin.palettes").get_palette()

   --      opts.highlights = {
			-- background = { bg = "NONE" },
			-- buffer_visible = { fg = C.surface1, bg = "NONE" },
			-- buffer_selected = { fg = C.text, bg = "NONE" }, -- current
			-- -- Duplicate
			-- duplicate_selected = { fg = C.text, bg = "NONE", },
			-- duplicate_visible = { fg = C.surface1, bg = "NONE", },
			-- duplicate = { fg = C.surface1, bg = "NONE", },
			-- -- tabs
			-- tab = { fg = C.surface1, bg = "NONE" },
			-- tab_selected = { fg = C.sky, bg = "NONE", bold = true },
			-- tab_separator = { bg = "NONE" },
			-- tab_separator_selected = { bg = "NONE" },

			-- tab_close = { fg = C.red, bg = "NONE" },
			-- indicator_visible = { fg = C.peach, bg = "NONE", },
			-- indicator_selected = { fg = C.peach, bg = "NONE", },
			-- -- separators
			-- separator = { bg = "NONE" },
			-- separator_visible = { bg = "NONE" },
			-- separator_selected = { bg = "NONE" },
			-- offset_separator = { bg = "NONE" },
			-- -- close buttons
			-- close_button = { fg = C.surface1, bg = "NONE" },
			-- close_button_visible = { fg = C.surface1, bg = "NONE" },
			-- close_button_selected = { fg = C.red, bg = "NONE" },
			-- -- Empty fill
			-- fill = { bg = "NONE" },
			-- -- Numbers
			-- numbers = { fg = C.subtext0, bg = "NONE" },
			-- numbers_visible = { fg = C.subtext0, bg = "NONE" },
			-- numbers_selected = { fg = C.subtext0, bg = "NONE", },
			-- -- Errors
			-- error = { fg = C.red, bg = "NONE" },
			-- error_visible = { fg = C.red, bg = "NONE" },
			-- error_selected = { fg = C.red, bg = "NONE", },
			-- error_diagnostic = { fg = C.red, bg = "NONE" },
			-- error_diagnostic_visible = { fg = C.red, bg = "NONE" },
			-- error_diagnostic_selected = { fg = C.red, bg = "NONE" },
			-- -- Warnings
			-- warning = { fg = C.yellow, bg = "NONE" },
			-- warning_visible = { fg = C.yellow, bg = "NONE" },
			-- warning_selected = { fg = C.yellow, bg = "NONE", },
			-- warning_diagnostic = { fg = C.yellow, bg = "NONE" },
			-- warning_diagnostic_visible = { fg = C.yellow, bg = "NONE" },
			-- warning_diagnostic_selected = { fg = C.yellow, bg = "NONE" },
			-- -- Infos
			-- info = { fg = C.sky, bg = "NONE" },
			-- info_visible = { fg = C.sky, bg = "NONE" },
			-- info_selected = { fg = C.sky, bg = "NONE", },
			-- info_diagnostic = { fg = C.sky, bg = "NONE" },
			-- info_diagnostic_visible = { fg = C.sky, bg = "NONE" },
			-- info_diagnostic_selected = { fg = C.sky, bg = "NONE" },
			-- -- Hint
			-- hint = { fg = C.teal, bg = "NONE" },
			-- hint_visible = { fg = C.teal, bg = "NONE" },
			-- hint_selected = { fg = C.teal, bg = "NONE", },
			-- hint_diagnostic = { fg = C.teal, bg = "NONE" },
			-- hint_diagnostic_visible = { fg = C.teal, bg = "NONE" },
			-- hint_diagnostic_selected = { fg = C.teal, bg = "NONE" },
			-- -- Diagnostics
			-- diagnostic = { fg = C.subtext0, bg = "NONE" },
			-- diagnostic_visible = { fg = C.subtext0, bg = "NONE" },
			-- diagnostic_selected = { fg = C.subtext0, bg = "NONE", },
			-- -- Modified
			-- modified = { fg = C.peach, bg = "NONE" },
			-- modified_visible = { fg = C.peach, bg = "NONE" },
			-- modified_selected = { fg = C.peach, bg = "NONE" },
   --      }

        -- opts.highlights = require("gruvbox.groups").bufferline(true),
        require("bufferline").setup(opts)
    end,
}
