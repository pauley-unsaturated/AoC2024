
package.path = package.path ..  ";../lib/?.lua"

require "file"
require "util"

input_file = "input.txt"
--input_file = "test.txt"

local lines = lines_from(input_file)
reports = map(lines, function (line)
		 return numbers_from(line)
end)


function is_safe(report)
   -- Safe if ascending or descending
   local sorted = copy_simple(report)
   table.sort(sorted, function (a, b) return a < b end)
   
   local is_inc = equal_simple(report, sorted)
   table.sort(sorted, function (a, b) return a > b end)
   
   local is_dec = equal_simple(report, sorted)
   
   if is_inc or is_dec then
      for i=1,#report-1 do
	 local diff = math.abs(report[i] - report[i+1])
	 if diff < 1 or diff > 3 then
	    return false
	 end
      end      
      return true
   end
   
   return false
end



local results_1 = map(reports, is_safe)

local result_1 = 0
for i=1,#results_1 do
   if results_1[i] then result_1 = result_1 + 1 end      
end

print("Part 1: " .. tostring(result_1))

function is_safe_skipping(report, s)
   -- Safe if ascending or descending
   local skipped = skip_idx_table(report, s)
   return is_safe(skipped)
end

function is_safe_skipping_any(report)
   if is_safe(report) then
      return true
   end
   
   for i=1,#report do
      if is_safe_skipping(report, i) then return true end
   end

   return false
end

local results_2 = map(reports, is_safe_skipping_any)
local result_2 = 0
for i=1,#results_2 do
   if results_2[i] then result_2 = result_2 + 1 end      
end
print("Part 2: " .. tostring(result_2))

