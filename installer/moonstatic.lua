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
  local filos = retCmd("/bin/ls", dirr)
  for namo in filos:lines() do
    targetFiles[count] = namo
    count = count + 1
  end
end
getFilesInDir(".")
for _index_0 = 1, #targetFiles do
  local filosss = targetFiles[_index_0]
  if string.find(filosss, ".lua") then
    os.execute("luastatic " .. filosss .. " /usr/local/lib/moonxxx/mnxx/ll_53_standard/src/liblua.a " .. "-I/usr/local/lib/moonxxx/mnxx/ll_53_standard/src/lua")
  end
end
