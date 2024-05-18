---@type LazySpec
return {
  {
    "mikavilpas/yazi.nvim",
    dependencies = {
      "nvim-lua/plenary.nvim",
    },
    event = "VeryLazy",
    config = function(_, opts)
      require("yazi").setup(opts)
    end,
    keys = {
      {
        "-",
        function()
          require("yazi").yazi()
        end,
        { desc = "Open the file manager" },
      },
    },
    ---@type YaziConfig
    opts = {
      open_for_directories = true,
    },
  },
  {
    "nvim-neo-tree/neo-tree.nvim",
    enabled = false,
  },
}
