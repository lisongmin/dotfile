return {
  "olimorris/codecompanion.nvim",
  dependencies = {
    "nvim-lua/plenary.nvim",
    "nvim-treesitter/nvim-treesitter",
  },
  config = function()
    require("codecompanion").setup({
      strategies = {
        chat = {
          adapter = "copilot",
        },
        inline = {
          adapter = "copilot",
        },
        agent = {
          adapter = "copilot",
        },
      },
    })
  end,
  keys = {
    { "<leader>cc", "<cmd>CodeCompanionChat<cr>", desc = "Code companion chat" },
    { "<leader>ca", "<cmd>CodeCompanionActions<cr>", desc = "Code companion actions" },
  },
}
