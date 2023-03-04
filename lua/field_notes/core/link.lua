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
        local link_string = table.concat({"[[", link_filename, "]]"})
        local cursor = vim.api.nvim_win_get_cursor(0)
        local row = cursor[1] - 1
        local col = cursor[2]
        vim.api.nvim_buf_set_text(0, row, col, row, col, {link_string})
        vim.cmd.write()
    end
    vim.cmd.edit(file_path)
end

return M
