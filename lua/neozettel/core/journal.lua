local M = {}

local opts = require("neozettel.opts")
local utils = require("neozettel.utils")


function M.journal(file_dir, date_title_fmt)
    -- Create file directory if it doesn't exist
    utils.create_dir(file_dir)

    -- TODO configurable date format
    -- TODO customisable filename
    local date_cmd = "date +'" .. date_title_fmt .. "'"
    local title = io.popen(date_cmd):read()
    local filename = utils.slugify(title)
    local file_path = file_dir .. '/' .. filename .. ".md"

    -- Open in vertical split and move cursor to end of file
    utils.edit_in_split(file_path, true, title)
end

-- TODO configurable daily dir
function M.daily()
    local file_dir = opts.get().journal_dir .. '/daily'
    M.journal(file_dir, "%Y-%m-%d: %a")
end

-- TODO configurable weekly dir
function M.weekly()
    local file_dir = opts.get().journal_dir .. '/weekly'
    M.journal(file_dir, "%Y-W%W")
end

-- TODO configurable monthly dir
function M.monthly()
    local file_dir = opts.get().journal_dir .. '/monthly'
    M.journal(file_dir, "%Y-M%m: %b")
end

return M
