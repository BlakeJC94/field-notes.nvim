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

function M.update_index(_keys)
    local index_path = table.concat({
        opts.get().field_notes_path,
        opts.get().notes_dir,
        table.concat({
            opts.get().index_name,
            opts.get().file_extension
        }, '.'),
    }, '/')
    if vim.fn.filereadable(index_path) == 0 then
        -- Exit if file doesn't exist
        return
    end

    -- Load the index file
    local _bufnr_already_exists = vim.fn.bufexists(index_path)
    local bufnr = vim.fn.bufadd(index_path)
    vim.fn.bufload(index_path)
    -- Get list of lines
    local index_lines = vim.api.nvim_buf_get_lines(bufnr, 0, -1, false)

    -- Get list of listed contents and taget link numbers for unlisted block
    local anchor = opts.get().index_new_links_anchor
    local anchor_idx
    local last_link_idx
    local index_contents = {}
    for line_idx, line in ipairs(index_lines) do
        if not anchor_idx and string.match(line, "^" .. anchor) then
            anchor_idx = line_idx
            last_link_idx = line_idx
        end

        -- Record current entries
        local link_match = string.match(line, "%[%[([^|]+).*%]%]")
        if link_match then
            if anchor_idx and line_idx == last_link_idx + 1 then
                last_link_idx = line_idx
            else
                index_contents[#index_contents + 1] = link_match
            end
        end
    end


    -- Get list of directory contents (subdirs and field-notes)
    local index_directory = vim.fs.dirname(index_path)
    local index_contents_unlisted = {}
    if not anchor_idx then
        index_contents_unlisted = {""}
    end
    index_contents_unlisted[#index_contents_unlisted + 1] = anchor

    for i in vim.fs.dir(index_directory, {depth = 1}) do
        local _is_directory = vim.fn.isdirectory(i)
        local is_directory = _is_directory ~= 0

        local filename = vim.fs.basename(i)
        local _is_index = string.match(filename, "^" .. opts.get().index_name .. "." .. opts.get().file_extension .. "$")
        local is_index = _is_index or false
        local _, _is_hidden = string.gsub(filename, "^%.", "")
        local is_hidden = _is_hidden ~= 0
        local link, _is_note = string.gsub(filename, "%." .. opts.get().file_extension .. "$", "")
        local is_note = _is_note ~= 0

        if is_directory then
            link = link .. '/'
        end
        if not (is_index or is_hidden) and (is_note or is_directory) then
            local already_recorded = false
            for _, j in pairs(index_contents) do
                if j == link then
                    already_recorded = true
                    break
                end
            end
            if not already_recorded then
                index_contents_unlisted[#index_contents_unlisted + 1] = '* [[' .. link .. ']]'
            end
        end
    end

    -- Clear outdated unlisted entries and replace with updated list
    table.sort(index_contents_unlisted)
    local start_idx = anchor_idx - 1 or -1
    local end_idx = last_link_idx or -1
    vim.api.nvim_buf_set_lines(bufnr, start_idx, end_idx, false, index_contents_unlisted)

    -- Close buffer
    vim.api.nvim_buf_call(bufnr, function() vim.cmd("silent write") end)
    if _bufnr_already_exists == 0 then
        vim.cmd.bwipeout(index_path)
    end
end

return M

