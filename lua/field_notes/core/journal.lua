local M = {}

local opts = require("field_notes.opts")
local utils = require("field_notes.utils")


local function edit_journal(timescale, timestamp)
    local title = opts.get_journal_title(timescale, timestamp)
    local file_dir = opts.get_journal_dir(timescale)
    utils.create_dir(file_dir)
    utils.edit_note(file_dir, title)
    M.set_local_nav_maps()
end

local function apply_steps(timescale, steps, datetbl)
    steps = steps or 0
    if timescale == "day" then
        datetbl.day = datetbl.day + steps
    elseif timescale == "week" then
        datetbl.day = datetbl.day + 7 * steps
    elseif timescale == "month" then
        datetbl.month = datetbl.month + steps
    end
    return datetbl
end


function M.journal(timescale, steps)
    if not timescale then print("FATAL: Invalid timescale"); return end

    -- If not in journal buffer, skip steps arg and open journal at current time
    if not utils.buffer_is_in_field_notes(0, "journal") then
        edit_journal(timescale)
        return
    end

    -- Otherwise, get time from title of jounral buffer and get datetbl
    local cur_journal_title = utils.get_title_from_buffer(0)
    local cur_buf_journal_timescale = utils.get_timescale_from_buffer(0)
    local datetbl = utils.get_datetbl_from_str(
        opts.get().journal_date_title_formats[cur_buf_journal_timescale],
        cur_journal_title
    )
    datetbl = apply_steps(timescale, steps, datetbl)
    edit_journal(timescale, os.time(datetbl))
end

function M.nav(direction)
    if not direction then
        print("Invalid direction (expected one of `left`, `down`, `up`, or `right`)")
        return
    end
    direction = direction:sub(1, 1)

    local direction_mapping = { l=-1, d=-1, u=1, r=1 }
    local timescale = utils.get_timescale_from_buffer()

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
        M.journal(timescale_mapping[timescale][direction])
    end
end

function M.set_local_nav_maps()
    local options = require("field_notes.opts").get()
    for _, dir in ipairs({"left", "down", "up", "right"}) do
        local keymap = options.journal_maps[dir]
        if keymap then
            vim.keymap.set('n', keymap, ":J " .. dir .. " <CR>", { silent = true, buffer = 0 })
        end
    end
end

return M
