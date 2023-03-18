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
    auto_add_links_to_journal = {
        day = false,
        week = false,
        month = false,
    },
    journal_link_anchor = "## Field notes",
    _vert = true,
}

local opts

local function string_contains_date_chars(fmt_string, char_list)
    local is_present = false
    for _, char in ipairs(char_list) do
        if string.match(fmt_string, '%%' .. char) then
            is_present = true
            break
        end
    end
    return is_present
end

local function date_format_is_valid(fmt_string, timescale)
    -- if all is present return true
    if string_contains_date_chars(fmt_string, {'c', 'D', 'F', 's', 'x'}) then
        return true
    end
    -- if not year is present return false
    if not string_contains_date_chars(fmt_string, {'G', 'g', 'y', 'Y'}) then
        return false
    end

    local month_is_present = string_contains_date_chars(fmt_string, {'b', 'B', 'h', 'm', 'd', 'e', 'j', 'U', 'V', 'W'})
    local week_is_present = string_contains_date_chars(fmt_string, {'U', 'V', 'W', 'd', 'e', 'j'})
    local day_is_present = string_contains_date_chars(fmt_string, {'a', 'A', 'd', 'e', 'j', 'u', 'w'})

    local is_valid = false
    if timescale == "month" and month_is_present then
        is_valid = true
    elseif timescale == "week" and week_is_present then
        is_valid = true
    elseif timescale == "day" and day_is_present then
        is_valid = true
    else
        error("Unexpected `timescale` given to `validate_date_format`.")
    end
    return is_valid
end

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
    for timescale, fmt in pairs(opts.journal_date_title_formats) do
        date_format_is_valid(timescale, fmt)
    end
end

function M.get()
  if not opts then
    opts = vim.tbl_deep_extend("force", {}, default_opts)
  end
  return opts
end

return M
