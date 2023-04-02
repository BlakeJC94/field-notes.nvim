local M = {}

function M.slugify(input_string)
    local output_string = input_string
    output_string = string.lower(output_string)
    output_string = string.gsub(output_string, '[ _%[%]()%{%}%\\%/-.,=%\'%\":;><`]+', '_')
    output_string = string.gsub(output_string, '^[_]+', '')
    output_string = string.gsub(output_string, '[_]+$', '')
    return output_string
end

return M
