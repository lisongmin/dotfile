
-- LSP settings
local lspconfig = require('lspconfig')
local on_attach = function(_, bufnr)
  local opts = { noremap = true, silent = true }
  vim.api.nvim_buf_set_keymap(bufnr, 'n', 'gD', '<cmd>lua vim.lsp.buf.declaration()<CR>', opts)
  vim.api.nvim_buf_set_keymap(bufnr, 'n', 'gd', '<cmd>lua vim.lsp.buf.definition()<CR>', opts)
  vim.api.nvim_buf_set_keymap(bufnr, 'n', 'gi', '<cmd>lua vim.lsp.buf.implementation()<CR>', opts)
  vim.api.nvim_buf_set_keymap(bufnr, 'n', 'gr', '<cmd>lua vim.lsp.buf.references()<CR>', opts)
  vim.api.nvim_buf_set_keymap(bufnr, 'n', 'K', '<cmd>lua vim.lsp.buf.hover()<CR>', opts)
  vim.api.nvim_buf_set_keymap(bufnr, 'n', '<C-k>', '<cmd>lua vim.lsp.buf.signature_help()<CR>', opts)
  vim.api.nvim_buf_set_keymap(bufnr, 'n', '<leader>wa', '<cmd>lua vim.lsp.buf.add_workspace_folder()<CR>', opts)
  vim.api.nvim_buf_set_keymap(bufnr, 'n', '<leader>wr', '<cmd>lua vim.lsp.buf.remove_workspace_folder()<CR>', opts)
  vim.api.nvim_buf_set_keymap(bufnr, 'n', '<leader>wl', '<cmd>lua print(vim.inspect(vim.lsp.buf.list_workspace_folders()))<CR>', opts)
  vim.api.nvim_buf_set_keymap(bufnr, 'n', '<leader>D', '<cmd>lua vim.lsp.buf.type_definition()<CR>', opts)
  vim.api.nvim_buf_set_keymap(bufnr, 'n', '<leader>rn', '<cmd>lua vim.lsp.buf.rename()<CR>', opts)
  vim.api.nvim_buf_set_keymap(bufnr, 'n', '<leader>ca', '<cmd>lua vim.lsp.buf.code_action()<CR>', opts)
  vim.api.nvim_buf_set_keymap(bufnr, 'n', '<leader>so', [[<cmd>lua require('telescope.builtin').lsp_document_symbols()<CR>]], opts)
  vim.cmd [[ command! Format execute 'lua vim.lsp.buf.formatting()' ]]
end

-- completion
require'cmp'.setup {
  sources = {
    { name = 'nvim_lsp' }
  }
}

-- lsp capabilities
local capabilities = vim.lsp.protocol.make_client_capabilities()
capabilities = require('cmp_nvim_lsp').update_capabilities(capabilities)

-- flutter/dart language server
require("flutter-tools").setup{
    lsp = {
        on_attach = on_attach,
        capabilities = capabilities
    }
}

-- rust
require('lspconfig').rust_analyzer.setup({
  on_attach = on_attach,
  capabilities = capabilities
})

-- go
require('lspconfig').gopls.setup({
  on_attach = on_attach,
  capabilities = capabilities
})

-- python
require('lspconfig').pylsp.setup({
  on_attach = on_attach,
  capabilities = capabilities,
  settings = {
    configurationSources = {'flake8', 'pycodestyle'},
    plugins = {
      flake8 = { enabled = true },
      mypy = {enabled = false},
      isort = {enabled = false},
      yapf = {enabled = false},
      pylint = {enabled = true},
      pydocstyle = {enabled = false},
      mccabe = {enabled = false},
      preload = {enabled = false},
      rope_completion = {enabled = false}
    }
  }
})

-- javascript
require('lspconfig').rome.setup({})
require('lspconfig').tsserver.setup({
  on_attach = on_attach,
  capabilities = capabilities
})
