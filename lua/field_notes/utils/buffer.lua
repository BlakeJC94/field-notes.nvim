local M = {}

function M.is_in_field_notes(buf_idx, subdir)
    buf_idx = buf_idx or 0
    local opts = require("field_notes.opts")

    local buf_path = vim.api.nvim_buf_get_name(buf_idx)

    local field_notes_path = vim.fn.expand(opts.get().field_notes_path)
    if subdir then
        if subdir == "notes" then
            field_notes_path = M.get_notes_dir()
        elseif subdir == "journal" then
            field_notes_path = M.get_journal_dir()
        elseif M.is_timescale(subdir) then
            field_notes_path = M.get_journal_dir(subdir)
        end
    end

    if field_notes_path:sub(-1) ~= "/" then field_notes_path = field_notes_path .. '/' end

    local field_notes_path_in_buf_path = string.find(buf_path, field_notes_path, 1, true)
    if field_notes_path_in_buf_path then return true end
    return false
end

function M.is_empty(buf_idx)
    buf_idx = buf_idx or 0
    local status = false
    if #vim.api.nvim_buf_get_lines(buf_idx, 1, -1, false) == 0 then
        status = true
    end
    return status
end

function M.get_title(bufnr)
    bufnr = bufnr or 0
    if not M.buffer_is_in_field_notes(bufnr) then
        return nil
    end
    local content = vim.api.nvim_buf_get_lines(bufnr, 0, -1, false)
    local title
    for _, line in ipairs(content) do
        title = string.match(line, "^#%s(.+)")
        if title then
            break
        end
    end
    return title
end

function M.get_timescale(bufnr)
    bufnr = bufnr or 0
    if not M.buffer_is_in_field_notes(bufnr, "journal") then
        return nil
    end

    local current_path = vim.api.nvim_buf_get_name(bufnr)
    for _, timescale in ipairs({'day', 'week', 'month'}) do
        local timescale_path = M.get_journal_dir(timescale)
        local timescale_path_in_cur_path = string.find(current_path, timescale_path, 1, true)
        if timescale_path_in_cur_path then return timescale end
    end
    error("NEVER REACHED")
end

return M
