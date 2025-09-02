return {
    "tpope/vim-fugitive",
    config = function()
        vim.keymap.set("n", "<leader>gs", vim.cmd.Git, { noremap = true, silent = true, desc = "Git status" })
        vim.keymap.set('n', '<leader>gl', ':Git log<CR>', { noremap = true, silent = true, desc = "Git log" })
        vim.keymap.set('n', '<leader>gL', ':GcLog<CR>', { noremap = true, silent = true, desc = "Git log" })

        vim.keymap.set("n", "<leader>df", function()
            local diff_found = false
            for _, win in ipairs(vim.api.nvim_tabpage_list_wins(0)) do
                -- local buf = vim.api.nvim_win_get_buf(win)
                if vim.wo[win].diff then
                    diff_found = true
                    -- close the diff window
                    vim.api.nvim_win_close(win, true)
                end
            end
            if not diff_found then
                vim.cmd("Gdiffsplit")
            end
        end, { noremap = true, silent = true, desc = "Toggle fugitive Gdiff" })

        local ThePrimeagen_Fugitive = vim.api.nvim_create_augroup("ThePrimeagen_Fugitive", {})

        local autocmd = vim.api.nvim_create_autocmd
        autocmd("BufWinEnter", {
            group = ThePrimeagen_Fugitive,
            pattern = "*",
            callback = function()
                if vim.bo.ft ~= "fugitive" then
                    return
                end

                local bufnr = vim.api.nvim_get_current_buf()
                local opts = { buffer = bufnr, remap = false }
                vim.keymap.set("n", "<leader>p", function()
                    vim.cmd.Git('push')
                end, { unpack(opts), desc = "Git push"})

                -- rebase always
                vim.keymap.set("n", "<leader>P", function()
                    vim.cmd.Git({ 'pull', '--rebase' })
                end, { unpack(opts), desc = "Git pull --rebase"})

                -- NOTE: It allows me to easily set the branch i am pushing and any tracking
                -- needed if i did not set the branch up correctly
                vim.keymap.set("n", "<leader>t", ":Git push -u origin ", { unpack(opts), desc = "Git push -u origin " });
            end,
        })


        vim.keymap.set("n", "gu", "<cmd>diffget //2<CR>")
        vim.keymap.set("n", "gh", "<cmd>diffget //3<CR>")
    end
}

