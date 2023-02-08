local M = {}

local function setup_command()
    vim.api.nvim_create_user_command(
        "NeoZettel",
        require("neozettel").neozettel,
        { force = true, nargs = '*' }
    )
end


function M.set()
    setup_command()
end

return M
