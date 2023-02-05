local M = {}

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

return M
