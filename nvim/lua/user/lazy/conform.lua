return {
    "stevearc/conform.nvim",
    dependencies = {
        "neovim/nvim-lspconfig",
        "mason-org/mason.nvim",
        "mason-org/mason-lspconfig.nvim"
    },
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
    }
}
