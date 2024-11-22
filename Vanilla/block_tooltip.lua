function format_string(format_string, ...)
    local args = {...}
    return (format_string:gsub("{(%d+)}", function(index)
        return tostring(args[tonumber(index) + 1])
    end))
end

function format_number(num)
    local suffixes = {"", "k", "M", "G", "T", "P", "E"}
    local index = 1

    while num >= 1000 and index < #suffixes do
        num = num / 1000
        index = index + 1
    end

    if num % 1 == 0 then
        return string.format("%d%s", num, suffixes[index])
    else
        return string.format("%.1f%s", num, suffixes[index])
    end
end

function register_block_tooltip()

    db:from_table({
        class = "Script",
        name = "GetCrafterTooltip",
        script = function(block)
            local s = format_string(loc:translate('furnace_desc2','common'), format_number(block.output))..'\n'
            s = s.."total production "..block.total_production
            return s
        end
     })

end