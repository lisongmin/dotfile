
vim.g.ale_disable_lsp = 1
vim.g.ale_linters_explicit = 1
vim.g.ale_fix_on_save = 1
vim.g.ale_set_quickfix = 0
vim.g.ale_completion_enabled = 0
vim.g.ale_linters = {not_exists = ''}
vim.g.ale_fixers = {
  c = {'clang-format'},
  cpp = {'clang-format'},
  go = {'gofmt'},
  python = {'autopep8'},
  rust = {'rustfmt'},
  json = {'prettier'},
  bash = {'shfmt'},
}
vim.g.ale_fixers["*"] = {'trim_whitespace'}
