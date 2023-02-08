local M = {}

local opts = require("neozettel.opts")
local utils = require("neozettel.utils")


function M.journal(timescale, date_title_fmt, steps)
    -- TODO check that timescale is one of 'day', 'week', 'month'
    local file_dir = rawget(opts.get().journal_dirs, timescale)
    if not file_dir then print("FATAL: Invalid timescale"); return end
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
