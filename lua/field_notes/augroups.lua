local M = {}

local augroup = vim.api.nvim_create_augroup
local autocmd = vim.api.nvim_create_autocmd

local opts = require("field_notes.opts")
local utils = require("field_notes.utils")

local function set_journal_link_augroup()
    local group = augroup("field_notes_link_journal", {clear = true})
    autocmd(
        {"BufWrite"},
        {
            group = group,
            pattern = "*." .. opts.get().file_extension,
            callback = function()
                local link = require("field_notes.core.link")
                if utils.buffer_is_in_field_notes(0, "notes") then
                    for k, v in pairs(opts.get().auto_add_links_to_journal) do
                        if v then
                            link.add_field_note_link_at_current_journal(
                                utils.slugify(vim.fn.expand("%:t:r")), k
                            )
                        end
                    end

                end
            end,
        }
    )

end

function M.set()
    for _, v in pairs(opts.get().auto_add_links_to_journal) do
        if v then
            set_journal_link_augroup()
            break
        end
    end
end

return M
