---
vim.filetype.add({
  extension = {
    yaml = function()
      -- If there is a file named Chart.yaml in the current directory
      -- or parent directory, and the current file is under the templates directory
      -- set the type to helm
      if vim.fn.findfile("Chart.yaml", ".;") ~= "" and vim.fn.finddir("templates", ".;") ~= "" then
        return "helm"
      end
      -- If current file is under tasks directory or playbooks directory,
      -- set the type to yaml.ansible
      if vim.fn.finddir("tasks", ".;") ~= "" or vim.fn.finddir("playbooks", ".;") ~= "" then
        return "yaml.ansible"
      end
      return "yaml"
    end,
    tpl = "helm",
  },
  filename = {
    ["NOTES.txt"] = "helm",
  },
})

return {
  "towolf/vim-helm",
}
