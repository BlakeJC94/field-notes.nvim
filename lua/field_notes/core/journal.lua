local M = {}

local opts = require("field_notes.opts")
local utils = require("field_notes.utils")

function M.cur_buf_journal_timescale()
    local current_path = vim.api.nvim_buf_get_name(0)

    local journal_path = vim.fn.expand(opts.get().field_notes_path .. '/' .. opts.get().journal_dir)
    local journal_path_in_cur_path = string.find(current_path, journal_path, 1, true)
    if not journal_path_in_cur_path then return nil end

    for _, timescale in ipairs({'day', 'week', 'month'}) do
        local timescale_path = journal_path .. '/' .. opts.get().journal_subdirs[timescale]
        local timescale_path_in_cur_path =string.find(current_path, timescale_path, 1, true)
        if timescale_path_in_cur_path then return timescale end
    end

    return nil
end

function M.journal(timescale, steps)
    if not timescale then print("FATAL: Invalid timescale"); return end
    steps = steps or 0

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

function M.nav(direction)
    if not direction then
        print("Invalid direction (expected one of `left`, `down`, `up`, or `right`)")
        return
    end
    direction = direction:sub(1, 1)

    local direction_mapping = { l=-1, d=-1, u=1, r=1 }
    local timescale = M.cur_buf_journal_timescale()
    if direction == "l" or direction == "r" then
        if not timescale then return end
        M.journal(timescale, direction_mapping[direction])
    elseif direction == "u" or direction == "d" then
        local timescale_mapping = {
            [''] = {u='day', d='month'},
            ['day'] = {u='week', d='month'},
            ['week'] = {u='month', d='day'},
            ['month'] = {u='day', d='week'},
        }
        if not timescale then timescale = '' end
        M.journal(timescale_mapping[timescale][direction], 0)
    end
end

return M
