local M = {}

local opts = require("neozettel.opts")
local utils = require("neozettel.utils")


function M.journal(timescale, date_title_fmt, steps)
    -- TODO check that timescale is one of 'day', 'week', 'month'
    local file_dir = rawget(opts.get().journal_dirs, timescale)
    if not file_dir then print("FATAL: Invalid timescale"); return end

    -- Create file directory if it doesn't exist
    utils.create_dir(file_dir)

    local steps = steps or 0 -- TODO

    local date_cmd = "date +'" .. date_title_fmt .. "'"
    local title = io.popen(date_cmd):read()
    local filename = utils.slugify(title)
    local file_path = file_dir .. '/' .. filename .. ".md"

    -- Open in vertical split and move cursor to end of file
    utils.edit_in_split(file_path, true, title)
end

-- TODO configurable title format
function M.daily()
    M.journal('day', "%Y-%m-%d: %a")
end

function M.weekly()
    M.journal('week', "%Y-W%W")
end

function M.monthly()
    M.journal('month', "%Y-M%m: %b")
end

return M
