package.path = package.path .. ";../lib/?.lua"
require "file"
require "util"

function parse_line(line)
    local test_value, rest = line:match("(%d+): (.*)")
    local numbers = numbers_from(rest)
    return tonumber(test_value), numbers
end

function generate_operator_combinations(n)
    local combinations = {}
    local total = 2 ^ n
    for i = 0, total - 1 do
        local combo = {}
        for j = 1, n do
            -- Use bit operations to determine + or *
            if i & (1 << (j - 1)) == 0 then
                combo[j] = "+"
            else
                combo[j] = "*"
            end
        end
        table.insert(combinations, combo)
    end
    return combinations
end

function evaluate_expression(numbers, operators)
    local result = numbers[1]
    for i = 1, #operators do
        if operators[i] == "+" then
            result = result + numbers[i + 1]
        else
            result = result * numbers[i + 1]
        end
    end
    return result
end

function has_valid_solution(line)
    local test_value, numbers = parse_line(line)
    local num_operators = #numbers - 1
    local operator_combinations = generate_operator_combinations(num_operators)

    -- Try each combination of operators
    for _, operators in ipairs(operator_combinations) do
        local result = evaluate_expression(numbers, operators)
        if result == test_value then
            return true
        end
    end

    return false
end

function find_solutions(line)
    local test_value, numbers = parse_line(line)
    local num_operators = #numbers - 1
    local operator_combinations = generate_operator_combinations(num_operators)
    local solutions = {}

    -- Try each combination of operators
    for _, operators in ipairs(operator_combinations) do
        local result = evaluate_expression(numbers, operators)
        if result == test_value then
            table.insert(solutions, operators)
        end
    end

    return solutions, test_value, numbers
end

