local M = {}

local opts = require("neozettel.opts")
local utils = require("neozettel.utils")

function M.weekly(keys)
    local weekly_path

    -- Create weekly directory if it doesn't exist
    -- TODO configurable weekly dir
    local weekly_dir = opts.get().journal_dir .. '/weekly'
    utils.create_dir(weekly_dir)

    -- TODO configurable date format
    -- TODO customisable filename
    local weekly_filename = io.popen("date +'%Y-W%W'"):read()
    weekly_path = weekly_dir .. '/' .. weekly_filename .. ".md"

    -- Open in vertical split and move cursor to end of file
    utils.edit_in_split(weekly_path, true, nil)
end

return M

