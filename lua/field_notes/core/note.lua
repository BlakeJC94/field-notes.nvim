local M = {}

local opts = require("field_notes.opts")
local utils = require("field_notes.utils")

-- TODO load template instead of manually writing yaml header
function M.note(keys)
    local title

    title = table.concat(keys.fargs, " ") or ""
    if #title == 0 then title = utils.get_note_title() end

    -- TODO make error handling more elegant
    if title == "" then print("FATAL: Empty title received."); return end

    -- Create notes directory if it doesn't exist
    local notes_dir = table.concat({
        opts.get().field_notes_path,
        opts.get().notes_dir,
    }, '/')

    utils.create_dir(notes_dir)
    utils.edit_note(notes_dir, title)
end

return M

