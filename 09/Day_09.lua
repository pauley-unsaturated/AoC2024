function expand_disk_map(input)
    local result = {}
    local file_id = 0
    local is_file = true -- alternates between file and space

    for digit in input:gmatch("%d") do
        local length = tonumber(digit)
        for _ = 1, length do
            if is_file then
                table.insert(result, file_id)
            else
                table.insert(result, ".")
            end
        end
        if is_file then file_id = file_id + 1 end
        is_file = not is_file
    end
    return result
end

function compact_disk(disk)
    local left = 1
    local right = #disk

    while left < right do
        -- Find next gap from left
        while left < right and disk[left] ~= "." do
            left = left + 1
        end

        -- Find next digit from right
        while left < right and disk[right] == "." do
            right = right - 1
        end

        -- Swap if we found both a gap and a digit
        if left < right and disk[left] == "." and disk[right] ~= "." then
            disk[left], disk[right] = disk[right], disk[left]
        end
    end
    return disk
end

function calculate_checksum(disk)
    local sum = 0
    for i = 1, #disk do
        if disk[i] ~= "." then
            sum = sum + (i - 1) * disk[i]
        end
    end
    return sum
end

function solve(input)
    local disk = expand_disk_map(input)
    disk = compact_disk(disk)
    return calculate_checksum(disk)
end

local function read_input()
    local file = io.open("input.txt", "r")
    if not file then
        error("Could not open input.txt")
    end
    local content = file:read("*all")
    file:close()
    -- Remove any trailing whitespace or newlines
    content = content:gsub("%s+$", "")
    return content
end

-- local input = "2333133121414131402"
local input = read_input()
local result_1 = solve(input)
print("Part 1: " .. tostring(result_1))

function print_disk(disk)
    local result = ""
    for i = 1, #disk do
        if disk[i] == "." then
            result = result .. "."
        else
            result = result .. disk[i]
        end
    end
    print(result)
end

function compact_disk_whole_files(disk)
    local right = #disk
    while right > 1 do
        -- Find start of rightmost file
        while right > 1 and disk[right] == "." do
            right = right - 1
        end
        if right <= 1 then break end

        -- Measure file length and get ID
        local file_id = disk[right]
        local file_length = 0
        local file_start = right
        while right > 0 and disk[right] == file_id do
            file_length = file_length + 1
            right = right - 1
        end

        -- Look for leftmost gap that can fit this file
        local left = 1
        while left < file_start do
            -- Find start of gap
            while left < file_start and disk[left] ~= "." do
                left = left + 1
            end
            if left >= file_start then break end

            -- Measure gap length
            local gap_length = 0
            local gap_start = left
            while left < file_start and disk[left] == "." do
                gap_length = gap_length + 1
                left = left + 1
            end

            -- If gap is big enough, move file here
            if gap_length >= file_length then
                -- Move file
                for i = 0, file_length - 1 do
                    disk[gap_start + i] = file_id
                    disk[file_start - i] = "."
                end
                --print_disk(disk)
                break
            end
        end
    end
    return disk
end

function solve_2(input)
    local disk = expand_disk_map(input)
    disk = compact_disk_whole_files(disk)
    return calculate_checksum(disk)
end

local result_2 = solve_2(input)
print("Part 2: " .. tostring(result_2))
