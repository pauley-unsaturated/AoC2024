
local open = io.open

local function read_file(path)
    local file = open(path, "rb") -- r read mode and b binary mode
    if not file then return nil end
    local content = file:read "*a" -- *a or *all reads the whole file
    file:close()
    return content
end

local fileContent = read_file("foo.html");
print (fileContent);


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

-- tests the functions above
-- local file = 'test.lua'
local file = 'input.txt'
local lines = lines_from(file)

-- print all line numbers and their contents
for k,v in pairs(lines) do
   print('line[' .. k .. ']', v)
   local number = number_from(v)
   if number then
      print('number: ' .. number_from(v))
   else
      print('not a number!: ' .. v)
   end
end


