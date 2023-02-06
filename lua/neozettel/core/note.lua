local M = {}

local opts = require("neozettel.opts")
local utils = require("neozettel.utils")

-- TODO access journal location from opts
-- TODO refactor
-- TODO load template instead of manually writing yaml header
function M.note(in_str)
    local note_path

    -- Create notes directory if it doesn't exist
    local journal_dir = opts.get().journal_dir
    utils.create_dir(journal_dir)

    -- Infer title if no input given
    -- TODO Refactor
    local title
    if in_str == "" or in_str == nil then
        -- Try to infer title from git project
        local project = vim.fn.finddir('.git/..', vim.fn.expand('%:p:h') .. ';'):match('[^/]+$')

        local branch = ""
        if project ~= nil then
            -- git project identified, get branch name and sep
            branch = ', ' .. io.popen('git branch --show-current'):read()
        else
            -- No git found, use file_name for project and ignore branch
            project = vim.fn.expand('%:p:h:t')
        end
        project = string.gsub(project, '^%.', '')  -- remove leading . if present
        title = project .. branch
    else
        title = in_str
    end

    if title == "" then
        print("Empty title received, aborting")
        return
    end

    -- Flatten title for file_name matching/creation
    local flat_title = utils.slugify(title)
    note_path = journal_dir .. '/' .. flat_title .. ".md"

    -- Create new note with yaml header if doesn't exist yet
    -- TODO Replace this with a more robust template writer
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
    utils.edit_in_split(note_path, true)
end

return M

