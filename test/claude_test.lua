function read_number_lines(filename)
    local lines = {}
    local file = assert(io.open(filename, "r"))
    
    for line in file:lines() do
        local numbers = {}
        for num in line:gmatch("%S+") do
            table.insert(numbers, tonumber(num))
        end
        table.insert(lines, numbers)
    end
    
    file:close()
    return lines
end

local lines = read_number_lines("input.txt")

function print_number_lines(lines)
    for line_num, line in ipairs(lines) do
        io.write("Line " .. line_num .. ": ")
        for i, num in ipairs(line) do
            io.write(num)
            if i < #line then
                io.write(" ")
            end
        end
        io.write("\n")
    end
end

print_number_lines(lines)
