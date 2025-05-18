return {
  "yetone/avante.nvim",
  event = "VeryLazy",
  lazy = false,
  version = false, -- set this if you want to always pull the latest change
  opts = {
    -- provider = "openrouter",
    provider = "copilot",
    copilot = {
      -- endpoint = "https://api.githubcopilot.com/",
      -- model = "claude-3.7-sonnet",
      model = "claude-3.5-sonnet",
      -- model = "gpt-4o-2024-08-06",
      -- model = "gemini-2.5-pro",
    },
    gemini = {
      -- endpoint = "https://generativelanguage.googleapis.com/v1beta/models",
      model = "gemini-2.5-pro-exp-03-25",
    },
    vendors = {
      openrouter = {
        __inherited_from = "openai",
        endpoint = "https://openrouter.ai/api/v1",
        api_key_name = "OPENROUTER_API_KEY",
        -- model = "google/gemini-2.5-pro-preview",
        model = "anthropic/claude-3.7-sonnet",
      },
    },
    mappings = {
      ask = "<leader>ab", -- ask
    },
    system_prompt = function()
      local ok, hub = pcall(require, "mcphub")
      if not ok then
        -- Return a default prompt if mcphub is not available
        return [[You are a helpful AI assistant for programming. Help the user write and understand code.]]
      end

      local hub_instance = hub.get_hub_instance()
      if not hub_instance then
        -- Return a default prompt if hub instance is not available
        return [[You are a helpful AI assistant for programming. Help the user write and understand code.]]
      end

      -- Get the active servers prompt, with error handling
      local success, prompt = pcall(function()
        return hub_instance:get_active_servers_prompt()
      end)

      if not success then
        -- Return a default prompt if getting servers prompt fails
        return [[You are a helpful AI assistant for programming. Help the user write and understand code.]]
      end

      return prompt
    end,
    disabled_tools = {},
    custom_tools = function()
      return require("mcphub.extensions.avante").mcp_tool()
    end,
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
    "williamboman/mcphub.nvim", -- Add this line
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
