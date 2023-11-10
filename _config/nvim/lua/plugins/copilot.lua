-- Add a log function
local function log_it(message)
  vim.notify(message)
end

-- This function checks if the matching_file matches
-- any of the patterns in the pattern_file.
-- It will return true if matched else false.
local function is_match_pattern(matching_file, pattern_file)
  -- Check if pattern_file exists
  if vim.fn.filereadable(pattern_file) == 1 then
    local patterns = vim.fn.readfile(pattern_file)
    local current_dir = vim.fn.fnamemodify(pattern_file, ":h")
    for _, pattern in ipairs(patterns) do
      -- trim the pattern first
      pattern = vim.trim(pattern)
      -- Ignore empty lines and lines that starts with '#'
      if pattern ~= "" and not vim.startswith(pattern, "#") then
        local full_pattern = current_dir .. (vim.startswith(pattern, "/") and pattern or "/" .. pattern)
        if vim.fn.match(matching_file, full_pattern) ~= -1 then
          return true
        end
      end
    end
  end
  return false
end

-- This function checks if the current file should be attached to copilot.
-- It checks for the existence of .copilotallow and .copilotignore files
-- in the current directory and all its parent directories.
--
-- * If .copilotallow file is found, it will check if the current file matches
-- any of the patterns in the .copilotallow file and return true if it matches.
-- * If .copilotignore file is found, it will check if the current file matches
-- any of the patterns in the .copilotignore file and return false if it matches.
-- * Repeat above two steps for all parent directories until the root directory is reached.
-- * If none of the above files are found, it will return true.
local function should_attach_copilot()
  local current_file = vim.fn.expand("%:p")
  if current_file == "" then
    return false, nil
  end
  -- Ignore directory
  if vim.fn.isdirectory(current_file) == 1 then
    return false, nil
  end

  local current_dir = vim.fn.fnamemodify(current_file, ":h")

  repeat
    local copilotallow = current_dir .. "/.copilotallow"
    if is_match_pattern(current_file, copilotallow) then
      return true, "Allow copilot by " .. copilotallow
    end

    local copilotignore = current_dir .. "/.copilotignore"
    if is_match_pattern(current_file, copilotignore) then
      return false, "Disallow copilot by " .. copilotignore
    end
    local old_current_dir = current_dir
    current_dir = vim.fn.fnamemodify(current_dir, ":h")
  until current_dir == "" or old_current_dir == current_dir

  return true, "Allow copilot by default"
end

return {
  {
    "zbirenbaum/copilot.lua",
    opts = {
      filetypes = {
        ["*"] = function()
          local disabled_filetypes = {
            "netrw",
          }

          local buf = vim.api.nvim_get_current_buf()
          if vim.b[buf].should_attach_copilot_flag == nil then
            -- Only attach to copilot if the current file is not ignored
            -- and filetype matched in list enabled_filetypes
            local allow_attach, reason = should_attach_copilot()
            if allow_attach then
              allow_attach = not vim.tbl_contains(disabled_filetypes, vim.bo.filetype)
              if not allow_attach then
                reason = reason .. "\nDisallow copilot by the filetype " .. vim.bo.filetype
              end
            end
            if reason ~= nil then
              log_it(reason)
            end
            vim.b[buf].should_attach_copilot_flag = allow_attach
          end

          return vim.b[buf].should_attach_copilot_flag
        end,
      },
    },
  },
}
