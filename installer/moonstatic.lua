print("Moonstatic building NOW!")
local targetFiles = { }
local retCmd
retCmd = function(cmdd, argss)
  local retter = io.popen(cmdd .. " " .. argss)
  return retter
end
local getFilesInDir
getFilesInDir = function(dirr)
  local count = 1
  local filos = retCmd("ls", dirr)
  for namo in filos:lines() do
    targetFiles[count] = namo
    count = count + 1
  end
end
getFilesInDir(".")
for _index_0 = 1, #targetFiles do
  local filosss = targetFiles[_index_0]
  if string.find(filosss, ".lua") then
    os.execute("luastatic " .. filosss .. " /usr/local/lib/moonxxx/mnxx/ll_53_standard/src/liblua.a " .. "-I/usr/local/lib/moonxxx/mnxx/ll_53_standard/src")
    os.execute("mkdir src && mv " .. filosss .. " src")
  end
  if string.find(filosss, ".lua.c") then
    os.execute("mv " .. filosss .. " src")
  end
  if string.find(filosss, ".moon") then
    os.execute("moonc " .. filosss)
    getFilesInDir(".")
    for _index_1 = 1, #targetFiles do
      local filosr = targetFiles[_index_1]
      if string.find(filosr, ".lua") then
        os.execute("luastatic " .. filosr .. " /usr/local/lib/moonxxx/mnxx/ll_53_standard/src/liblua.a " .. "-I/usr/local/lib/moonxxx/mnxx/ll_53_standard/src")
        os.execute("mkdir src && mv " .. filosr .. " src")
      end
      if string.find(filosr, ".lua.c") then
        os.execute("mv " .. filosss .. " src")
      end
    end
  end
end
