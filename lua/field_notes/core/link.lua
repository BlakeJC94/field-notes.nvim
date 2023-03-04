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

return M
