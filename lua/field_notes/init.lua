local M = {}

local opts = require("field_notes.opts")
local commands = require("field_notes.commands")
local augroups = require("field_notes.augroups")

function M.setup(config)
    opts.set(config or {})
    commands.set()
    augroups.set()
end

return M
