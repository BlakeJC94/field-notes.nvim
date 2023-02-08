local M = {}

local opts = require("neozettel.opts")
local utils = require("neozettel.utils")

-- TODO access journal location from opts
-- TODO load template instead of manually writing yaml header
-- TODO write template in buffer instead of to file
function M.note(in_str)
    local note_path, title

    -- Infer title if no input given
    title = in_str or utils.get_note_title() or ""

    -- TODO make error handling more elegant
    if title == "" then error("FATAL: Empty title received.") end

    -- Create notes directory if it doesn't exist
    local journal_dir = opts.get().journal_dir
    utils.create_dir(journal_dir)

    -- Flatten title for file_name matching/creation
    local flat_title = utils.slugify(title)
    note_path = journal_dir .. '/' .. flat_title .. ".md"

    -- Open in vertical split and move cursor to end of file
    utils.edit_in_split(note_path, true, title)
end

return M

