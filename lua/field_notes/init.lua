local M = {}

local opts = require("field_notes.opts")
local commands = require("field_notes.commands")

function M.setup(config)
    opts.set(config or {})
    commands.set()
end

return M
