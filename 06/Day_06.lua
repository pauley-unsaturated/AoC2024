-- Helper function to find the guard's starting position and direction
function find_start(grid)
    local dir_to_vector = {
        ['^'] = { 0, -1 },
        ['>'] = { 1, 0 },
        ['v'] = { 0, 1 },
        ['<'] = { -1, 0 }
    }

    for y = 1, #grid do
        for x = 1, #grid[1] do
            local c = grid[y]:sub(x, x)
            if dir_to_vector[c] then
                return x, y, dir_to_vector[c]
            end
        end
    end
end

function turn_right(dir)
    return { -dir[2], dir[1] }
end

function in_bounds(x, y, grid)
    return y >= 1 and y <= #grid and x >= 1 and x <= #grid[1]
end

function pos_to_key(x, y)
    return x .. "," .. y
end

function solve_part1(input)
    -- Parse input into grid
    local grid = {}
    for line in input:gmatch("[^\r\n]+") do
        table.insert(grid, line)
    end

    local x, y, dir = find_start(grid)

    local visited = {}
    visited[pos_to_key(x, y)] = true
    local count = 1

    -- Add safety counter to prevent infinite loops
    local steps = 0
    local max_steps = #grid * #grid[1] * 4 -- reasonable upper limit

    while steps < max_steps do
        steps = steps + 1

        -- Calculate next position
        local next_x = x + dir[1]
        local next_y = y + dir[2]

        -- Check if we're leaving the grid
        if not in_bounds(next_x, next_y, grid) then
            break
        end

        -- Check if we hit an obstacle
        if grid[next_y]:sub(next_x, next_x) == '#' then
            dir = turn_right(dir)
        else
            -- Move forward
            x, y = next_x, next_y
            local key = pos_to_key(x, y)
            if not visited[key] then
                visited[key] = true
                count = count + 1
            end
        end
    end

    return count
end

-- Test with example input
local test_input = [[....#.....
.........#
..........
..#.......
.......#..
..........
.#..^.....
........#.
#.........
......#...]]

-- print(solve_part1(test_input)) -- Should print 41

function load_input(filename)
    local file = io.open(filename, "r")
    if not file then
        print("Could not open input file")
        return nil
    end
    local content = file:read("*all")
    file:close()
    return content
end

-- Now you can use it with your existing solution:
local input = load_input("input.txt")
if input then
    local result = solve_part1(input)
    print("Result:", result)
end


function is_cycle(positions)
    -- We need at least 4 positions to have a cycle
    if #positions < 4 then return false end

    -- Look for repeated position+direction combinations
    local seen = {}
    for i, pos in ipairs(positions) do
        local key = pos.x .. "," .. pos.y .. "," .. pos.dir[1] .. "," .. pos.dir[2]
        if seen[key] then
            return true
        end
        seen[key] = true
    end
    return false
end

-- Modified solve_part1 that returns both count and visited positions
function simulate_guard(grid, start_x, start_y, start_dir)
    local x, y = start_x, start_y
    local dir = start_dir

    local visited = {}
    local state_seen = {} -- Track position+direction combinations
    visited[pos_to_key(x, y)] = true

    local steps = 0
    local max_steps = #grid * #grid[1] * 4

    while steps < max_steps do
        steps = steps + 1

        -- Check for cycle using O(1) lookup
        local state_key = x .. "," .. y .. "," .. dir[1] .. "," .. dir[2]
        if state_seen[state_key] then
            return true, visited
        end
        state_seen[state_key] = true

        local next_x = x + dir[1]
        local next_y = y + dir[2]

        if not in_bounds(next_x, next_y, grid) then
            return false, visited
        end

        if grid[next_y]:sub(next_x, next_x) == '#' then
            dir = turn_right(dir)
        else
            x, y = next_x, next_y
            local key = pos_to_key(x, y)
            visited[key] = true
        end
    end

    return false, visited
end

function solve_part2(input)
    local grid = {}
    for line in input:gmatch("[^\r\n]+") do
        table.insert(grid, line)
    end

    local start_x, start_y, start_dir = find_start(grid)
    print("Grid size:", #grid[1], "x", #grid)
    print("Starting position:", start_x, start_y)

    local _, original_visited = simulate_guard(grid, start_x, start_y, start_dir)

    local cycle_count = 0
    local tested = 0

    for pos_key in pairs(original_visited) do
        local x, y = pos_key:match("(%d+),(%d+)")
        x, y = tonumber(x), tonumber(y)

        if x ~= start_x or y ~= start_y then
            tested = tested + 1
            if tested % 100 == 0 then
                --print("Testing position", x, y, "(", tested, "positions tested)")
            end

            local test_grid = {}
            for i, line in ipairs(grid) do
                if i == y then
                    test_grid[i] = line:sub(1, x - 1) .. '#' .. line:sub(x + 1)
                else
                    test_grid[i] = line
                end
            end

            local has_cycle = simulate_guard(test_grid, start_x, start_y, start_dir)
            if has_cycle then
                cycle_count = cycle_count + 1
                --print("Found cycle at position", x, y)
            end
        end
    end

    return cycle_count
end

-- print(solve_part2(test_input)) -- Should print 6
print(solve_part2(input))
