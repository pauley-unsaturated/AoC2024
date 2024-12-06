package.path = package.path .. ";../lib/?.lua"
require "file"
require "util"

-- Helper function to split a string by delimiter
function split(str, delimiter)
    local result = {}
    for match in (str .. delimiter):gmatch("(.-)" .. delimiter) do
        table.insert(result, match)
    end
    return result
end

function print_numbers(prefix, numbers)
    if type(numbers) == "table" then
        local str = prefix .. ": ["
        for i, num in ipairs(numbers) do
            str = str .. num
            if i < #numbers then
                str = str .. ", "
            end
        end
        str = str .. "]"
        print(str)
    else
        print(prefix .. ": " .. tostring(numbers))
    end
end

-- Main function to solve the problem
function solve_print_queue(input)
    local lines = {}
    for line in input:gmatch("[^\r\n]+") do
        table.insert(lines, line)
    end

    -- Parse the rules and build the dependencies map
    local comes_before = {}
    local i = 1
    while i <= #lines do
        local parts = split(lines[i], "|")
        if #parts ~= 2 then break end -- Stop when we hit non-rule line

        local before, after = tonumber(parts[1]), tonumber(parts[2])
        if not comes_before[before] then
            comes_before[before] = {}
        end
        comes_before[before][after] = true
        i = i + 1
    end

    -- Skip any blank lines
    while i <= #lines and lines[i] == "" do
        i = i + 1
    end

    -- Process the updates
    local sum = 0
    while i <= #lines do
        local update = lines[i]
        local numbers = {}
        for num in update:gmatch("%d+") do
            table.insert(numbers, tonumber(num))
        end

        --print_numbers("Processing Update", numbers)

        -- Check if this update is in correct order
        local valid = true
        for idx1 = 1, #numbers do
            for idx2 = idx1 + 1, #numbers do
                local num1 = numbers[idx1]
                local num2 = numbers[idx2]
                -- If num1 should come after num2, the order is wrong
                if comes_before[num2] and comes_before[num2][num1] then
                    valid = false
                    break
                end
            end
            if not valid then break end
        end

        if valid then
            local middle_idx = math.floor(#numbers / 2) + 1
            --print_numbers("Valid update with middle number", numbers[middle_idx])
            sum = sum + numbers[middle_idx]
        end

        i = i + 1
    end

    return sum
end

-- Helper function to check if a number exists in array
function has_number(arr, num)
    for _, v in ipairs(arr) do
        if v == num then
            return true
        end
    end
    return false
end

-- Test with sample input
local sample_input = [[47|53
97|13
97|61
97|47
75|29
61|13
75|53
29|13
97|29
53|29
61|53
61|29
47|13
75|47
97|75
47|61
75|61
47|29
75|13
53|13

75,47,61,53,29
97,61,53,29,13
75,29,13
75,97,47,61,53
61,13,29
97,13,75,29,47]]

--print("Part 1:", solve_print_queue(sample_input))


local input = read_file("input.txt")
print("Part 1:", solve_print_queue(input))


function solve_print_queue_part2(input)
    local lines = {}
    for line in input:gmatch("[^\r\n]+") do
        table.insert(lines, line)
    end

    -- Parse the rules and build the dependencies map
    local comes_before = {}
    local i = 1
    while i <= #lines do
        local parts = split(lines[i], "|")
        if #parts ~= 2 then break end

        local before, after = tonumber(parts[1]), tonumber(parts[2])
        if not comes_before[before] then
            comes_before[before] = {}
        end
        comes_before[before][after] = true
        i = i + 1
    end

    -- Skip any blank lines
    while i <= #lines and lines[i] == "" do
        i = i + 1
    end

    -- Process the updates
    local sum = 0
    while i <= #lines do
        local update = lines[i]
        local numbers = {}
        for num in update:gmatch("%d+") do
            table.insert(numbers, tonumber(num))
        end

        --print_numbers("Processing Update", numbers)

        -- Topological sort using the rules
        local needed_fix = false
        local fixed = false
        while not fixed do
            fixed = true
            for idx1 = 1, #numbers - 1 do
                for idx2 = idx1 + 1, #numbers do
                    local num1 = numbers[idx1]
                    local num2 = numbers[idx2]
                    -- If num1 should come after num2, swap them
                    if comes_before[num2] and comes_before[num2][num1] then
                        numbers[idx1], numbers[idx2] = numbers[idx2], numbers[idx1]
                        fixed = false
                        needed_fix = true
                    end
                end
            end
        end

        if needed_fix then
            --print_numbers("Fixed to", numbers)
            local middle_idx = math.floor(#numbers / 2) + 1
            --print_numbers("Middle number", numbers[middle_idx])
            sum = sum + numbers[middle_idx]
        end

        i = i + 1
    end

    return sum
end

print("Part 2:", solve_print_queue_part2(input))
