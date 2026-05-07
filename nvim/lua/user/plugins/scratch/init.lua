local pickers = require("telescope.pickers")
local finders = require("telescope.finders")
local conf = require("telescope.config").values
local actions = require("telescope.actions")
local action_state = require("telescope.actions.state")
local themes = require("telescope.themes")

local filetypes = {
    "php", "lua", "sql", "bash", "json",
    "javascript", "typescript", "markdown", "yaml",
    "html", "css",
}

local function open_scratch(ft, opts)
    opts = opts or {}
    if opts.split then
        vim.cmd("vnew")
    else
        vim.cmd("enew")
    end
    if opts.temp then
        vim.bo.buftype = "nofile"
        vim.bo.bufhidden = "wipe"
        vim.bo.swapfile = false
    end
    vim.bo.filetype = ft
end

local function pick_filetype(opts)
    opts = opts or {}
    local theme = themes.get_dropdown({ prompt_title = "Scratch Filetype", previewer = false })
    pickers.new(theme, {
        finder = finders.new_table({ results = filetypes }),
        sorter = conf.generic_sorter(theme),
        attach_mappings = function(_, map)
            actions.select_default:replace(function(prompt_bufnr)
                local selection = action_state.get_selected_entry()[1]
                actions.close(prompt_bufnr)
                open_scratch(selection, opts)
            end)
            return true
        end,
    }):find()
end

vim.api.nvim_create_user_command("Scratch", function() pick_filetype({}) end, {})
vim.api.nvim_create_user_command("ScratchTemp", function() pick_filetype({ temp = true }) end, {})
vim.api.nvim_create_user_command("ScratchSplit", function() pick_filetype({ split = true }) end, {})
vim.api.nvim_create_user_command("ScratchSplitTemp", function() pick_filetype({ split = true, temp = true }) end, {})
