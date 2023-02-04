local M = {}

local default_config = {
    journal_path = os.getenv("HOME") .. '/Workspace/repos/journal',
}

local config

--- Setup the plugin configuration
--
-- Sets the options
--
-- @param config table with the schema
-- {
--   journal_path = <path>,  -- Location of journal directory
-- }
---@param user_config table to override the default options
function M.setup(user_config)
    print("Calling setup")
    if not config then
        config = vim.tbl_deep_extend("force", {}, default_config)
    end
    config = vim.tbl_deep_extend("force", config, user_config or {})
end

function M.get_config()
  if not config then
    config = vim.tbl_deep_extend("force", {}, default_config)
  end
  return config
end

return M
