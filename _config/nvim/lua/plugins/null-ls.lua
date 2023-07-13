return {
  "jose-elias-alvarez/null-ls.nvim",
  event = { "BufReadPre", "BufNewFile" },
  dependencies = { "mason.nvim" },
  opts = function()
    local nls = require("null-ls")
    return {
      root_dir = require("null-ls.utils").root_pattern(".null-ls-root", ".neoconf.json", "Makefile", ".git"),
      sources = {
        nls.builtins.formatting.fish_indent,
        nls.builtins.diagnostics.fish,

        nls.builtins.formatting.stylua,

        -- bash
        nls.builtins.formatting.shfmt.with({
          extra_args = function(params)
            if vim.api.nvim_buf_get_option(params.bufnr, "expandtab") then
              return {
                "--indent",
                vim.api.nvim_buf_get_option(params.bufnr, "shiftwidth"),
              }
            end
            return {}
          end,
        }),
        nls.builtins.diagnostics.shellcheck,

        -- yaml, json, markdown
        nls.builtins.formatting.prettier.with({
          filetypes = {
            "yaml",
            "json",
            "markdown",
          },
        }),
        nls.builtins.diagnostics.yamllint,

        -- nls.builtins.diagnostics.flake8,
      },
    }
  end,
}
