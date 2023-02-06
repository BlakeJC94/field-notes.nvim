local M = {}

M.SUBCOMMANDS = {
    note = require("neozettel.core.note").note,
    daily = require("neozettel.core.daily").daily,
    weekly = require("neozettel.core.weekly").weekly,
    monthly = require("neozettel.core.monthly").monthly,
}

function M._validate_subcommand_from_args(fargs)
    if #fargs == 0 or M.SUBCOMMANDS[rawget(fargs, 1)] == nil then
        return false, ""
    end
    return true, fargs[1]
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

    M.SUBCOMMANDS[subcommand]()
end

return M
