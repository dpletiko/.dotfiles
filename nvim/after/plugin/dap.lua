local dap, dapui = require("dap"), require("dapui")

dap.listeners.after.event_initialized["dapui_config"] = function()
  dapui.open()
end
dap.listeners.before.event_terminated["dapui_config"] = function()
  dapui.close()
end
dap.listeners.before.event_exited["dapui_config"] = function()
  dapui.close()
end

vim.fn.sign_define('DapBreakpoint',{ text ='🟥', texthl ='', linehl ='', numhl =''})

vim.fn.sign_define('DapStopped',{ text ='▶️', texthl ='', linehl ='', numhl =''})


vim.keymap.set('n', '<leader>5', dap.continue)
vim.keymap.set('n', '<leader>10', dap.step_over)
vim.keymap.set('n', '<leader>11', dap.step_into)
vim.keymap.set('n', '<leader>12', dap.step_out)
vim.keymap.set('n', '<leader>b', dap.toggle_breakpoint)

vim.keymap.set('n', '<leader>dl', dap.run_last)
vim.keymap.set('n', '<leader>dr', dap.repl.open)


vim.keymap.set('n', '<leader>dt', dapui.toggle)

dapui.setup()
