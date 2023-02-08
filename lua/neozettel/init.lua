local M = {}

local opts = require("neozettel.opts")
local core = require("neozettel.core")

function M.setup(config)
    opts.set(config or {})
    core.setup_command()
end

-- local note_functions = require("neozettel.note")
-- M = vim.tbl_deep_extend("force", M, note_functions)

M.neozettel = require("neozettel.core").neozettel

return M
