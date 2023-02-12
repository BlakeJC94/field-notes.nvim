local M = {}

local function set_note_command()
    vim.api.nvim_create_user_command(
        "Note",
        require("field_notes.core.note").note,
        { force = true, nargs = '*' }
    )
end

local function set_journal_command()
    vim.api.nvim_create_user_command(
        "Journal",
        require("field_notes.core.journal").journal,
        { force = true, nargs = '*' }
    )
end

function M.set()
    set_note_command()
    set_journal_command()
end

return M
