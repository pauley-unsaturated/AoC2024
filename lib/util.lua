
function map(collection, func)
   local result = {}
   for k, v in pairs(collection) do
      result[k] = func(v)
   end
   return result
end

function reduce(collection, initial, func)
    local result = initial
    for k, v in pairs(collection) do
        result = func(result, v)
    end
    return result
end

function sum(collection)
    return reduce(collection, 0, function (acc, next)
        return acc + next
    end )
end

function equal_simple(t1, t2)
   if #t1 == #t2 then
      for i=1,#t1 do
	 if not (t1[i] == t2[i]) then return false end
      end
      return true
   else
      return false
   end
end

function copy_simple(t)
   local result = {}
   for k, v in pairs(t) do
      result[k] = v
   end
   return result
end

function print_simple_table(t)
   for k, v in pairs(t) do
      print("[" .. tostring(k) .. "]: " .. tostring(v))
   end
   print(" ")
end

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


-- could be a filter?
function skip_idx_table(t, s)
   local result = {}
   local i = 1
   for k, v in pairs(t) do
      if not (k == s) then
	 result[i] = v
	 i = i + 1
      end
   end
   return result
end
