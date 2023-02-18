local M = {}

local opts = require("field_notes.opts")

function M.set()
    local field_notes_files = opts.get().field_notes_path .. "/**/*." .. opts.get().file_extension

    local augroup = {
        -- Opening a new field note in a buffer should be able to be discarded freely if not saved
        {
            events = "BufNewFile",
            pattern = field_notes_files,
            callback = function() vim.cmd('setl buftype=nofile bufhidden=delete') end,
        },
        -- Saving a new field note should then be treated as a proper vim buffer
        {
            events = "BufWrite",
            pattern = field_notes_files,
            callback = function()
                if not vim.fn.filereadable(vim.fn.expand('%')) then
                    vim.cmd('setl buftype= bufhidden=')
                end
            end,
        },
        {
            events = "BufLeave",
            pattern = field_notes_files,
            callback = function()
                if not vim.fn.filereadable(vim.fn.expand('%')) then
                    vim.cmd('bd!')
                end
            end,
        },
    }

    local id = vim.api.nvim_create_augroup("FieldNotes", {clear = true})
    for _, autocmd in pairs(augroup) do
        vim.api.nvim_create_autocmd(
            autocmd.events,
            {
                group = id,
                pattern = autocmd.pattern,
                callback = autocmd.callback,
            }
        )
    end
end


return M
