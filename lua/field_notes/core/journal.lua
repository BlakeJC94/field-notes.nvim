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

local function edit_journal(timescale, timestamp)
    local title = utils.get_journal_title(timescale, timestamp)
    local file_dir = utils.get_journal_dir(timescale)
    utils.create_dir(file_dir)
    utils.edit_note(file_dir, title)
end

M._csteps = nil
local function set_csteps(val)
    M._csteps = val
end
local function get_csteps()
    if not M._csteps then set_csteps(0) end
    return M._csteps
end



function M.journal(timescale, steps)
    if not timescale then print("FATAL: Invalid timescale"); return end

    if not steps then
        set_csteps(0)
        steps = 0
    end

    local csteps = get_csteps()
    csteps = csteps + steps
    set_csteps(csteps)

    local timestamp = os.date("*t")
    if timescale == "day" then
        timestamp.day = timestamp.day + csteps
    elseif timescale == "week" then
        timestamp.day = timestamp.day + 7 * csteps
    elseif timescale == "month" then
        timestamp.month = timestamp.month + csteps
    end

    edit_journal(timescale, os.time(timestamp))
    M.set_local_nav_maps()
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
