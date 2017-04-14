local JustCompd, TargetFiles, KeepModules, CmdnB, Mods, Search, DoCompile, CompGcc, CompClang, MoonFunction, Cleaner, CheckArgs, ParseArgs
JustCompd = ""
TargetFiles = { }
KeepModules = { }
local colors = require("ansicolors")
CmdnB = {
  Config = function(self, dirr)
    return os.execute("cd " .. dirr .. " && sudo ./configure")
  end,
  AskSudo = function(self, str)
    return os.execute("sudo " .. str)
  end,
  UnZipInstall = function(self, what, where)
    print("Extracting " .. what .. "...")
    return self:AskSudo("tar xf " .. what .. " -C " .. where)
  end,
  MakeB = function(self, dirr, argss)
    if argss == nil then
      argss = ""
    end
    print("Making " .. dirr)
    return os.execute("cd " .. dirr .. " && sudo make" .. argss)
  end,
  CopyMach = function(self, what, where)
    self:AskSudo("cp " .. what .. " " .. where)
    return print("Copied " .. what)
  end,
  MovER = function(self, what, where)
    return self:AskSudo("mv " .. what .. " " .. where)
  end,
  RetCmd = function(self, cmdd, argss)
    local retter = io.popen(cmdd .. " " .. argss)
    return retter
  end,
  BuildSpec = function(self, nameo)
    return self:AskSudo("luarocks install " .. nameo)
  end
}
Mods = {
  GetFilesInDir = function(self, dirr)
    local count = 1
    local filos = CmdnB:RetCmd("/bin/ls", dirr)
    for namo in filos:lines() do
      TargetFiles[count] = namo
      count = count + 1
    end
  end,
  CompileLua = function(self, compilr, filosi, requirez, compargs)
    if compilr == nil then
      compilr = "CC=gcc"
    end
    local noMods = true
    local secspace = " "
    local includes = ""
    if compilr == "" then
      compilr = "gcc"
    end
    if requirez ~= nil then
      noMods = false
      for _index_0 = 1, #requirez do
        local incl = requirez[_index_0]
        includes = includes .. incl .. " "
      end
    end
    if requirez == nil then
      noMods = true
      includes = ""
      secspace = ""
    end
    if noMods == false then
      print(colors("%{green bright}Linked Modules: " .. includes))
    end
    if compargs ~= "" then
      if noMods == false then
        for _index_0 = 1, #requirez do
          local filll = requirez[_index_0]
          print(colors("%{yellow}Compiling with: " .. filll .. " as a module"))
        end
      elseif noMods == true then
        print(colors("%{yellow bright}Compiling with no modules%{reset} " .. filosi))
        os.execute("CC=" .. compilr .. " luastatic " .. filosi .. " /usr/local/lib/moonxxx/mnxx/ll_53_standard/src/liblua.a -I/usr/local/lib/moonxxx/mnxx/ll_53_standard/src " .. compargs)
      end
      if noMods == false then
        os.execute("CC=" .. compilr .. " luastatic " .. filosi .. " " .. includes .. secspace .. "/usr/local/lib/moonxxx/mnxx/ll_53_standard/src/liblua.a " .. "-I/usr/local/lib/moonxxx/mnxx/ll_53_standard/src " .. compargs)
      end
      JustCompd = filosi
    elseif compargs == "" then
      print(colors("%{magenta bright}Main program entry file: " .. filosi))
      if noMods == false then
        for _index_0 = 1, #requirez do
          local filll = requirez[_index_0]
          print(colors("%{yellow}Compiling with: " .. filll .. " as a module"))
        end
      elseif noMods == true then
        print(colors("%{yellow bright}Compiling with no modules%{reset} " .. filosi))
        os.execute("CC=" .. compilr .. " luastatic " .. filosi .. " /usr/local/lib/moonxxx/mnxx/ll_53_standard/src/liblua.a -I/usr/local/lib/moonxxx/mnxx/ll_53_standard/src")
      end
      if noMods == false then
        os.execute("CC=" .. compilr .. " luastatic " .. filosi .. " " .. includes .. secspace .. "/usr/local/lib/moonxxx/mnxx/ll_53_standard/src/liblua.a " .. "-I/usr/local/lib/moonxxx/mnxx/ll_53_standard/src")
      end
      JustCompd = filosi
    end
  end,
  BuildAllMoon = function(self, filosi)
    for _index_0 = 1, #filosi do
      local filoz = filosi[_index_0]
      os.execute("moonc " .. filoz)
      os.execute("echo Built with moon-compiler version: && moonc -v")
    end
  end,
  BuildMoon = function(self, filo)
    os.execute("moonc " .. filo)
    return os.execute("echo Built with moon-compiler version: && moonc -v")
  end
}
Search = {
  ForExt = function(self, dir, ext)
    local retTable = { }
    local count = 1
    Mods:GetFilesInDir(dir)
    for _index_0 = 1, #TargetFiles do
      local fil = TargetFiles[_index_0]
      local indx, eindx = string.find(fil, ext)
      local lngth = #fil
      if indx ~= nil then
        local theExt = string.sub(fil, indx, eindx)
        if ext == theExt then
          if lngth == eindx then
            retTable[count] = fil
            count = count + 1
            if fil ~= "./src" then
              print(colors("%{cyan bright}Found " .. fil))
            end
          end
        end
      end
    end
    return retTable
  end
}
DoCompile = {
  MoonWholeDir = function(self, dirr)
    local tFiles = Search:ForExt(dirr, ".moon")
    return Mods:BuildAllMoon(tFiles)
  end,
  CompileWholeDir = function(self, dirr, mainf, compiler, cargs)
    local sendTable = { }
    local count = 1
    local tFiles = Search:ForExt(dirr, ".lua")
    for _index_0 = 1, #tFiles do
      local fil = tFiles[_index_0]
      if fil ~= mainf then
        sendTable[count] = fil
        count = count + 1
      end
    end
    KeepModules = sendTable
    return Mods:CompileLua(compiler, mainf, sendTable, cargs)
  end,
  MoonFile = function(self, filee)
    return Mods:BuildMoon(filee)
  end
}
CompGcc = {
  CompileCrntDir = function(self, main, cargss)
    MoonFunction:BuildCrntDir()
    return DoCompile:CompileWholeDir(".", main, "gcc", cargss)
  end,
  CompileDir = function(self, dir, main, cargs)
    MoonFunction:BuildWholeMoonDir(dir)
    return DoCompile:CompileWholeDir(dir, main, "gcc", cargs)
  end
}
CompClang = {
  CompileCrntDir = function(self, main, cargss)
    MoonFunction:BuildCrntDir()
    return DoCompile:CompileWholeDir(".", main, "clang", cargss)
  end,
  CompileDir = function(self, dir, main, cargs)
    MoonFunction:BuildWholeMoonDir(dir)
    return DoCompile:CompileWholeDir(dir, main, "clang", cargs)
  end
}
MoonFunction = {
  BuildCrntDir = function(self)
    return DoCompile:MoonWholeDir(".")
  end,
  BuildSingleMoon = function(self, filee)
    return DoCompile:MoonFile(filee)
  end,
  BuildWholeMoonDir = function(self, dirr)
    return DoCompile:MoonWholeDir(dirr)
  end
}
Cleaner = {
  DirectoryOutputs = function(self, dir, delete, modulesn)
    if delete == nil then
      delete = false
    end
    if modulesn == nil then
      modulesn = KeepModules
    end
    if modulesn == nil then
      modulesn = Search:ForExt(dir, ".lua")
    end
    local countLock = 0
    if delete == true then
      local tFiles = Search:ForExt(dir, ".lua.c")
      for _index_0 = 1, #tFiles do
        local fil = tFiles[_index_0]
        os.execute("rm " .. fil)
        print(colors("%{red}Removed output file: " .. fil))
      end
    elseif delete == false then
      local hasSrcDir = false
      Mods:GetFilesInDir(dir)
      for _index_0 = 1, #TargetFiles do
        local fils = TargetFiles[_index_0]
        if fils == "src" then
          hasSrcDir = true
        elseif fils ~= "src" then
          local doubleCheck = Search:ForExt(dir, "src")
          for _index_1 = 1, #doubleCheck do
            local isit = doubleCheck[_index_1]
            if isit ~= nil then
              hasSrcDir = true
            end
          end
        end
      end
      if hasSrcDir == true then
        local tFiles = Search:ForExt(dir, ".lua.c")
        for _index_0 = 1, #tFiles do
          local fil = tFiles[_index_0]
          os.execute("mv " .. fil .. " " .. dir .. "/src")
          print(colors("%{blue underline}Moved: " .. fil .. " to " .. dir .. "/src"))
        end
        tFiles = Search:ForExt(dir, ".lua")
        for _index_0 = 1, #tFiles do
          local fil = tFiles[_index_0]
          for _index_1 = 1, #modulesn do
            local mod = modulesn[_index_1]
            if mod ~= fil then
              os.execute("mv " .. fil .. " " .. dir .. "/src")
              os.execute("cp " .. dir .. "/src/* .")
              print(colors("%{blue underline}Moved: " .. fil .. " to " .. dir .. "/src"))
              print(colors("%{red bright}keep compiled executable in same folder as required modules."))
            elseif mod == fil then
              print(colors("%{green underline}Not moving needed module: " .. mod))
            end
          end
        end
      end
      if hasSrcDir == false then
        do
          countLock = 0
          if countLock then
            os.execute("mkdir " .. dir .. "/src")
            countLock = countLock + 1
          end
        end
        return self:DirectoryOutputs(dir, false)
      end
    end
  end
}
local agone = arg[1]
local agtwo = arg[2]
local agthree = arg[3]
local agfour = arg[4]
local agfive = arg[5]
local agsix = arg[6]
CheckArgs = function()
  local cleanMode = false
  if agone == "help" then
    print(colors("%{red bright}moonxx%{reset} %{blue bright}leave-blank%{reset} | %{yellow bright}clean%{reset} | %{cyan bright}compile%{reset}\n\n\n%{cyan}Note:%{reset} if you run moonxx and leave arguments blank and Moonscript++ will make value default, which will be listed below.\n\n--\n%{blue bright}If left blank (ex.%{reset} %{red bright}moonxx%{reset}%{blue bright} ) Moonscript++ will compile all%{reset} %{yellow bright}.moon%{reset} %{blue bright}and%{reset} %{yellow bright}.lua%{reset} %{blue bright}files found in directory, and each%{reset} %{yellow bright}.lua / .moon%{reset} %{blue bright}file will be\ndynamically included in the currently being compiled moonscript(or lua) file.\n__________________________________________________________________________\n\n%{yellow bright}clean | Options: %{reset}%{green bright}remove%{reset}%{yellow bright} / %{reset}%{magenta bright} move%{reset}\n%{green bright} remove : will delete all noise (.lua.c) files. These can be regenerated, so dont worry.%{reset}\n%{magenta bright} move : creates a src directory and copies .lua.c and .lua files into the directory%{reset}\n%{yellow bright}ex.%{reset} %{red bright} moonxx clean remove%{reset}\n__________________________________________________________________________\n\n%{cyan bright} compile | Options: %{reset}%{red bright}File name%{reset}    | %{cyan bright}This will compile a single file with no modules%{reset}\n%{cyan bright}ex.%{reset} %{red bright} moonxx compile myFile.moon%{reset}\n"))
  elseif agone == "clean" then
    if agtwo ~= nil then
      if agtwo == "remove" then
        if agthree ~= nil then
          cleanMode = true
          Cleaner:DirectoryOutputs(agthree, true, nil)
        elseif agthree == nil then
          cleanMode = true
          Cleaner:DirectoryOutputs(".", true, nil)
        end
      elseif agtwo == "move" then
        if agthree ~= nil then
          cleanMode = true
          Cleaner:DirectoryOutputs(agthree, false, nil)
        elseif agthree == nil then
          cleanMode = true
          Cleaner:DirectoryOutputs(".", false, nil)
        end
      elseif agtwo == nil then
        cleanMode = true
        Cleaner:DirectoryOutputs(".", false, nil)
      end
    end
  elseif agone == nil then
    local sendTab = { }
    local buildAllEm = Search:ForExt(".", ".moon")
    for _index_0 = 1, #buildAllEm do
      local filz = buildAllEm[_index_0]
      os.execute("moonc " .. filz)
    end
    local doAllEm = Search:ForExt(".", ".lua")
    for _index_0 = 1, #doAllEm do
      local lfil = doAllEm[_index_0]
      DoCompile:CompileWholeDir(".", lfil, "gcc", "")
    end
  elseif agone == "compile" then
    local Mode = "compile"
  end
  if agtwo ~= nil then
    if cleanMode == false then
      local MainFil = agtwo
      if agthree ~= nil then
        local Target = agthree
        if agfour == "current" then
          local Dir = "current"
          if agfive == "none" then
            local Cargss = "none"
          elseif agfive ~= "none" then
            local Cargss = agfive
          end
        elseif agfour ~= "current" then
          local Dir = agfour
          if agfive == "none" then
            local Cargss = "none"
            if agsix ~= nil then
              local Compilly = agsix
              return ParseArgs:CheckTarget()
            elseif agsix == nil then
              local Compilly = "gcc"
              return ParseArgs:CheckTarget()
            end
          elseif agfive ~= "none" then
            local Cargss = agfive
            if agsix ~= nil then
              local Compilly = agsix
              return ParseArgs:CheckTarget()
            end
          elseif agfive == nil then
            local Cargss = ""
            local Compilly = "gcc"
            return ParseArgs:CheckTarget()
          end
        end
      elseif agthree == nil then
        if MainFil ~= nil then
          return Mods:CompileLua("gcc", MainFil, nil, "")
        end
      end
    end
  elseif agtwo == nil then
    if cleanMode == false then
      if MainFil ~= nil then
        return Mods:CompileLua("gcc", MainFil, nil, "")
      end
    end
  end
