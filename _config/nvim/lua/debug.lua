-- 

local opts = { noremap = true, silent = true }
vim.api.nvim_buf_set_keymap('n', '<leader>dc', '<cmd>lua require"dap".continue()<CR>', opts) 
vim.api.nvim_buf_set_keymap('n', '<leader>dsv', '<cmd>lua require"dap".step_over()<CR>', opts) 
vim.api.nvim_buf_set_keymap('n', '<leader>dsi', '<cmd>lua require"dap".step_into()<CR>', opts) 
vim.api.nvim_buf_set_keymap('n', '<leader>dso', '<cmd>lua require"dap".step_out()<CR>', opts) 
vim.api.nvim_buf_set_keymap('n', '<leader>dtb', '<cmd>lua require"dap".toggle_breakpoint()<CR>', opts) 
vim.api.nvim_buf_set_keymap('n', '<leader>dsbr', '<cmd>lua require"dap".set_breakpoint(vim.fn.input("Breakpoint condition: "))<CR>', opts) 
vim.api.nvim_buf_set_keymap('n', '<leader>dsbm', '<cmd>lua require"dap".set_breakpoint(nil, nil, vim.fn.input("Log point message: "))<CR>', opts) 
vim.api.nvim_buf_set_keymap('n', '<leader>dro', '<cmd>lua require"dap".repl.open()<CR>', opts) 
vim.api.nvim_buf_set_keymap('n', '<leader>drl', '<cmd>lua require"dap".repl.run_last()<CR>', opts) 


require('dap-go').setup()
