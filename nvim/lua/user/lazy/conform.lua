local php = require("user.utils.php")

return {
    'stevearc/conform.nvim',
    opts = {
        log_level = vim.log.levels.INFO,
        formatters_by_ft = {
            vue = { "prettierd", "prettier" },
            typescript = { "prettierd", "prettier" },
            javascript = { "prettierd", "prettier" },
            php = function(bufnr)
                local conform = require("conform")
                local fmts = {}

                if conform.get_formatter_info("pint", bufnr).available then
                    if php.satisfies_min_version("8.1") then
                        table.insert(fmts, "pint")
                    end
                end

                if conform.get_formatter_info("php_cs_fixer", bufnr).available then
                    if php.satisfies_min_version("7.4") then
                        table.insert(fmts, "php_cs_fixer")
                    end
                end

                return fmts
            end,
        },
        default_format_opts = {
            stop_after_first = true,
            lsp_format = "fallback",
        },
    },
}
