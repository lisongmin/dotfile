return {
  "yetone/avante.nvim",
  event = "VeryLazy",
  lazy = false,
  version = false, -- set this if you want to always pull the latest change
  opts = {
    provider = "copilot",
    copilot = {
      endpoint = "https://api.githubcopilot.com/",
      -- model = "claude-3.7-sonnet",
      model = "claude-3.5-sonnet",
      -- model = "gpt-4o-2024-08-06",
    },
    mappings = {
      ask = "<leader>ab", -- ask
    },
    custom_tools = {
      {
        name = "run_pytest",
        description = "Run python unittest and return results",
        param = {
          type = "table",
          fields = {
            {
              name = "manager",
              description = "The python package manager to use, e.g. 'uv', 'poetry'. Read the ./pyproject.toml to set it.",
              type = "string",
              optional = false,
            },
            {
              name = "target",
              description = "The testcase to run, should be the a relative path of file in ./tests",
              type = "string",
              optional = true,
            },
          },
        },
        returns = {
          {
            name = "result",
            description = "Result of the fetch",
            type = "string",
          },
          {
            name = "error",
            description = "Error message if the fetch was not successful",
            type = "string",
            optional = true,
          },
        },
        func = function(params, on_log, on_complete)
          local manager = params.manager
          if manager ~= "uv" and manager ~= "poetry" then
            return nil, string.format("Invalid package manager '%s'. Only 'uv' or 'poetry' are supported.", manager)
          end
          local target = params.target or ""
          local cmd = string.format("%s run pytest %s", manager, target)
          return vim.fn.system(cmd)
        end,
      },
      {
        name = "load_workflow",
        description = "When the user input contains a format '!{workflow_name}', and the workflow_file exist in one of ['workflows/{workflow_name}.md', '~/.config/nvim/workflows/{workflow_name}.md'], then trigger the workflow.",
        param = {
          type = "table",
          fields = {
            {
              name = "workflow_name",
              description = "The workflow name to load",
              type = "string",
              optional = false,
            },
          },
        },
        returns = {
          {
            name = "result",
            description = "The workflow content, You should do what the workflow says.",
            type = "string",
          },
          {
            name = "error",
            description = "Error message if the workflow file read failed",
            type = "string",
            optional = true,
          },
        },
        func = function(params, on_log, on_complete)
          local workflow_name = params.workflow_name
          on_log("Starting to load workflow: " .. workflow_name)

          -- Sanitize workflow name
          -- Remove any directory traversal attempts and special characters
          -- Only allow alphanumeric characters, hyphens, and underscores
          local sanitized_name = workflow_name:gsub("[^%w%-_]", "")

          -- Check if the name was modified during sanitization
          if sanitized_name ~= workflow_name then
            local error_msg = string.format(
              "Invalid workflow name '%s'. Only alphanumeric characters, hyphens, and underscores are allowed.",
              workflow_name
            )
            on_log("Error: " .. error_msg)
            return nil, error_msg
          end

          -- Check for empty name after sanitization
          if sanitized_name == "" then
            on_log("Error: Workflow name cannot be empty")
            return nil, "Workflow name cannot be empty"
          end

          -- Define possible workflow file paths
          local paths = {
            string.format("workflows/%s.md", sanitized_name),
            string.format("%s/.config/nvim/workflows/%s.md", os.getenv("HOME"), sanitized_name),
          }

          -- Try to read from either path
          for _, path in ipairs(paths) do
            on_log("Trying to read from: " .. path)
            local file = io.open(path, "r")
            if file then
              local content = file:read("*all")
              file:close()
              on_log("Successfully loaded workflow from: " .. path)
              return content
            end
          end

          -- If no file was found, return an error
          local error_msg =
            string.format("Workflow '%s' not found in either workflows/ or ~/.config/nvim/workflows/", sanitized_name)
          on_log("Error: " .. error_msg)
          return nil, error_msg
        end,
      },
    },
  },
  -- if you want to build from source then do `make BUILD_FROM_SOURCE=true`
  build = "make",
  -- build = "powershell -ExecutionPolicy Bypass -File Build.ps1 -BuildFromSource false" -- for windows
  dependencies = {
    "stevearc/dressing.nvim",
    "nvim-lua/plenary.nvim",
    "MunifTanjim/nui.nvim",
    --- The below dependencies are optional,
    "hrsh7th/nvim-cmp", -- autocompletion for avante commands and mentions
    "nvim-tree/nvim-web-devicons", -- or echasnovski/mini.icons
    "zbirenbaum/copilot.lua", -- for providers='copilot'
    {
      -- support for image pasting
      "HakonHarnes/img-clip.nvim",
      event = "VeryLazy",
      opts = {
        -- recommended settings
        default = {
          embed_image_as_base64 = false,
          prompt_for_file_name = false,
          drag_and_drop = {
            insert_mode = true,
          },
          -- required for Windows users
          use_absolute_path = true,
        },
      },
    },
    {
      -- Make sure to set this up properly if you have lazy=true
      "MeanderingProgrammer/render-markdown.nvim",
      opts = {
        file_types = { "markdown", "Avante" },
      },
      ft = { "markdown", "Avante" },
    },
  },
}
