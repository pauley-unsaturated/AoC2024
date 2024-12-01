
package.path = package.path ..  ";../lib/?.lua"

require "file"
require "util"

--local file = "test.txt"
local file = "part_1.txt"
local first_column = {}
local second_column = {}

-- Read the columns in

lines = lines_from(file)


for _, line in pairs(lines) do
   local numbers = numbers_from(line)
   table.insert(first_column, numbers[1])
   table.insert(second_column, numbers[2])
end

-- Now sort each column
table.sort(first_column)
table.sort(second_column)

local sum = 0

for i=1,#first_column do
   sum = sum + math.abs(first_column[i] - second_column[i])
end

print(sum)

-- Part 2
local right_entries = {}
for _, num in pairs(second_column) do
   if right_entries[num] then
      right_entries[num] = right_entries[num] + 1
   else
      right_entries[num] = 1
   end
end

local sum_2 = 0

for _, num in pairs(first_column) do
   if right_entries[num] then
      sum_2 = sum_2 + (num * right_entries[num])
   end
end


print(sum_2)