end
ParseArgs = {
  CheckMode = function(self)
    if MainFil ~= nil then
      return true
    elseif Mode ~= "compile" then
      return true
    end
  end,
  CheckTarget = function(self)
    if self:CheckMode() == true then
      if Target == "all" then
        if Dir == "current" then
          if Compilly == "clang" then
            return CompClang:CompileCrntDir(MainFil, Cargss)
          elseif Compilly == "gcc" then
            return CompGcc:CompileCrntDir(MainFil, Cargss)
          end
        elseif Dir ~= "current" then
          if Compilly == "clang" then
            return CompClang:CompileDir(Dir, MainFil, Cargss)
          elseif Compilly == "gcc" then
            return CompGcc:CompileDir(Dir, MainFil, Cargss)
          end
        end
      elseif Target ~= "all" then
        if Dir == "current" then
          if Compilly == "clang" then
            return Mods:CompileLua("CC=clang", MainFil, nil, Cargss)
          elseif Compilly == "gcc" then
            return Mods:CompileLua("CC=gcc", MainFil, nil, Cargss)
          end
        elseif Dir ~= "current" then
          if Compilly == "clang" then
            return Mods:CompileLua("CC=clang", MainFil, nil, Cargss)
          elseif Compilly == "gcc" then
            return Mods:CompileLua("CC=gcc", MainFil, nil, Cargss)
          end
        end
      end
    end
  end
}
CheckArgs()
return ParseArgs:CheckTarget()
