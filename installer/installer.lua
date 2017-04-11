print("This installer was written in moonscript and compiled with moonscript++ | Lynxish Assembler")
local targetFiles = { }
local libinstalldir, cmdnB, mods, installerr
libinstalldir = "/usr/local/lib/moonxxx"
os.execute("sudo mkdir " .. libinstalldir)
cmdnB = {
  config = function(self, dirr)
    return os.execute("cd " .. dirr .. " && sudo ./configure")
  end,
  askSudo = function(self, str)
    return os.execute("sudo " .. str)
  end,
  unZipInstall = function(self, what, where)
    print("Extracting " .. what .. "...")
    return self:askSudo("tar xf " .. what .. " -C " .. where)
  end,
  makeB = function(self, dirr, argss)
    if argss == nil then
      argss = ""
    end
    print("Making " .. dirr)
    return os.execute("cd " .. dirr .. " && sudo make" .. argss)
  end,
  copyMach = function(self, what, where)
    self:askSudo("cp " .. what .. " " .. where)
    return print("Copied " .. what)
  end,
  movER = function(self, what, where)
    return self:askSudo("mv " .. what .. " " .. where)
  end,
  retCmd = function(self, cmdd, argss)
    local retter = io.popen(cmdd .. " " .. argss)
    return retter
  end,
  buildSpec = function(self, nameo)
    return self:askSudo("luarocks install " .. nameo)
  end
}
mods = {
  getFilesInDir = function(self, dirr)
    local count = 1
    local filos = cmdnB:retCmd("/bin/ls", dirr)
    for namo in filos:lines() do
      targetFiles[count] = namo
      count = count + 1
    end
  end
}
installerr = {
  extract = function(self)
    mods:getFilesInDir(".")
    for _index_0 = 1, #targetFiles do
      local tfil = targetFiles[_index_0]
      if tfil == "mnxx.tar.gz" then
        cmdnB:unZipInstall(tfil, libinstalldir)
      elseif tfil == "moonxx" then
        cmdnB:copyMach(tfil, "/usr/local/bin")
      elseif tfil == "moonstatic" then
        cmdnB:copyMach(tfil, "/usr/local/bin")
      elseif tfil == "Release" then
        os.execute("sudo cp -r Release/* /usr/local/lib/moonxxx")
      elseif tfil == "moonXx" then
        os.execute("sudo cp moonXx/moonxx /usr/local/bin")
      end
    end
  end,
  makersMark = function(self)
    mods:getFilesInDir(libinstalldir .. "/mnxx")
    for _index_0 = 1, #targetFiles do
      local tdirs = targetFiles[_index_0]
      if tdirs == "luarocks" then
        cmdnB:config(libinstalldir .. "/mnxx/" .. tdirs)
        cmdnB:makeB(libinstalldir .. "/mnxx/" .. tdirs, " build")
        cmdnB:makeB(libinstalldir .. "/mnxx/" .. tdirs, " install")
        mods:getFilesInDir(libinstalldir .. "/mnxx")
        for _index_1 = 1, #targetFiles do
          local tddirs = targetFiles[_index_1]
          if tddirs == "moonscript" then
            os.execute("sudo luarocks install moonscript")
          end
          if tddirs == "luastatic" then
            os.execute("sudo luarocks install luastatic")
          end
        end
      elseif tdirs == "ll_53_standard" then
        os.execute("mkdir ~/ll_53")
        cmdnB:makeB(libinstalldir .. "/mnxx/" .. tdirs, " linux")
        cmdnB:copyMach(libinstalldir .. "/mnxx/" .. tdirs .. "/src/lua", "~/ll_53")
        cmdnB:copyMach(libinstalldir .. "/mnxx/" .. tdirs .. "/src/liblua.a", "~/ll_53")
      elseif tdirs == "ll_53_jit" then
        os.execute("mkdir ~/ll_53")
        os.execute("mkdir ~/ll_53/jit")
        cmdnB:makeB(libinstalldir .. "/mnxx/" .. tdirs, "")
      end
    end
  end
}
installerr:extract()
return installerr:makersMark()
