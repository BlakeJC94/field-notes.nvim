local M = {}

local opts = require("neozettel.opts")
local utils = require("neozettel.utils")

-- TODO load template instead of manually writing yaml header
function M.note(keys)
    local note_path, title

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

    -- Flatten title for file_name matching/creation
    local flat_title = utils.slugify(title)
    note_path = notes_dir .. '/' .. flat_title .. "." .. opts.get().file_extension

    -- Open in vertical split and move cursor to end of file
    utils.edit_in_split(note_path, true, title)
end

return M

