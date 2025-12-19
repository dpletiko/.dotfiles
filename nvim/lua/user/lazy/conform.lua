return {
    'stevearc/conform.nvim',
    opts = {
        log_level = vim.log.levels.DEBUG,
        formatters_by_ft = {
            -- Use a sub-list to run only the first available formatter
            vue = { "prettierd", "prettier" },
            typescript = { "prettierd", "prettier" },
            javascript = { "prettierd", "prettier" },
            php = { "pint", "php_cs_fixer" },
        },
        stop_after_first = true,
    },
    default_format_opts = {
        lsp_format = "fallback",
    },
}
