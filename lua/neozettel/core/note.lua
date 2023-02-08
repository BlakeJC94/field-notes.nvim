local M = {}

local opts = require("neozettel.opts")
local utils = require("neozettel.utils")

-- TODO load template instead of manually writing yaml header
function M.note(in_str)
    local note_path, title

    title = in_str or ""
    if #title == 0 then title = utils.get_note_title() end

    -- TODO make error handling more elegant
    if title == "" then print("FATAL: Empty title received."); return end

    -- Create notes directory if it doesn't exist
    local note_dir = opts.get().note_dir
    utils.create_dir(note_dir)

    -- Flatten title for file_name matching/creation
    local flat_title = utils.slugify(title)
    note_path = note_dir .. '/' .. flat_title .. ".md"

    -- Open in vertical split and move cursor to end of file
    utils.edit_in_split(note_path, true, title)
end

return M

