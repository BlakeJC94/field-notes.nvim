local M = {}

local function set_note_command()
    for _, cmd in ipairs({"F", "FieldNote" ,"Note"}) do
        vim.api.nvim_create_user_command(
            cmd,
            function(keys)
                require("field_notes.core.note").note(keys)
            end,
            { force = true, nargs = '*' }
        )
    end
end

local function set_journal_command()
    for _, cmd in ipairs({"Journal", "J"}) do
        vim.api.nvim_create_user_command(
            cmd,
            function(keys)
                local timescale = rawget(keys.fargs, 1)
                local steps = rawget(keys.fargs, 2)
                require("field_notes.core.journal").journal(timescale, steps)
            end,
            { force = true, nargs = '*' }
        )
    end
end

function M.set()
    set_note_command()
    set_journal_command()
end

return M
