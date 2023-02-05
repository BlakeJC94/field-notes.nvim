local M = {}

local opts = require("neozettel.opts")
local commands = require("neozettel.commands")

function M.setup(config)
    opts.set(config or {})
    commands.set()
end

-- local note_functions = require("neozettel.note")
-- M = vim.tbl_deep_extend("force", M, note_functions)

M.note = require("neozettel.note").note
M.daily = require("neozettel.daily").daily
M.weekly = require("neozettel.weekly").weekly

return M
