local M = {}

M.neozettel = require("neozettel.core.command").neozettel

function M.setup_command()
    vim.api.nvim_create_user_command(
        "NeoZettel",
        require("neozettel").neozettel,
        { force = true, nargs = '*' }
    )
end

function M.setup_note_command()
    vim.api.nvim_create_user_command(
        "Note",
        require("neozettel.core.note").note,
        { force = true, nargs = '*' }
    )
end

function M.setup_journal_command()
    vim.api.nvim_create_user_command(
        "Journal",
        require("neozettel.core.journal").journal,
        { force = true, nargs = '*' }
    )
end

return M
