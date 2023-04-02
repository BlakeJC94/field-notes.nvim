local M = {}

local strings = require("field_notes.utils.strings")
M.slugify = strings.slugify

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

local buffer = require("field_notes.utils.buffer")
M.buffer_is_in_field_notes = buffer.is_in_field_notes
M.buffer_is_in_git_dir = buffer.is_in_git_dir
M.buffer_is_empty = buffer.is_empty
M.get_git_branch_from_buffer = buffer.get_git_branch
M.get_title_from_buffer = buffer.get_title
M.get_timescale_from_buffer = buffer.get_timescale


-- Infers project name and branch name from current directory
-- Returns "<proj>: <branch>" as a string
-- TODO move to notes.lua
function M.get_note_title()
    local project_name, branch_name, _

    local project_path
    branch_name = M.get_git_branch_from_buffer()
    if branch_name then
        -- In a git project,
        -- project name will be the project directory
        -- and the branch name is the current branch
        project_path = vim.fn.finddir('.git/..', vim.fn.expand('%:p:h') .. ';')
        project_name = project_path:match('[^/]+$')
    else
        -- Not a git project,
        -- project name will be the upper directory
        -- and the branch name is the current directory
        project_path = vim.cmd.pwd()
        local project_parent_dirs = vim.fn.split(project_path, '/')
        local n_parents = #project_parent_dirs
        project_name = project_parent_dirs[n_parents - 1] or ""
        branch_name = project_parent_dirs[n_parents] or ""
    end

    -- Trim any leading punctuation before returning
    project_name, _ = string.gsub(project_name, '^%p+', '')
    branch_name, _ = string.gsub(branch_name, '^%p+', '')
    return project_name .. ": " .. branch_name
end

-- TODO move to jounrnal.lua
function M.is_direction(input_str)
    input_str = input_str or ""
    local out = false
    for _, direction in ipairs({"left", "down", "up", "right"}) do
        if input_str == direction then
            out = true
            break
        end
    end
    return out
end

function M.is_timescale(input_str)
    input_str = input_str or ""
    local out = false
    for _, timescale in ipairs({"day", "week", "month" }) do
        if input_str == timescale then
            out = true
            break
        end
    end
    return out
end

-- TODO Move to string?
local date = require("field_notes.utils.date")
M.get_datetbl_from_str = date.get_datetbl_from_str

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
