local M = {}

local opts = require("neozettel.opts")
local utils = require("neozettel.utils")

function M.daily(keys)
    -- Create daily directory if it doesn't exist
    -- TODO configurable daily dir
    local file_dir = opts.get().journal_dir .. '/daily'
    utils.create_dir(file_dir)

    -- TODO configurable date format
    -- TODO customisable filename
    local title = io.popen("date +'%Y-%m-%d: %a'"):read()
    local filename = utils.slugify(title)
    local file_path = file_dir .. '/' .. filename .. ".md"

    -- Open in vertical split and move cursor to end of file
    utils.edit_in_split(file_path, true, title)
end

return M
