return {
  "NoahTheDuke/vim-just",
  {
    "nvim-treesitter/nvim-treesitter",
    opts = function(_, opts)
      vim.list_extend(opts.ensure_installed, {
        "just",
      })
    end,
  },
}
