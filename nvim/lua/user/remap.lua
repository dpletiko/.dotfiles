vim.g.mapleader = " "
vim.g.maplocalleader = "\\"

vim.keymap.set("n", "<leader>pv", vim.cmd.Ex)
vim.keymap.set("n", "<leader>pV", vim.cmd.Vex)

vim.keymap.set("v", "J", ":m '>+1<CR>gv=gv")
vim.keymap.set("v", "ALT-Down", ":m '>+1<CR>gv=gv")
vim.keymap.set("v", "K", ":m '<-2<CR>gv=gv")
vim.keymap.set("v", "ALT-Up", ":m '<-2<CR>gv=gv")

vim.keymap.set("n", "J", "mzJ`z")
vim.keymap.set("n", "<C-d>", "<C-d>zz")
vim.keymap.set("n", "<C-u>", "<C-u>zz")
vim.keymap.set("n", "n", "nzzzv")
vim.keymap.set("n", "N", "Nzzzv")

-- greatest remap ever
vim.keymap.set("x", "<leader>p", [["_dP]])

-- next greatest remap ever : asbjornHaland
vim.keymap.set({ "n", "v" }, "<leader>y", [["+y]])
vim.keymap.set("n", "<leader>Y", [["+Y]])

vim.keymap.set({ "n", "v" }, "<leader>d", "\"_d")

-- This is going to get me cancelled
vim.keymap.set("i", "<C-c>", "<Esc>")

vim.keymap.set("n", "Q", "<nop>")
vim.keymap.set("n", "<C-f>", "<cmd>silent !tmux new tmux-sessionizer<CR>")
-- vim.keymap.set("n", "<leader>fmt", vim.lsp.buf.format)

vim.keymap.set("n", "<C-j>", "<cmd>cnext<CR>zz")
vim.keymap.set("n", "<C-k>", "<cmd>cprev<CR>zz")
vim.keymap.set("n", "<leader>j", "<cmd>lnext<CR>zz")
vim.keymap.set("n", "<leader>k", "<cmd>lprev<CR>zz")

vim.keymap.set("n", "<leader>s", [[:%s/\<<C-r><C-w>\>/<C-r><C-w>/gI<Left><Left><Left>]])
vim.keymap.set("n", "<leader>x", "<cmd>!chmod +x %<CR>", { silent = true })

-- Write with sudo ":w!!"
vim.keymap.set("c", "w!!", "w !sudo tee % >/dev/null")

vim.keymap.set("n", "<leader><CR>", ":so $MYVIMRC<CR>")
-- vim.keymap.set("n", "<leader><leader>", function()
--     vim.cmd("so")
-- end)

-- QuickFix bindings
-- vim.keymap.set("n", "<C-j>", ":cnext<CR>")
-- vim.keymap.set("n", "<C-k>", ":cprev<CR>")
-- vim.keymap.set("<C-e>", ":copen<CR>")
-- vim.keymap.set("<C-x>", ":cclose<CR>")
-- vim.keymap.set("n","<C-l>", ":cex []<CR>")
vim.keymap.set("n", "<C-x>", function()
    local win = vim.api.nvim_get_current_win()
    local qf_winid = vim.fn.getqflist({ winid = 0 }).winid
    local action = qf_winid > 0 and 'cclose' or 'copen'
    vim.cmd(action)
end)



vim.keymap.set("n", "<leader>bp", '<cmd>bprevious<CR>', { desc = "Previous buffer" })
vim.keymap.set("n", "<leader>bn", '<cmd>bnext<CR>', { desc = "Next buffer" })
vim.keymap.set("n", "<leader>bf", '<cmd>bfirst<CR>', { desc = "First buffer" })
vim.keymap.set("n", "<leader>bl", '<cmd>blast<CR>', { desc = "Last buffer" })

-- Only enable OSC52 clipboard when SSHing
if os.getenv("SSH_CONNECTION") or os.getenv("SSH_CLIENT") then
  vim.g.clipboard = {
    name = 'OSC 52',
    copy = {
      ['+'] = require('vim.ui.clipboard.osc52').copy('+'),
      ['*'] = require('vim.ui.clipboard.osc52').copy('*'),
    },
    paste = {
      ['+'] = require('vim.ui.clipboard.osc52').paste('+'),
      ['*'] = require('vim.ui.clipboard.osc52').paste('*'),
    },
  }
end

