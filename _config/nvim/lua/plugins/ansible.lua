return {
  { "pearofducks/ansible-vim" },
  { "ansible/ansible-language-server" },
  {
    "neovim/nvim-lspconfig",
    opts = {
      servers = {
        ansiblels = {
          cmd = { "ansible-language-server", "--stdio" },
        },
      },
    },
  },
  {
    "williamboman/mason.nvim",
    opts = function(_, opts)
      opts.ensure_installed = opts.ensure_installed or {}
      table.insert(opts.ensure_installed, "ansible-language-server")
      table.insert(opts.ensure_installed, "ansible-lint")
    end,
  },
}
