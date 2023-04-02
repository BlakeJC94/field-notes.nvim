local M = {}

local strings = require("field_notes.utils.strings")
M.slugify = strings.slugify
M.get_datetbl_from_str = strings.get_datetbl_from_str

local buffer = require("field_notes.utils.buffer")
M.buffer_is_in_field_notes = buffer.is_in_field_notes
M.buffer_is_in_git_dir = buffer.is_in_git_dir
M.buffer_is_empty = buffer.is_empty
M.get_git_branch_from_buffer = buffer.get_git_branch
M.get_title_from_buffer = buffer.get_title
M.get_timescale_from_buffer = buffer.get_timescale


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

-- TODO Add template and keys to this instead of simply title
function M.edit_note(file_dir, title)
    title = title or ""

    local opts = require("field_notes.opts")

    local filename = M.slugify(title)
    local file_path = file_dir .. '/' .. filename .. '.' .. opts.get().file_extension

    if not M.buffer_is_in_field_notes() then
        if not M.buffer_is_empty() then
            if opts.get()._vert then vim.cmd.vsplit() else vim.cmd.split() end
        end
        vim.cmd.lcd(vim.fn.expand(opts.get().field_notes_path))
    end
    vim.cmd.edit(file_path)

    -- TODO if the file_path doesn't exist yet, write the title to buffer
    local file_path_exists = vim.fn.filereadable(file_path)
    if file_path_exists == 0 and title ~= "" and M.buffer_is_empty() then
        local lines = {"# " .. title, ""}
        vim.api.nvim_buf_set_lines(0, 0, 0, true, lines)
        vim.cmd('setl nomodified')
        vim.cmd.normal('G$')
    end
end

function M.is_timescale(input_str)
    input_str = input_str or ""
    local out = false
    for _, timescale in ipairs({ "day", "week", "month" }) do
        if input_str == timescale then
            out = true
            break
        end
    end
    return out
end

return M

-- TODO look into vim.uri_from_bufnr
-- TODO yaml header writer
-- ```lua
-- local date = io.popen("date -u +'%Y_%m_%d'"):read()
-- local new_note = io.open(note_path, 'w')
-- Write yaml header
-- new_note:write("---\n")
-- new_note:write("title: " .. title .. "\n")
-- new_note:write("date: " .. string.gsub(date, '_', '-') .. "\n")
-- new_note:write("tags:\n")
-- new_note:write("---\n\n")
-- Write title and close
-- new_note:write("# " .. title .. '\n\n\n')
-- new_note:close()
-- ```
