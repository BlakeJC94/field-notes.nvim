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
function M.edit_in_split(file_path, vert)
    vert = vert or false
    if vert then
        vim.cmd.vsplit()
    end
    vim.cmd.edit(file_path)
    vim.cmd.lcd(vim.fn.expand("%:p:h"))
    vim.cmd.normal("G$")  -- bang needed?
end

return M
