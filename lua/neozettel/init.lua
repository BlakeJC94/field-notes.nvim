local M = {}

local setup_functions = require("neozettel.setup")

M = vim.tbl_deep_extend("force", M, setup_functions)

M.say_yo = require("neozettel.yo")

return M
