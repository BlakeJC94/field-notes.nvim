local M = {}

local opts = require("field_notes.opts")
local utils = require("field_notes.utils")

function M.link(keys)
    if not utils.buffer_is_in_field_notes() then return end

    local given_filename = nil
    if keys.args ~= "" then given_filename = keys.args end

    local notes_dir = table.concat({
        opts.get().field_notes_path,
        opts.get().notes_dir,
    }, '/')

    local link_filename
    if not given_filename then
        local cursor_word = vim.fn.expand("<cWORD>")
        link_filename = string.match(cursor_word, "^%[%[([^%[%]]+)%]%]$")
        if not link_filename then return end
    else
        link_filename = given_filename
    end

    local file_path = notes_dir .. '/' .. link_filename .. '.' .. opts.get().file_extension
    local file_path_exists = vim.fn.filereadable(file_path)
    if file_path_exists == 0 then return end

    if given_filename then
        M.add_field_note_link_at_cursor(link_filename)
    end
    vim.cmd.edit(file_path)
end

function M.complete()
    local notes_dir = table.concat({
        opts.get().field_notes_path,
        opts.get().notes_dir,
    }, '/')

    local notes = {}
    for file in vim.fs.dir(notes_dir) do
        notes[#notes+1] = string.gsub(file, "%.%w*$", "")
    end

    return notes
end

function M.add_field_note_link_at_cursor(filename)
    local link_string = table.concat({"[[", filename, "]]"})
    local cursor = vim.api.nvim_win_get_cursor(0)
    local row = cursor[1] - 1
    local col = cursor[2] + 1
    vim.api.nvim_buf_set_text(0, row, col, row, col, {link_string})
    vim.cmd.write()
end

-- TODO rfc
-- TODO make line detection of title and achor placement md-independent
function M.add_field_note_link_at_current_journal(filename, timescale)
    -- Open current journal at timescale
    local title = opts.get_journal_title(timescale, nil)
    local file_dir = opts.get_journal_dir(timescale)
    local file_path = file_dir .. '/' .. utils.slugify(title) .. '.' .. opts.get().file_extension
    if vim.fn.filereadable(file_path) == 0 then
        -- Exit if file doesn't exist
        return
    end

    -- Load the journal file
    local _bufnr_already_exists = vim.fn.bufexists(file_path)
    local bufnr = vim.fn.bufadd(file_path)
    vim.fn.bufload(file_path)
    -- Get list of lines
    local content = vim.api.nvim_buf_get_lines(bufnr, 0, -1, false)

    -- Search for anchor
    local anchor = opts.get().journal_link_anchor
    local last_link_idx
    local link_match
    local title_idx = 0
    for line_idx, line in ipairs(content) do
        if title_idx == 0 and string.match(line, "^#%s") then
            title_idx = line_idx
        elseif not last_link_idx and string.match(line, "^" .. anchor) then
            last_link_idx = line_idx
        elseif last_link_idx then
            link_match = string.match(line, "%[%[(%S+)%]%]")
            if link_match then
                if link_match == filename then
                    -- Exit if item is already in list
                    if _bufnr_already_exists == 0 then
                        vim.cmd.bwipeout(file_path)
                    end
                    return
                end
                last_link_idx = line_idx
            else
                break
            end
        end
    end

    -- If anchor is not present, insert new anchor 2 lines below title
    if not last_link_idx then
        vim.api.nvim_buf_set_lines(bufnr, title_idx, title_idx, false, {"", anchor})
        last_link_idx = title_idx + 2
    end

    -- Get link str and insert line at end of list
    local link_string = table.concat({"[[", filename, "]]"})
    vim.api.nvim_buf_set_lines(bufnr, last_link_idx, last_link_idx, false, {"* " .. link_string})

    -- Close buffer
    vim.api.nvim_buf_call(bufnr, function() vim.cmd("silent write") end)
    if _bufnr_already_exists == 0 then
        vim.cmd.bwipeout(file_path)
    end
end

return M
