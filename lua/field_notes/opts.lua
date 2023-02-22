local M = {}

local default_opts = {
    field_notes_path = vim.fn.expand('~/field-notes'),
    notes_dir = 'notes',
    journal_dir = 'journal',
    journal_subdirs = {
        day = 'daily',
        week = 'weekly',
        month = 'monthly',
    },
    journal_date_title_formats = {
        day = "%Y-%m-%d: %a",
        week = "%Y-W%W",
        month =  "%Y-M%m: %b",
    },
    file_extension = 'md',
    journal_maps = {
        left = nil,
        down = nil,
        up = nil,
        right = nil,
    },
    _vert = true,
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
