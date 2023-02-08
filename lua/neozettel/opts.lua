local M = {}

local default_opts = {
    note_dir = vim.fn.expand('~/journal'),
    journal_dirs = {
        day = vim.fn.expand('~/journal/daily'),
        week = vim.fn.expand('~/journal/weekly'),
        month = vim.fn.expand('~/journal/monthly'),
    },
    journal_date_title_formats = {
        day = "%Y-%m-%d: %a",
        week = "%Y-W%W",
        month =  "%Y-M%m: %b",
    }
}

local opts

--- Setup the plugin configuration
--
-- Sets the options
--
--TODO update docs
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
