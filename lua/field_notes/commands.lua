local M = {}

local function set_note_command()
    for _, cmd in ipairs({"F", "FieldNote" ,"Note"}) do
        vim.api.nvim_create_user_command(
            cmd,
            require("field_notes.core.note").note,
            { force = true, nargs = '*' }
        )
    end
end

local function set_journal_command()
    for _, cmd in ipairs({"Journal", "J"}) do
        vim.api.nvim_create_user_command(
            cmd,
            require("field_notes.core.journal").journal,
            { force = true, nargs = '*' }
        )
    end
end

function M.set()
    set_note_command()
    set_journal_command()
end

return M
