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
    index_name = "index",
    index_new_links_anchor = "## Uncategorised",
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

-- TODO Use default fmt string if this check fails
local function date_format_is_valid(fmt_string, timescale)
    -- if all is present return true
    if string_contains_date_chars(fmt_string, {'s', 'x'}) then
        return true
    end
    -- if not year is present return false
    if not string_contains_date_chars(fmt_string, {'y', 'Y'}) then
        return false
    end

    local month_is_present = string_contains_date_chars(fmt_string, {'m', 'd', 'U', 'W'})
    local week_is_present = string_contains_date_chars(fmt_string, {'U', 'W', 'j'})
    local day_is_present = string_contains_date_chars(fmt_string, {'d', 'j', 'w'})

    local is_valid = false
    if timescale == "month" and month_is_present then
        is_valid = true
    elseif timescale == "week" and week_is_present or (day_is_present and month_is_present) then
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

function M.get_journal_dir(timescale)
    if not timescale then
        return table.concat({
            M.get().field_notes_path,
            M.get().journal_dir,
        }, '/')
    end

    if not require("field_notes.utils").is_timescale(timescale)
        then error("Invalid timescale")
    end
    local timescale_dir = M.get().journal_subdirs[timescale]
    return table.concat({
        M.get().field_notes_path,
        M.get().journal_dir,
        timescale_dir,
    }, '/')
end

function M.get_journal_title(timescale, timestamp)
    timestamp = timestamp or os.time()
    local date_title_fmt = M.get().journal_date_title_formats[timescale]
    return os.date(date_title_fmt, timestamp)
end

function M.get_notes_dir()
    return table.concat({
        M.get().field_notes_path,
        M.get().notes_dir,
    }, '/')
end

return M
