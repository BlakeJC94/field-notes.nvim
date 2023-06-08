local M = {}

local function _journal_command_complete(a, l, p)
    return {"day", "week", "month", "left", "down", "up", "right"}
end

local function set_note_command()
    for _, cmd in ipairs({"F", "FieldNote", "Note"}) do
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
                local journal = require("field_notes.core.journal")
                local subcommand = rawget(keys.fargs, 1)

                if require("field_notes.utils").is_timescale(subcommand) then
                    local steps = rawget(keys.fargs, 2)
                    journal.journal(subcommand, steps)
                end

                if journal.is_direction(subcommand) then
                    journal.nav(subcommand)
                end
            end,
            { force = true, nargs = '*', complete = _journal_command_complete }
        )
    end
end

local function set_link_command()
    for _, cmd in ipairs({"L", "LinkNote"}) do
        vim.api.nvim_create_user_command(
            cmd,
            function(keys)
                require("field_notes.core.link").link(keys)
            end,
            { force = true, nargs = '?', complete = require("field_notes.core.link").complete}
        )
    end
end

local function set_goto_index_command()
    for _, cmd in ipairs({"I", "FieldNotesIndex"}) do
        vim.api.nvim_create_user_command(
            cmd,
            function(keys)
                require("field_notes.core.note").goto_index(keys)
            end,
            { force = true, }
        )
    end
end

function M.set()
    set_note_command()
    set_journal_command()
    set_link_command()
    set_goto_index_command()
end

return M
