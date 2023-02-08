local M = {}

local opts = require("neozettel.opts")
local core = require("neozettel.core")

function M.setup(config)
    opts.set(config or {})
    core.setup_command()
end

M.neozettel = require("neozettel.core").neozettel

return M
