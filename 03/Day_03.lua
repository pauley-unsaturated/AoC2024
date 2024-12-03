package.path = package.path .. ";../lib/?.lua"
require "file"
require "util"

function find_multiplications(input_string)
    local results = {}

    -- Pattern to match mul(x,y) where x and y are numbers
    -- Captures the numbers between parentheses
    for x, y in input_string:gmatch("mul%((%d%d?%d?),(%d%d?%d?)%)") do
        -- Convert strings to numbers and multiply
        local result = tonumber(x) * tonumber(y)
        table.insert(results, result)
    end

    return results
end

-- local input = "xmul(2,4)%&mul[3,7]!@^do_not_mul(5,5)+mul(32,64]then(mul(11,8)mul(8,5))"
-- local input = "xmul(2,4)&mul[3,7]!^don't()_mul(5,5)+mul(32,64](mul(11,8)undo()?mul(8,5))"
local input = read_file("input.txt")
local output = find_multiplications(input)

print("Part 1: " .. tostring(sum(output)))
function find_multiplications_with_disabled(input_string)
    local results = {}
    local current_pos = 1
    local enabled = true

    while current_pos <= #input_string do
        -- Look for the next command (either don't(), do(), or mul())
        local dont_pos = input_string:find("don't%(%)", current_pos)
        local do_pos = input_string:find("do%(%)", current_pos)
        local mul_pos = input_string:find("mul%(%d%d?%d?,%d%d?%d?%)", current_pos)

        -- If no more commands found, break
        if not (dont_pos or do_pos or mul_pos) then
            break
        end

        -- Find the next relevant position
        local next_pos = math.huge
        if dont_pos then next_pos = math.min(next_pos, dont_pos) end
        if do_pos then next_pos = math.min(next_pos, do_pos) end
        if mul_pos then next_pos = math.min(next_pos, mul_pos) end

        -- Process the next command
        if mul_pos and mul_pos == next_pos and enabled then
            -- Extract and process multiplication if enabled
            local x, y = input_string:match("mul%((%d%d?%d?),(%d%d?%d?)%)", mul_pos)
            local result = tonumber(x) * tonumber(y)
            table.insert(results, result)
            current_pos = mul_pos + 1
        elseif dont_pos and dont_pos == next_pos then
            enabled = false
            current_pos = dont_pos + 6 -- length of "don't()"
        elseif do_pos and do_pos == next_pos then
            enabled = true
            current_pos = do_pos + 4 -- length of "do()"
        else
            current_pos = next_pos + 1
        end
    end

    return results
end

function find_multiplications_with_disabled_simpler(input_string)
    -- First remove everything between don't() and do()
    local cleaned = input_string:gsub("don't%(%)(.-)do%(%)", "")

    -- Then process the multiplications in the remaining text
    local results = {}
    for x, y in cleaned:gmatch("mul%((%d%d?%d?),(%d%d?%d?)%)") do
        local result = tonumber(x) * tonumber(y)
        table.insert(results, result)
    end

    return results
end

local output_2 = find_multiplications_with_disabled_simpler(input)
print_simple_table(output_2)

print("Part 2: " .. tostring(sum(output_2)))
