local M = {}

local function parse_date_format_char(char, date_format, input_str)
    local output, search_pattern, char_matches, _
    search_pattern, _ = string.gsub(date_format, '%%[^' .. char .. ']', '%%S+')
    search_pattern, _ = string.gsub(search_pattern, '([%-%(%)%[%]])', '%%%1')  -- Escape other regex chars
    search_pattern, char_matches = string.gsub(search_pattern, '%%' .. char, '(%%d+)')
    if char_matches == 0 then
        -- print(table.concat({"Character", "%" .. char, "not found in", date_format}, ' '))
        return nil
    end

    search_pattern = string.gsub(search_pattern, '', '')
    output = string.match(input_str, search_pattern)
    if not output then
        error(table.concat({"No match found for", char, "in", input_str, "with search", search_pattern}, ' '))
    end
    -- print(table.concat({"Match",output,"found for", char, "in", input_str, "with search", search_pattern,}, ' '))
    return tonumber(output)
end

local function day_of_first_wday(wday, year)
    for i=1,7 do
        if os.date("*t", os.time({year=year, month=1, day=i})).wday == wday + 1 then
            return i
        end
    end
end

local function normalise_datetbl(tbl)
    tbl.month = tbl.month or 1
    tbl.day = tbl.day or 1
    return os.date("*t", os.time(tbl))
end


function M.get_datetbl_from_str(date_format, input_str)
    local _

    -- parse s if present
    local timestamp = parse_date_format_char('s', date_format, input_str)
    if timestamp then
        return os.date('*t', timestamp)
    end

    -- replace x with d/m/y fmt
    if string.match(date_format, '%%x') then
        date_format, _ = string.gsub(date_format, "%%x", "%%d/%%m/%%y")
    end

    -- parse year
    local year = parse_date_format_char('Y', date_format, input_str)
    if not year then
        year = parse_date_format_char('y', date_format, input_str)
        if not year then error("year cannot be determined") end
        if year < 70 then
            year = 2000 + year
        else
            year = 1900 + year
        end
    end

    -- parse month
    local month = parse_date_format_char('m', date_format, input_str) or 1

    -- parse day
    local day = parse_date_format_char('d', date_format, input_str)
    if day then
        return normalise_datetbl({year=year, month=month, day=day})
    end

    -- parse day of year
    local dayofyear = parse_date_format_char('j', date_format, input_str)
    if dayofyear then
        return normalise_datetbl({year=year, day=dayofyear})
    end

    -- parse day of week
    local dayofweek = parse_date_format_char('w', date_format, input_str) or 0

    -- parse week number
    local weeknum_sun = parse_date_format_char('U', date_format, input_str)
    if weeknum_sun then
        local day_of_first_sun = day_of_first_wday(0, year)
        day = day_of_first_sun + 7 * (weeknum_sun - 1) + (dayofweek)
        return normalise_datetbl({year=year, day=day})
    end

    local weeknum_mon = parse_date_format_char('W', date_format, input_str)
    if weeknum_mon then
        local day_of_first_mon = day_of_first_wday(1, year)
        day = day_of_first_mon + 7 * weeknum_mon + (dayofweek - 1)
        return normalise_datetbl({year=year, day=day})
    end

    return normalise_datetbl({year=year, month=month, day=day})
end

function M.slugify(input_string)
    local output_string = input_string
    output_string = string.lower(output_string)
    output_string = string.gsub(output_string, '[ _%[%]()%{%}%\\%/-.,=%\'%\":;><`]+', '_')
    output_string = string.gsub(output_string, '^[_]+', '')
    output_string = string.gsub(output_string, '[_]+$', '')
    return output_string
end

return M
