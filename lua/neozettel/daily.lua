local M = {}

local opts = require("neozettel.opts")
local utils = require("neozettel.utils")

function M.daily(keys)
    local daily_path

    -- Create daily directory if it doesn't exist
    -- TODO configurable daily dir
    local daily_dir = opts.get().journal_dir .. '/daily'
    utils.create_dir(daily_dir)

    -- TODO configurable date format
    -- TODO customisable filename
    local daily_filename = io.popen("date +'%Y-%m-%d'"):read()
    daily_path = daily_dir .. '/' .. daily_filename .. ".md"

    -- Open in vertical split and move cursor to end of file
    utils.edit_in_split(daily_path, true)
end

return M
