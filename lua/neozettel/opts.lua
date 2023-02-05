local M = {}

local default_opts = {
    journal_dir = vim.fn.expand('~/Workspace/repos/journal'),
}

local opts

--- Setup the plugin configuration
--
-- Sets the options
--
-- @param config table with the schema
-- {
--   journal_dir = <path>,  -- Location of journal directory
-- }
---@param user_opts table to override the default options
function M.set(user_opts)
    print("Calling setup")
    if not opts then
        opts = vim.tbl_deep_extend("force", {}, default_opts)
    end
    opts = vim.tbl_deep_extend("force", opts, user_opts or {})
end

function M.get()
  if not opts then
    opts = vim.tbl_deep_extend("force", {}, default_opts)
  end
  return opts
end

return M
