package.path = package.path .. ";../lib/?.lua"
require "file"
require "util"

--local lines = lines_from("test.txt")
local lines = lines_from("input.txt")
local height = #lines
local width = #lines[1]

print("width=" .. tostring(width) .. ", height=" .. tostring(height))

-- Function to check if a coordinate is within bounds
local function isInBounds(x, y, width, height)
    return x >= 1 and x <= width and y >= 1 and y <= height
end

-- Function to check if a word can be found starting at x,y in a specific direction
local function checkDirection(lines, x, y, dx, dy, word)
    if not isInBounds(x, y, #lines[1], #lines) then
        return false
    end

    for i = 1, #word do
        local newX = x + (i - 1) * dx
        local newY = y + (i - 1) * dy

        if not isInBounds(newX, newY, #lines[1], #lines) then
            return false
        end

        if lines[newY]:sub(newX, newX) ~= word:sub(i, i) then
            return false
        end
    end
    return true
end

-- Function to count all instances of XMAS starting at x,y
local function countXMASAt(lines, x, y)
    local count = 0
    local directions = {
        { 1,  0 },  -- right
        { -1, 0 },  -- left
        { 0,  1 },  -- down
        { 0,  -1 }, -- up
        { 1,  1 },  -- diagonal down-right
        { -1, 1 },  -- diagonal down-left
        { 1,  -1 }, -- diagonal up-right
        { -1, -1 }  -- diagonal up-left
    }

    for _, dir in ipairs(directions) do
        if checkDirection(lines, x, y, dir[1], dir[2], "XMAS") then
            count = count + 1
        end
    end

    return count
end

local totalCount = 0
for y = 1, height do
    for x = 1, width do
        totalCount = totalCount + countXMASAt(lines, x, y)
    end
end

print("Part 1: " .. totalCount)

local function checkDiagonal(lines, centerX, centerY, dirX, dirY, letter, maxDistance)
    for dist = 1, maxDistance do
        local x = centerX + (dirX * dist)
        local y = centerY + (dirY * dist)

        if isInBounds(x, y, #lines[1], #lines) and lines[y]:sub(x, x) == letter then
            return true, x, y
        end
    end
    return false
end

local function isXMASAt(lines, x, y)
    if (x - 1) <= 0 or (x + 1) > #lines[1]
        or (y - 1) <= 0 or (y + 1) > #lines
        or lines[y]:sub(x, x) ~= 'A' then
        return false
    end
    local count = 0

    local diagonals = {
        {
            { x - 1, y - 1 }, { x + 1, y + 1 } -- starting at top-left
        },
        {
            { x - 1, y + 1 }, { x + 1, y - 1 } -- starting at bottom-left
        },
        {
            { x + 1, y + 1 }, { x - 1, y - 1 } -- starting at top-left, reversed
        },
        {
            { x + 1, y - 1 }, { x - 1, y + 1 } -- starting at bottom-left
        }
    }

    for _, diagonal in ipairs(diagonals) do
        local m_x = diagonal[1][1]
        local m_y = diagonal[1][2]
        local s_x = diagonal[2][1]
        local s_y = diagonal[2][2]
        if lines[m_y]:sub(m_x, m_x) == "M"
            and lines[s_y]:sub(s_x, s_x) == "S" then
            count = count + 1
        end
    end
    return count >= 2
end

local function countAllXMAS(lines)
    local count = 0
    for y = 1, #lines do
        for x = 1, #lines[1] do
            if isXMASAt(lines, x, y) then
                count = count + 1
            end
        end
    end
    return count
end

local count_2 = countAllXMAS(lines)
print("Part 2: " .. count_2)
