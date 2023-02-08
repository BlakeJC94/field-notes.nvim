local M = {}

local note = require("neozettel.core.note").note
local journal = require("neozettel.core.journal").journal
local opts = require("neozettel.opts")

M.ALLOWED_SUBCOMMANDS = {
    "note",
    "day",
    "week",
    "month",
}

function M._validate_subcommand(subcommand)
    subcommand = subcommand or ""
    if #subcommand == 0 then return false end
    for _, v in pairs(M.ALLOWED_SUBCOMMANDS) do
        if v == subcommand then return true end
    end
    return false
end

function M.neozettel(keys)
    local fargs = keys.fargs
    local subcommand = rawget(fargs, 1)
    local status_ok = M._validate_subcommand(subcommand)

    if not status_ok then
        print("Warning: NeoZettel expects one of ", vim.inspect(M.ALLOWED_SUBCOMMANDS))
        return
    end

    if subcommand == "note" then
        local title = table.concat({unpack(fargs, 2)}, " ")  -- falls back to empty str
        note(title)
    else
        local steps = rawget(fargs, 2) or 0
        journal(
            subcommand,
            opts.get().journal_date_title_formats[subcommand],
            steps
        )
    end
end

return M
