local M = {}

local function setup_note_command()
    vim.api.nvim_create_user_command(
        "NeoZettelNote",
        require("neozettel").note,
        {force=true, nargs='?'}
    )
end

local function setup_daily_command()
    vim.api.nvim_create_user_command(
        "NeoZettelDaily",
        require("neozettel").daily,
        {force=true}
    )
end

local function setup_weekly_command()
    vim.api.nvim_create_user_command(
        "NeoZettelWeekly",
        require("neozettel").weekly,
        {force=true}
    )
end

function M.set()
    setup_note_command()
    setup_daily_command()
    setup_weekly_command()
end

return M
