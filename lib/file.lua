local open = io.open

local function read_file(path)
    local file = open(path, "rb") -- r read mode and b binary mode
    if not file then return nil end
    local content = file:read "*a" -- *a or *all reads the whole file
    file:close()
    return content
end


-- see if the file exists
function file_exists(file)
  local f = io.open(file, "rb")
  if f then f:close() end
  return f ~= nil
end

-- get all lines from a file, returns an empty 
-- list/table if the file does not exist
function lines_from(file)
  if not file_exists(file) then return {} end
  local lines = {}
  for line in io.lines(file) do 
    lines[#lines + 1] = line
  end
  return lines
end

function number_from(line)
   _, _, num = string.find(line, "(%d+)")
   if num then
      return tonumber(num)
   else
      return nil
   end
end

function numbers_from(line)
   local result = {}
   for n in string.gmatch(line, "%d+") do
      local num_n = tonumber(n)
      if num_n then
	 table.insert(result, num_n)
      end
   end
   return result
end
