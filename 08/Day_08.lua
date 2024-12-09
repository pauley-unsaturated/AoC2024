function read_map(input)
    local antennas = {}
    local height = 0
    local width = 0

    for y, line in ipairs(input) do
        height = height + 1
        width = #line
        for x = 1, #line do
            local char = line:sub(x, x)
            if char ~= '.' then
                table.insert(antennas, { x = x, y = y, freq = char })
            end
        end
    end

    return antennas, width, height
end

function in_bounds(x, y, width, height)
    return x >= 1 and x <= width and y >= 1 and y <= height
end

-- Calculate distance between two points
function distance(x1, y1, x2, y2)
    return math.sqrt((x2 - x1) ^ 2 + (y2 - y1) ^ 2)
end

function find_antinodes(a1, a2, width, height)
    local dx = a2.x - a1.x
    local dy = a2.y - a1.y
    local dist = distance(a1.x, a1.y, a2.x, a2.y)

    -- Unit vector in direction from a1 to a2
    local ux = dx / dist
    local uy = dy / dist

    local antinodes = {}
    -- Walk from left edge to right edge of grid
    for step = -width, width * 2 do -- extend beyond grid to catch all possibilities
        local x = a1.x + (ux * step)
        local y = a1.y + (uy * step)

        -- Round to nearest grid point
        local grid_x = math.floor(x + 0.5)
        local grid_y = math.floor(y + 0.5)

        -- If point is in bounds
        if in_bounds(grid_x, grid_y, width, height) then
            -- Check distances to both antennas
            local d1 = distance(grid_x, grid_y, a1.x, a1.y)
            local d2 = distance(grid_x, grid_y, a2.x, a2.y)

            -- Check if one distance is twice the other
            local epsilon = 0.0001
            if math.abs(d1 * 2 - d2) < epsilon or math.abs(d2 * 2 - d1) < epsilon then
                local key = string.format("%d,%d", grid_x, grid_y)
                antinodes[key] = true
            end
        end
    end

    return antinodes
end

function solve_part1(input)
    local antennas, width, height = read_map(input)
    local all_antinodes = {}

    -- Group antennas by frequency
    local freq_groups = {}
    for _, antenna in ipairs(antennas) do
        freq_groups[antenna.freq] = freq_groups[antenna.freq] or {}
        table.insert(freq_groups[antenna.freq], antenna)
    end

    -- For each frequency group
    for _, group in pairs(freq_groups) do
        -- For each pair in the group
        for i = 1, #group do
            for j = i + 1, #group do
                local nodes = find_antinodes(group[i], group[j], width, height)
                -- Merge found antinodes into all_antinodes
                for k, v in pairs(nodes) do
                    all_antinodes[k] = v
                end
            end
        end
    end

    -- Count unique antinodes
    local count = 0
    for _ in pairs(all_antinodes) do
        count = count + 1
    end

    return count, all_antinodes
end

function is_collinear(p, a1, a2)
    -- Using cross product to check collinearity
    local cross = (p.x - a1.x) * (a2.y - a1.y) - (p.y - a1.y) * (a2.x - a1.x)
    return math.abs(cross) < 0.0001
end

function find_antinodes_2(a1, a2, width, height)
    if a1.x == a2.x and a1.y == a2.y then return {} end

    local antinodes = {}

    -- Find the bounding box of the line plus some margin
    local min_x = math.min(a1.x, a2.x) - 1
    local max_x = math.max(a1.x, a2.x) + 1
    local min_y = math.min(a1.y, a2.y) - 1
    local max_y = math.max(a1.y, a2.y) + 1

    -- Check each grid point in the bounding box
    for y = 1, height do
        for x = 1, width do
            local p = { x = x, y = y }
            if is_collinear(p, a1, a2) then
                local key = string.format("%d,%d", x, y)
                antinodes[key] = true
            end
        end
    end

    return antinodes
end

