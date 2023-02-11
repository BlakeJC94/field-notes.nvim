local M = {}

local opts = require("neozettel.opts")
local commands = require("neozettel.commands")

function M.setup(config)
    opts.set(config or {})
    commands.set()
end

M.neozettel = require("neozettel.core").neozettel

return M
