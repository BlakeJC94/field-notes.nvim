local M = {}

local opts = require("field_notes.opts")
local utils = require("field_notes.utils")

-- Infers project name and branch name from current directory
-- Returns "<proj>: <branch>" as a string
local function get_note_title()
    local project_name, branch_name, _

    local project_path
    branch_name = utils.get_git_branch_from_buffer()
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

-- TODO load template instead of manually writing yaml header
function M.note(keys)
    local title

    title = table.concat(keys.fargs, " ") or ""
    if #title == 0 then title = get_note_title() end

    -- TODO make error handling more elegant
    if title == "" then print("FATAL: Empty title received."); return end

    -- Create notes directory if it doesn't exist
    local notes_dir = table.concat({
        opts.get().field_notes_path,
        opts.get().notes_dir,
    }, '/')

    utils.create_dir(notes_dir)
    if utils.buffer_is_in_field_notes(0, 'notes') then
        local link = require("field_notes.core.link")
        link.add_field_note_link_at_cursor(utils.slugify(title))
    end
    utils.edit_note(notes_dir, title)
end

function M.goto_index(_keys)
    local notes_path = table.concat({
        opts.get().field_notes_path,
        opts.get().notes_dir,
    }, '/')
    utils.create_dir(notes_path)

    -- Get index path
    local index_path = table.concat({
        notes_path,
        table.concat({
            opts.get().index_name,
            opts.get().file_extension
        }, '.'),
    }, '/')

    -- Open buffer for index and change local working directory
    if not utils.buffer_is_in_field_notes() then
        if not utils.buffer_is_empty() then
            if opts.get()._vert then vim.cmd.vsplit() else vim.cmd.split() end
        end
        vim.cmd.lcd(vim.fn.expand(opts.get().field_notes_path))
    end
    vim.cmd.edit(index_path)
end

return M

