return {
    'numToStr/Comment.nvim',
    dependencies = {
        "nvim-treesitter/nvim-treesitter",
        "JoosepAlviste/nvim-ts-context-commentstring"
    },
    config = function()
        require('ts_context_commentstring').setup {
            enable_autocmd = false,
        }

        require("Comment").setup({
            padding = true,
            sticky = true,
            ignore = "^$",
            toggler = {
                line = "gcc",
                block = "gbc",
            },
            opleader = {
                line = "gc",
                block = "gb",
            },
            extra = {
                above = "gcO",
                below = "gco",
                eol = "gcA",
            },
            mappings = {
                basic = true,
                extra = true,
                extended = false,
            },
            pre_hook = require("ts_context_commentstring.integrations.comment_nvim").create_pre_hook(),
            post_hook = nil,
        })

        local ft = require("Comment.ft")
        ft.set("env", { "#%s" })

    end,
    -- opts = {
    --     toggler = {
    --         line = 'gcc',     -- Line-comment toggle key
    --         block = 'gbc',    -- Block-comment toggle key
    --     },
    --     opleader = {
    --         line = 'gc',      -- Operator-pending line-comment toggle key
    --         block = 'gb',     -- Operator-pending block-comment toggle key
    --     },
    --     mappings = {
    --         basic = true,     -- Basic keymaps like `gcc` and `gbc`
    --         extra = true,    -- Extra mappings like `gco`, `gcO`, `gcA`
    --     },
    --     pre_hook = require('ts_context_commentstring.integrations.comment_nvim').create_pre_hook(),
    --     -- pre_hook = function()
    --     --   return vim.bo.commentstring
    --     -- end,
    -- }
}
