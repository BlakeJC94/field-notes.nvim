local M = {}

local opts = require("field_notes.opts")

function M.create_dir(dir_path)
    if vim.fn.filereadable(dir_path) > 0 then
        error("Path at '" .. dir_path .. "' is a file, can't create directory here")
    end

    if vim.fn.isdirectory(dir_path) > 0 then
        return
    end

    local prompt = "Directory '" .. dir_path .. "' not found. Would you like to create it? (Y/n) : "
    local user_option = vim.fn.input(prompt)
    user_option = string.gsub(user_option, "^[ ]+", "")
    if string.sub(user_option, 1, 1) == 'Y' then
        vim.fn.mkdir(dir_path, "p")
    end
end

-- TODO validate timescale
function M.get_journal_dir(timescale)
    if not timescale then
        return table.concat({
            opts.get().field_notes_path,
            opts.get().journal_dir,
        }, '/')
    end
    local timescale_dir = opts.get().journal_subdirs[timescale]
    return table.concat({
        opts.get().field_notes_path,
        opts.get().journal_dir,
        timescale_dir,
    }, '/')
end

function M.get_notes_dir()
    return table.concat({
        opts.get().field_notes_path,
        opts.get().notes_dir,
    }, '/')
end

return M
