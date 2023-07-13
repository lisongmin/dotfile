-- 
local opts = { noremap = true, silent = true }
vim.api.nvim_set_keymap('n', '<F9>', [[<cmd>lua require('dap').continue()<CR>]], opts) 
vim.api.nvim_set_keymap('n', '<F8>', [[<cmd>lua require('dap').step_over()<CR>]], opts) 
vim.api.nvim_set_keymap('n', '<F7>', [[<cmd>lua require('dap').step_into()<CR>]], opts) 
vim.api.nvim_set_keymap('n', 'db', [[<cmd>lua require('dap').toggle_breakpoint()<CR>]], opts) 
vim.api.nvim_set_keymap('n', 'dc', [[<cmd>lua require('dap').set_breakpoint(vim.fn.input("Breakpoint condition: "))<CR>]], opts) 
vim.api.nvim_set_keymap('n', 'do', [[<cmd>lua require"dap".repl.open()<CR>]], opts) 
vim.api.nvim_set_keymap('n', 'dr', [[<cmd>lua require"dap".repl.run()<CR>]], opts) 
vim.api.nvim_set_keymap('n', 'dl', [[<cmd>lua require"dap".repl.run_last()<CR>]], opts) 

-- go
-- require('dap-go').setup()

-- c/c++/rust
local dap = require('dap')
dap.adapters.lldb = {
  type = 'executable',
  command = '/usr/bin/lldb-vscode', -- pacman -S lldb
  name = 'lldb'
}

dap.configurations.cpp = {
  {
    name = 'freerdp',
    type = 'lldb',
    request = 'launch',
    program = 'client/X11/xfreerdp',
    cwd = '${workspaceFolder}',
    stopOnEntry = false,
    args = {'/u:u3k0agbb2', '/p:zSxeIkeTd4pLu2gfLMXb', '/v:192.168.122.234:8389'},
  },
  {
    name = 'Launch',
    type = 'lldb',
    request = 'launch',
    program = function()
      return vim.fn.input('Path to executable: ', vim.fn.getcwd() .. '/', 'file')
    end,
    cwd = '${workspaceFolder}',
    stopOnEntry = false,
    args = {},

    -- 💀
    -- if you change `runInTerminal` to true, you might need to change the yama/ptrace_scope setting:
    --
    --    echo 0 | sudo tee /proc/sys/kernel/yama/ptrace_scope
    --
    -- Otherwise you might get the following error:
    --
    --    Error on launch: Failed to attach to the target process
    --
    -- But you should be aware of the implications:
    -- https://www.kernel.org/doc/html/latest/admin-guide/LSM/Yama.html
    -- runInTerminal = false,
  },
}

-- If you want to use this for Rust and C, add something like this:
dap.configurations.c = dap.configurations.cpp
dap.configurations.rust = dap.configurations.cpp

