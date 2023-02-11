local M = {}

local opts = require("neozettel.opts")
local utils = require("neozettel.utils")


function M.journal(keys)
    local timescale = rawget(keys.fargs, 1)
    if not timescale then print("FATAL: Invalid timescale"); return end

    local steps = rawget(keys.fargs, 2) or 0

    local timescale_dir = opts.get().journal_subdirs[timescale]
    local date_title_fmt = opts.get().journal_date_title_formats[timescale]

    local file_dir = table.concat({
        opts.get().field_notes_path,
        opts.get().journal_dir,
        timescale_dir,
    }, '/')
    utils.create_dir(file_dir)

    local timedelta = tostring(steps) .. " " .. timescale .. "s"
    local date_cmd = "date +'" .. date_title_fmt .. "' -d '" .. timedelta .."'"

    local title = utils.quiet_run_shell(date_cmd)
    local filename = utils.slugify(title)
    local file_path = file_dir .. '/' .. filename .. '.' .. opts.get().file_extension

    vim.cmd.lcd(vim.fn.expand(opts.get().field_notes_path))
    utils.edit_note(file_path, title)
end

return M
