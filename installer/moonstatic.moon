print "Moonstatic building NOW!"
targetFiles = {}
retCmd = (cmdd,argss) ->
    retter = io.popen(cmdd .. " " .. argss)
    return retter
getFilesInDir = (dirr) ->
    count = 1
    filos = retCmd "/bin/ls",dirr
    for namo in filos\lines!
        targetFiles[count] = namo
        count = count + 1
getFilesInDir "."
for filosss in *targetFiles
    if string.find(filosss,".lua")
        os.execute("luastatic " .. filosss .. " /usr/local/lib/moonxxx/mnxx/ll_53_standard/src/liblua.a " .. "-I/usr/local/lib/moonxxx/mnxx/ll_53_standard/src/lua") 
        os.execute("mkdir src && mv " .. filosss .. " src")
    if string.find(filosss,".lua.c")
        os.execute("mv " .. filosss .. " src")