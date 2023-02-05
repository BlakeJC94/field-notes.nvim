local M = {}

local opts = require("neozettel.opts")
local utils = require("neozettel.utils")

function M.monthly(keys)
    local monthly_path

    -- Create monthly directory if it doesn't exist
    -- TODO configurable monthly dir
    local monthly_dir = opts.get().journal_dir .. '/monthly'
    utils.create_dir(monthly_dir)

    -- TODO configurable date format
    -- TODO customisable filename
    local monthly_filename = io.popen("date -u +'%Y-M%m'"):read()
    monthly_path = monthly_dir .. '/' .. monthly_filename .. ".md"

    -- Open in vertical split and move cursor to end of file
    utils.edit_in_split(monthly_path, true)
end

return M