function solve_part2(input)
    local antennas, width, height = read_map(input)
    local all_antinodes = {}

    -- Group antennas by frequency
    local freq_groups = {}
    for _, antenna in ipairs(antennas) do
        freq_groups[antenna.freq] = freq_groups[antenna.freq] or {}
        table.insert(freq_groups[antenna.freq], antenna)
    end

    -- For each frequency group
    for _, group in pairs(freq_groups) do
        -- For each pair in the group
        for i = 1, #group do
            for j = i + 1, #group do
                local nodes = find_antinodes_2(group[i], group[j], width, height)
                -- Merge found antinodes into all_antinodes
                for k, v in pairs(nodes) do
                    all_antinodes[k] = v
                end
            end
        end
    end

    -- Count unique antinodes
    local count = 0
    for _ in pairs(all_antinodes) do
        count = count + 1
    end

    return count, all_antinodes
end

function print_grid(input_lines, antinodes)
    -- Get grid dimensions
    local height = #input_lines
    local width = #input_lines[1]

    -- Create a copy of the input grid
    local grid = {}
    for y, line in ipairs(input_lines) do
        grid[y] = {}
        for x = 1, #line do
            grid[y][x] = line:sub(x, x)
        end
    end

    -- Mark antinodes
    for pos, _ in pairs(antinodes) do
        local x, y = pos:match("([^,]+),([^,]+)")
        x = math.floor(tonumber(x) + 0.5) -- Round to nearest integer
        y = math.floor(tonumber(y) + 0.5)
        if x >= 1 and x <= width and y >= 1 and y <= height then
            if grid[y][x] == '.' then -- Only replace empty spaces
                grid[y][x] = '#'
            end
        end
    end

    -- Print the grid
    for y = 1, height do
        local line = ""
        for x = 1, width do
            line = line .. grid[y][x]
        end
        print(line)
    end
end

-- Test with the example input
local test_input = [[
............
........0...
.....0......
.......0....
....0.......
......A.....
............
............
........A...
.........A..
............
............
]]

local real_input = [[
................n................L..Y.............
........m.........................................
.............n.............................l......
...............T.m..e....M........................
...........T..y...........i.......L.....2.........
.....................e.....h.......Y........l.....
...................i......d.......................
...5..............T....o......i...................
......C.5...........m..p...o.........2....I.......
.......C.n...........d..............o....p........
..............e........dp.....M...................
..8.........w.N.....n.p.....F.....................
.......N.......m.....D....o.......................
........DU...........y.........I..................
..D..X......N.T....M..............................
...........D..............2c..hl.A....M...........
.5.w.8...............h6...........................
5.....P...............d.Y.y......FA......L........
........w.................h.......................
...................N..............................
.............B...............u.f..................
.........wX.......6...............................
..............XC..............Ax..................
.P.......8......................c........f........
...e....U.u.........s.........f............Y......
..........U..X.........2..........W.....f.........
........P.........................................
.........s.u......................S...............
.....U...................c.....F............H.....
.........BC..........6............................
...................s..7..A...S............3I......
........B.s...u............S...i........H.........
..O.........................c....W....S...........
..........................a..........3......IE....
0........P................F.......................
.............7.................W........3.........
......t.W............7........................E...
...O.....9............................E...........
.....a19..........................................
....t.......O..........x..........................
..................................b..............3
........1......................b..................
.......1....8...........x.........................
.......40.........................................
.....t...O.0...4...........................H......
.......0..............x.......b...................
..4.......a.B..............b...........6..........
.......t9..........17..................H..........
........................9.........................
...........a......................................
]]

function split_lines(s)
    local lines = {}
    local i = 1
    for line in s:gmatch("[^\n]+") do
        lines[i] = line
        i = i + 1
    end
    return lines
end

--local input = split_lines(test_input)
local input = split_lines(real_input)

local result, all_antinodes = solve_part1(input)
print_grid(input, all_antinodes)
print(result)

local result2, all_antinodes2 = solve_part2(input)
print_grid(input, all_antinodes2)
print(result2)
