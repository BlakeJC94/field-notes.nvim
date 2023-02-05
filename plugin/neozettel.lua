if vim.g.loaded_neozettel then return end  -- Prevent loading file twice

local save_cpo = vim.o.cpo  -- save user coptions
vim.cmd.set("cpo&vim")  -- reset them to defaults

-- vim.api.nvim_create_user_command(
--     "NeoZettel",
--     require("neozettel").say_yo,
--     {force=true}
-- )

vim.o.cpo = save_cpo -- and restore after

vim.g.loaded_neozettel = 1
