local M = {}

M.neozettel = require("neozettel.core.command").neozettel

function M.setup_command()
    vim.api.nvim_create_user_command(
        "NeoZettel",
        require("neozettel").neozettel,
        { force = true, nargs = '*' }
    )
end

return M
