return {
    'numToStr/Comment.nvim',
    opts = {
        toggler = {
            line = 'gcc',     -- Line-comment toggle key
            block = 'gbc',    -- Block-comment toggle key
        },
        opleader = {
            line = 'gc',      -- Operator-pending line-comment toggle key
            block = 'gb',     -- Operator-pending block-comment toggle key
        },
        mappings = {
            basic = true,     -- Basic keymaps like `gcc` and `gbc`
            extra = true,    -- Extra mappings like `gco`, `gcO`, `gcA`
        },
        pre_hook = require('ts_context_commentstring.integrations.comment_nvim').create_pre_hook(),
        -- pre_hook = function()
        --   return vim.bo.commentstring
        -- end,
    }
}