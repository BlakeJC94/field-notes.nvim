local M = {}

local opts = require("field_notes.opts")
local utils = require("field_notes.utils")

function M.cur_buf_journal_timescale()
    if not utils.buffer_is_in_field_notes(0, 'journal') then return nil end

    local current_path = vim.api.nvim_buf_get_name(0)
    for _, timescale in ipairs({'day', 'week', 'month'}) do
        local timescale_path = utils.get_journal_dir(timescale)
        local timescale_path_in_cur_path = string.find(current_path, timescale_path, 1, true)
        if timescale_path_in_cur_path then return timescale end
    end

    return nil
end


-- FIXME
-- function M.cur_buf_journal_timestamp()
--     local timescale = M.cur_buf_journal_timescale()
--     if not timescale then return nil end

--     -- Get date format
--     local date_format = opts.get().journal_date_title_formats[timescale]
--     -- Get filename -- FIXME get title of note instead
--     -- local current_filename = string.match(vim.api.nvim_buf_get_name(0), '/([^/]+)%..*$')
--     local current_filepath = vim.api.nvim_buf_get_name(0)
--     local title_of_note = utils.read_title_of_note_from_filepath(current_filepath)
--     -- Get timestamp
--     print("TRACE: date_format", date_format)
--     print("TRACE: title_of_note", title_of_note)
--     local timestamp = vim.fn.strptime(date_format, title_of_note)
--     print("TRACE: from file timestamp", timestamp)
--     return timestamp
-- end


local function edit_journal(timescale, timestamp)
    local title = utils.get_journal_title(timescale, timestamp)
    local file_dir = utils.get_journal_dir(timescale)
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

local function get_title_from_buffer(bufnr)
    bufnr = bufnr or 0
    local content = vim.api.nvim_buf_get_lines(bufnr, 0, -1, false)
    local title
    for _, line in ipairs(content) do
        title = string.match(line, "^#%s(.+)")
        if title then
            break
        end
    end
    return title
end

function M.journal(timescale, steps)
    if not timescale then print("FATAL: Invalid timescale"); return end

    -- If not in journal buffer, skip steps arg and open journal at current time
    if not utils.buffer_is_in_field_notes(0, "journal") then
        edit_journal(timescale)
        return
    end

    -- Otherwise, get time from title of jounral buffer and get datetbl
    local cur_journal_title = get_title_from_buffer(0)
    local cur_buf_journal_timescale = M.cur_buf_journal_timescale()
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
