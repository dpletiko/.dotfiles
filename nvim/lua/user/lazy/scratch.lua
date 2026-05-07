return {
    dir = vim.fn.stdpath("config") .. "/lua/user/plugins/scratch",
    lazy = true,
    cmd = { "Scratch", "ScratchTemp", "ScratchSplit", "ScratchSplitTemp" },
    dependencies = { "nvim-telescope/telescope.nvim" },
    config = function()
        require("user.plugins.scratch.init")
    end,
    keys = {
        { "<leader>ss", "<cmd>Scratch<cr>", desc = "Open a scratch buffer" },
        { "<leader>st", "<cmd>ScratchTemp<cr>", desc = "Open a temporary scratch buffer" },
        { "<leader>sv", "<cmd>ScratchSplit<cr>", desc = "Open a scratch buffer in a vertical split" },
        { "<leader>stv", "<cmd>ScratchSplitTemp<cr>", desc = "Open a temporary scratch buffer in a vertical split" },
    },
}
