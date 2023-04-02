local M = {}

local strings = require("field_notes.utils.strings")
M.slugify = strings.slugify

local dirs = require("field_notes.utils.dirs")
M.create_dir = dirs.create_dir

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

function M.get_journal_title(timescale, timestamp)
    timestamp = timestamp or os.time()
    local opts = require("field_notes.opts")
    local date_title_fmt = opts.get().journal_date_title_formats[timescale]
    return os.date(date_title_fmt, timestamp)
end

function M.add_field_note_link_at_cursor(filename)
    local link_string = table.concat({"[[", filename, "]]"})
    local cursor = vim.api.nvim_win_get_cursor(0)
    local row = cursor[1] - 1
    local col = cursor[2]
    vim.api.nvim_buf_set_text(0, row, col, row, col, {link_string})
    vim.cmd.write()
end

function M.add_field_note_link_at_current_journal(filename, timescale)
    local opts = require("field_notes.opts")

    -- Open current journal at timescale
    local title = M.get_journal_title(timescale, nil)
    local file_dir = opts.get_journal_dir(timescale)
    local file_path = file_dir .. '/' .. M.slugify(title) .. '.' .. opts.get().file_extension
    if vim.fn.filereadable(file_path) == 0 then
        -- Exit if file doesn't exist
        return
    end

    -- Load the journal file
    local _bufnr_already_exists = vim.fn.bufexists(file_path)
    local bufnr = vim.fn.bufadd(file_path)
    vim.fn.bufload(file_path)
    -- Get list of lines
    local content = vim.api.nvim_buf_get_lines(bufnr, 0, -1, false)

    -- Search for anchor
    local anchor = opts.get().journal_link_anchor
    local last_link_idx
    local link_match
    local title_idx = 0
    for line_idx, line in ipairs(content) do
        if title_idx == 0 and string.match(line, "^#%s") then
            title_idx = line_idx
        elseif not last_link_idx and string.match(line, "^" .. anchor) then
            last_link_idx = line_idx
        elseif last_link_idx then
            link_match = string.match(line, "%[%[(%S+)%]%]")
            if link_match then
                if link_match == filename then
                    -- Exit if item is already in list
                    if _bufnr_already_exists == 0 then
                        vim.cmd.bwipeout(file_path)
                    end
                    return
                end
                last_link_idx = line_idx
            else
                break
            end
        end
    end

    -- If anchor is not present, insert new anchor 2 lines below title
    if not last_link_idx then
        vim.api.nvim_buf_set_lines(bufnr, title_idx, title_idx, false, {"", anchor})
        last_link_idx = title_idx + 2
    end

    -- Get link str and insert line at end of list
    local link_string = table.concat({"[[", filename, "]]"})
    vim.api.nvim_buf_set_lines(bufnr, last_link_idx, last_link_idx, false, {"* " .. link_string})

    -- Close buffer
    vim.api.nvim_buf_call(bufnr, function() vim.cmd("silent write") end)
    if _bufnr_already_exists == 0 then
        vim.cmd.bwipeout(file_path)
    end
end

local buffer = require("field_notes.utils.buffer")
M.buffer_is_in_field_notes = buffer.is_in_field_notes
M.buffer_is_in_git_dir = buffer.is_in_git_dir
M.buffer_is_empty = buffer.is_empty
M.get_title_from_buffer = buffer.get_title
M.get_title_from_buffer = buffer.get_timescale


-- Infers project name and branch name from current directory
-- Returns "<proj>: <branch>" as a string
function M.get_note_title()
    local project_name, branch_name, _

    local project_path
    if M.buffer_is_in_git_dir() then
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
    return result or {}
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
