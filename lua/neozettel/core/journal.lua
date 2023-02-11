local M = {}

local opts = require("neozettel.opts")
local utils = require("neozettel.utils")


function M.journal(keys)
    local timescale = keys.fargs[1]
    local steps = rawget(keys.fargs, 2) or 0

    -- TODO check that timescale is one of 'day', 'week', 'month'
    local timescale_dir = rawget(opts.get().journal_subdirs, timescale)
    if not timescale_dir then print("FATAL: Invalid timescale"); return end

    local date_title_fmt = rawget(opts.get().journal_date_title_formats, timescale)

    local file_dir = table.concat({
        opts.get().field_notes_path,
        opts.get().journal_dir,
        timescale_dir,
    }, '/')
    utils.create_dir(file_dir)

    steps = steps or 0
    local timedelta = tostring(steps) .. " " .. timescale .. "s"
    local date_cmd = "date +'" .. date_title_fmt .. "' -d '" .. timedelta .."'"

    local title = utils.quiet_run_shell(date_cmd)
    local filename = utils.slugify(title)
    local file_path = file_dir .. '/' .. filename .. ".md"

    -- Open in vertical split and move cursor to end of file
    utils.edit_in_split(file_path, true, title)
end

function M.day(steps)
    M.journal('day', "%Y-%m-%d: %a", steps)
end

function M.week(steps)
    M.journal('week', "%Y-W%W", steps)
end

function M.month(steps)
    M.journal('month', "%Y-M%m: %b", steps)
end

return M
