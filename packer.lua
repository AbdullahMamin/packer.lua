-- Copyright (C) 2026 Abdullah M.Amin Abdullah
-- 
-- Permission is hereby granted, free of charge, to any person obtaining a copy of this software and associated documentation files (the “Software”), to deal in the Software without restriction, including without limitation the rights to use, copy, modify, merge, publish, distribute, sublicense, and/or sell copies of the Software, and to permit persons to whom the Software is furnished to do so, subject to the following conditions:
-- 
-- The above copyright notice and this permission notice shall be included in all copies or substantial portions of the Software.
-- 
-- THE SOFTWARE IS PROVIDED “AS IS”, WITHOUT WARRANTY OF ANY KIND, EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.

-- packer.lua: script for converting a directory tree of assets into a simple packed format to distribute with application binaries.
-- This script relies on the GNU "find" utility.

local MAGIC_NUMBER = 69696767

-- Read a raw binary file and return as string
local function ReadRawFile(filepath)
    local file = assert(io.open(filepath, "rb"))
    local str = file:read("*all")
    file:close()
    return str
end

if #arg ~= 3 or (arg[1] ~= "pack" and arg[1] ~= "unpack") then
    print("Copyright (C) 2026 Abdullah M.Amin Abdullah - Licensed under the MIT license <https://mit-license.org/>")
    print("packer.lua usage:")
    print("- lua packer.lua <in_directory> <out_file>")
end

local filelist = {}
local in_dir = arg[2]
local out_file = arg[3]
if in_dir:sub(#in_dir, #in_dir) ~= '/' then
    in_dir = in_dir .. '/'
end
local files = assert(io.popen("find " .. in_dir .. " -type f"))
for line in files:lines() do
    filename = line:gsub(in_dir, "", 1)
    filelist[#filelist + 1] = {
        ["name"] = filename,
        ["data"] = ReadRawFile(line)
    }
end
local file = assert(io.open(out_file, "wb"))
file:write(string.pack("<I4", MAGIC_NUMBER))
file:write(string.pack("<I4", #filelist))
for _, f in pairs(filelist) do
    file:write(f.name)
    file:write(string.pack("B", 0))
    file:write(string.pack("<I4", #f.data))
end
for _, f in pairs(filelist) do
    file:write(f.data)
end
file:close()