-- Optional helper to print solutions
function print_solution(line)
    local solutions, test_value, numbers = find_solutions(line)
    if #solutions > 0 then
        print(string.format("Line %s: %d solution(s)", line, #solutions))
        for _, ops in ipairs(solutions) do
            -- Construct and print the expression
            local expr = tostring(numbers[1])
            for i = 1, #ops do
                expr = expr .. " " .. ops[i] .. " " .. tostring(numbers[i + 1])
            end
            print(string.format("  %s = %d", expr, test_value))
        end
    else
        print(string.format("Line %s: No solutions", line))
    end
end

local test_input = [[
190: 10 19
3267: 81 40 27
83: 17 5
156: 15 6
7290: 6 8 6 15
161011: 16 10 13
192: 17 8 14
21037: 9 7 18 13
292: 11 6 16 20
]]

local lines = {}
for line in test_input:gmatch("[^\r\n]+") do
    table.insert(lines, line)
end

local lines = lines_from("input.txt")

local total = 0

for _, line in ipairs(lines) do
    local test_value, _ = parse_line(line)
    -- print_solution(line)
    if has_valid_solution(line) then
        total = total + test_value
    end
end

print("Part 1:", total)

---

function generate_operator_combinations_2(n)
    local combinations = {}
    local total = 3 ^ n -- Now we have 3 operators instead of 2
    for i = 0, total - 1 do
        local combo = {}
        for j = 1, n do
            -- Use division and modulo to determine operator
            local op_code = math.floor(i / (3 ^ (j - 1))) % 3
            if op_code == 0 then
                combo[j] = "+"
            elseif op_code == 1 then
                combo[j] = "*"
            else
                combo[j] = "||"
            end
        end
        table.insert(combinations, combo)
    end
    return combinations
end

function evaluate_expression_2(numbers, operators)
    local result = numbers[1]
    for i = 1, #operators do
        if operators[i] == "+" then
            result = result + numbers[i + 1]
        elseif operators[i] == "*" then
            result = result * numbers[i + 1]
        else -- concatenation
            result = tonumber(tostring(result) .. tostring(numbers[i + 1]))
        end
    end
    return result
end

function has_valid_solution_2(line)
    local test_value, numbers = parse_line(line)
    local num_operators = #numbers - 1
    local operator_combinations = generate_operator_combinations_2(num_operators)

    -- Try each combination of operators
    for _, operators in ipairs(operator_combinations) do
        local result = evaluate_expression_2(numbers, operators)
        if result == test_value then
            return true
        end
    end

    return false
end

function find_solutions_2(line)
    local test_value, numbers = parse_line(line)
    local num_operators = #numbers - 1
    local operator_combinations = generate_operator_combinations_2(num_operators)
    local solutions = {}

    -- Try each combination of operators
    for _, operators in ipairs(operator_combinations) do
        local result = evaluate_expression_2(numbers, operators)
        if result == test_value then
            table.insert(solutions, operators)
        end
    end

    return solutions, test_value, numbers
end

-- Optional helper to print solutions
function print_solution_2(line)
    local solutions, test_value, numbers = find_solutions_2(line)
    if #solutions > 0 then
        print(string.format("Line %s: %d solution(s)", line, #solutions))
        for _, ops in ipairs(solutions) do
            -- Construct and print the expression
            local expr = tostring(numbers[1])
            for i = 1, #ops do
                expr = expr .. " " .. ops[i] .. " " .. tostring(numbers[i + 1])
            end
            print(string.format("  %s = %d", expr, test_value))
        end
    else
        print(string.format("Line %s: No solutions", line))
    end
end

-- Main program
--local lines = lines_from("input.txt")

function get_cpu_cores()
    local handle = io.popen("sysctl -n hw.ncpu")
    if handle then
        local result = handle:read("*a")
        handle:close()
        return tonumber(result)
    end
    return 4 -- fallback default
end

-- Save the chunk processor as a separate script
function write_chunk_processor()
    local script = [[
package.path = package.path .. ";../lib/?.lua"
require "file"
require "util"

-- [Insert all your helper functions here: parse_line, generate_operator_combinations, evaluate_expression]

function parse_line(line)
    local test_value, rest = line:match("(%d+): (.*)")
    local numbers = numbers_from(rest)
    return tonumber(test_value), numbers
end

function generate_operator_combinations(n)
    local combinations = {}
    local total = 2 ^ n
    for i = 0, total - 1 do
        local combo = {}
        for j = 1, n do
            -- Use bit operations to determine + or *
            if i & (1 << (j - 1)) == 0 then
                combo[j] = "+"
            else
                combo[j] = "*"
            end
        end
        table.insert(combinations, combo)
    end
    return combinations
end

function evaluate_expression(numbers, operators)
    local result = numbers[1]
    for i = 1, #operators do
        if operators[i] == "+" then
            result = result + numbers[i + 1]
        else
            result = result * numbers[i + 1]
        end
    end
    return result
end

function has_valid_solution(line)
    local test_value, numbers = parse_line(line)
    local num_operators = #numbers - 1
    local operator_combinations = generate_operator_combinations(num_operators)

    -- Try each combination of operators
    for _, operators in ipairs(operator_combinations) do
        local result = evaluate_expression(numbers, operators)
        if result == test_value then
            return true
        end
    end

    return false
end

function find_solutions(line)
    local test_value, numbers = parse_line(line)
    local num_operators = #numbers - 1
    local operator_combinations = generate_operator_combinations(num_operators)
    local solutions = {}

    -- Try each combination of operators
    for _, operators in ipairs(operator_combinations) do
        local result = evaluate_expression(numbers, operators)
        if result == test_value then
            table.insert(solutions, operators)
        end
    end

    return solutions, test_value, numbers
end

-- Optional helper to print solutions
function print_solution(line)
    local solutions, test_value, numbers = find_solutions(line)
    if #solutions > 0 then
        print(string.format("Line %s: %d solution(s)", line, #solutions))
        for _, ops in ipairs(solutions) do
            -- Construct and print the expression
            local expr = tostring(numbers[1])
            for i = 1, #ops do
                expr = expr .. " " .. ops[i] .. " " .. tostring(numbers[i + 1])
            end
            print(string.format("  %s = %d", expr, test_value))
        end
    else
        print(string.format("Line %s: No solutions", line))
    end
end

function generate_operator_combinations_2(n)
    local combinations = {}
    local total = 3 ^ n -- Now we have 3 operators instead of 2
    for i = 0, total - 1 do
        local combo = {}
        for j = 1, n do
            -- Use division and modulo to determine operator
            local op_code = math.floor(i / (3 ^ (j - 1))) % 3
            if op_code == 0 then
                combo[j] = "+"
            elseif op_code == 1 then
                combo[j] = "*"
            else
                combo[j] = "||"
            end
        end
        table.insert(combinations, combo)
    end
    return combinations
end

function evaluate_expression_2(numbers, operators)
    local result = numbers[1]
    for i = 1, #operators do
        if operators[i] == "+" then
            result = result + numbers[i + 1]
        elseif operators[i] == "*" then
            result = result * numbers[i + 1]
        else -- concatenation
            result = tonumber(tostring(result) .. tostring(numbers[i + 1]))
        end
    end
    return result
end

function has_valid_solution_2(line)
    local test_value, numbers = parse_line(line)
    local num_operators = #numbers - 1
    local operator_combinations = generate_operator_combinations_2(num_operators)

    -- Try each combination of operators
    for _, operators in ipairs(operator_combinations) do
        local result = evaluate_expression_2(numbers, operators)
        if result == test_value then
            return true
        end
    end

    return false
end

function find_solutions_2(line)
    local test_value, numbers = parse_line(line)
    local num_operators = #numbers - 1
    local operator_combinations = generate_operator_combinations_2(num_operators)
    local solutions = {}

    -- Try each combination of operators
    for _, operators in ipairs(operator_combinations) do
        local result = evaluate_expression_2(numbers, operators)
        if result == test_value then
            table.insert(solutions, operators)
        end
    end

    return solutions, test_value, numbers
end

-- Optional helper to print solutions
function print_solution_2(line)
    local solutions, test_value, numbers = find_solutions_2(line)
    if #solutions > 0 then
        print(string.format("Line %s: %d solution(s)", line, #solutions))
        for _, ops in ipairs(solutions) do
            -- Construct and print the expression
            local expr = tostring(numbers[1])
            for i = 1, #ops do
                expr = expr .. " " .. ops[i] .. " " .. tostring(numbers[i + 1])
            end
            print(string.format("  %s = %d", expr, test_value))
        end
    else
        print(string.format("Line %s: No solutions", line))
    end
end

local chunk_file = arg[1]
local lines = lines_from(chunk_file)
local total = 0

for _, line in ipairs(lines) do
    local test_value, numbers = parse_line(line)
    local num_operators = #numbers - 1
    local operator_combinations = generate_operator_combinations_2(num_operators)

    for _, operators in ipairs(operator_combinations) do
        local result = evaluate_expression_2(numbers, operators)
        if result == test_value then
            total = total + test_value
            break
        end
    end
end

print(total)
]]
    local f = io.open("chunk_processor.lua", "w")
    f:write(script)
    f:close()
end

-- Main program
local num_cores = get_cpu_cores()
print("Running with " .. num_cores .. " cores")

--local lines = lines_from("input.txt")
local chunk_size = math.ceil(#lines / num_cores)

-- Write chunk files
local chunk_files = {}
for i = 1, num_cores do
    local chunk_name = string.format("chunk_%d.txt", i)
    local f = io.open(chunk_name, "w")
    local start_idx = (i - 1) * chunk_size + 1
    local end_idx = math.min(i * chunk_size, #lines)
    for j = start_idx, end_idx do
        f:write(lines[j] .. "\n")
    end
    f:close()
    table.insert(chunk_files, chunk_name)
end

-- Write the processor script
write_chunk_processor()

-- Start all processes
local processes = {}
for i, chunk_file in ipairs(chunk_files) do
    local handle = io.popen(string.format("lua chunk_processor.lua %s", chunk_file))
    table.insert(processes, handle)
end

-- Collect results
local total = 0
for _, handle in ipairs(processes) do
    local result = handle:read("*a")
    total = total + tonumber(result)
end

-- Clean up
for _, handle in ipairs(processes) do
    handle:close()
end
for _, file in ipairs(chunk_files) do
    os.remove(file)
end
os.remove("chunk_processor.lua")

print("Part 2:", total)
