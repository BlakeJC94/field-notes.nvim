local M = {}

M.SUBCOMMANDS = {
    note = require("neozettel.core.note").note,
    day = require("neozettel.core.journal").day,
    week = require("neozettel.core.journal").week,
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
    local status_ok, subcommand = M._validate_subcommand_from_args(fargs)

    if not status_ok then
        local allowed_subcommands = vim.tbl_keys(M.SUBCOMMANDS)
        table.sort(allowed_subcommands)
        print("Warning: NeoZettel expects one of ", vim.inspect(allowed_subcommands))
        return
    end

    if subcommand == "note" then
        local title = ""
        if #fargs > 1 then title = table.concat({unpack(fargs, 2)}, " ") end
        M.SUBCOMMANDS.note(title)
        return
    end

    local steps = 0
    if #fargs > 1 then
        steps = fargs[2]
    end
    M.SUBCOMMANDS[subcommand](steps)
end

return M
