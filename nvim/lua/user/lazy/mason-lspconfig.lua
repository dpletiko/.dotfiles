return {
    "mason-org/mason-lspconfig.nvim",
    dependencies = {
        { "mason-org/mason.nvim", opts = {} },
        "neovim/nvim-lspconfig",
    },
    opts = {
        automatic_enable = true,
        ensure_installed = {
            -- 'ts_ls',
            'eslint',
            'lua_ls',
            'rust_analyzer',
            'intelephense',
            -- 'phpactor',
            'ansiblels',
            'yamlls',
            'docker_compose_language_service',
            'pyright',
            'dockerls',
            'html',
            -- 'emmet_ls',
            'emmet_language_server',
            'vtsls',
            'vue_ls',
            'cssls',
            'somesass_ls'
        },
    },
    config = function(_, opts)
        require('mason-lspconfig').setup(opts)
        -- lint/formatters:
        -- php-cs-fixer, pint, prettierd, prettier
    end
}
