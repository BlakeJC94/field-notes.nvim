local M = {}

function M.slugify(input_string)
    local output_string = string.lower(input_string)
    output_string = string.gsub(output_string, '[ %[%]()%{%}%\\%/-.,=%\'%\":;><]+', '_')
    output_string = string.gsub(output_string, '^[_]+', '')
    output_string = string.gsub(output_string, '[_]+$', '')
    return output_string
end

-- TODO Test
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

-- TODO Test
-- TODO Add template and keys to this instead of simply title
function M.edit_note(file_dir, title)
    title = title or ""

    local opts = require("field_notes.opts")

    local filename = M.slugify(title)
    local file_path = file_dir .. '/' .. filename .. '.' .. opts.get().file_extension

    vim.cmd.lcd(vim.fn.expand(opts.get().field_notes_path))
    vim.cmd.edit(file_path)

    -- TODO if the file_path doesn't exist yet, write the title to buffer
    local file_path_exists = vim.fn.filereadable(file_path)
    if file_path_exists == 0 and title ~= "" then
        local lines = {"# " .. title, ""}
        vim.api.nvim_buf_set_lines(0, 0, 0, true, lines)
        vim.cmd('setl nomodified')
    end
    vim.cmd.normal('G$')
end

-- Infers project name and branch name from current directory
-- Returns "<proj>: <branch>" as a string
-- TODO test
function M.get_note_title()
    local project_name, branch_name, _

    local project_path
    if M.is_in_git_project() then
        -- In a git project,
        -- project name will be the project directory
        -- and the branch name is the current branch
        project_path = vim.fn.finddir('.git/..', vim.fn.expand('%:p:h') .. ';')
        project_name = project_path:match('[^/]+$')
        branch_name = M.quiet_run_shell('git branch --show-current --quiet')
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

-- TODO is_git_dir
-- git rev-parse --git-dir 2> /dev/null;
function M.is_in_git_project()
    local git_is_installed = (#M.quiet_run_shell("command -v git") > 0)
    if not git_is_installed then return false end

    local git_dir_found = (#M.quiet_run_shell("git rev-parse --git-dir") > 0)
    if not git_dir_found then return false end

    return true
end

-- Outputs a string
function M.quiet_run_shell(cmd)
    local _
    cmd = cmd or ""
    cmd, _ = string.gsub(cmd, ";$" , "")
    local result = ""
    if #cmd > 0 then
        local quiet_stderr = "2> /dev/null"
        cmd = cmd .. " " .. quiet_stderr
        result = io.popen(cmd):read()
    end
    return result
end

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
