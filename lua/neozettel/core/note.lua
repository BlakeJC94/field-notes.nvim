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

    -- Create new note with yaml header if doesn't exist yet
    -- TODO Replace this with a more robust template writer
    -- TODO fill buffer instead of writing to file **
    -- TODO Refactor
    if vim.fn.filereadable(note_path) == 0 then
        -- local date = io.popen("date -u +'%Y_%m_%d'"):read()
        local new_note = io.open(note_path, 'w')
        -- Write yaml header
        -- new_note:write("---\n")
        -- new_note:write("title: " .. title .. "\n")
        -- new_note:write("date: " .. string.gsub(date, '_', '-') .. "\n")
        -- new_note:write("tags:\n")
        -- new_note:write("---\n\n")
        -- Write title and close
        new_note:write("# " .. title .. '\n\n\n')
        new_note:close()
    end

    -- Open in vertical split and move cursor to end of file
    utils.edit_in_split(note_path, true, title)
end

return M

