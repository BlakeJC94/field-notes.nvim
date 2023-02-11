local M = {}

local note = require("neozettel.core.note").note
local journal = require("neozettel.core.journal").journal

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
        note(keys, 2)
    else
        journal(keys)
    end
end

return M
