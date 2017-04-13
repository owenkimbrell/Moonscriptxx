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
    local secspace = " "
    local includes = ""
    if compilr == "" then
      compilr = "gcc"
    end
    if requirez ~= nil then
      for _index_0 = 1, #requirez do
        local incl = requirez[_index_0]
        includes = includes .. incl .. " "
      end
    elseif requirez == nil then
      includes = ""
      secspace = ""
    end
    print(colors("%{green bright}Linked Modules: " .. includes))
    if compargs ~= "" then
      for _index_0 = 1, #requirez do
        local filll = requirez[_index_0]
        print(colors("%{yellow}Compiling with: " .. filll .. " as a module"))
      end
      os.execute("CC=" .. compilr .. " luastatic " .. filosi .. " " .. includes .. secspace .. "/usr/local/lib/moonxxx/mnxx/ll_53_standard/src/liblua.a " .. "-I/usr/local/lib/moonxxx/mnxx/ll_53_standard/src " .. compargs)
      JustCompd = filosi
    elseif compargs == "" then
      print(colors("%{magenta bright}Main program entry file: " .. filosi))
      for _index_0 = 1, #requirez do
        local filll = requirez[_index_0]
        print(colors("%{yellow}Compiling with: " .. filll .. " as a module"))
      end
      os.execute("CC=" .. compilr .. " luastatic " .. filosi .. " " .. includes .. secspace .. "/usr/local/lib/moonxxx/mnxx/ll_53_standard/src/liblua.a " .. "-I/usr/local/lib/moonxxx/mnxx/ll_53_standard/src")
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
  if agone == "help" then
    print(colors("%{yellow bright}Usage{reset} -> %{blue bright}(1-Option)%{reset}%{red bright}[/mainfile/clean/nil/help]%{reset} %{green bright}(2-Mode)%{reset}%{red bright}[compile/nil]%{reset} %{magenta bright}(3-Target)%{reset}%{red bright}[all/none]%{reset} %{cyan bright}(4-Directory)%{reset}%{red bright}[current/DirectoryName]%{reset} %{cyanbg}(5-CompilerArgs)%{reset}%{red bright}[Arguemnts/nil]%{reset} %{yellowbg}(6-Compiler)%{reset}%{red bright}[clang/gcc/nil]%{reset}\n\n\n%{cyan}Note:%{reset} If nil(aka blank), leave blank and Moonscript++ will make value default, which will be listed below.\n\n%{blue bright}1-Option%{reset}%{red bright}[MainFile]%{reset} -> %{red}Specify main file name%{reset}, to create a executable. %{red bright}All .lua files in directory will be linked as modules, but are still needed.%{reset}\n--\n%{blue bright}1-Option%{red bright}[Cleaner]%{reset} -> %{red bright}clean%{reset} [%{red}remove%{reset}%{yellow}[Directory/nil]%{reset}/ %{red}move%{reset}%{yellow}[Directory/Nil]]%{reset} |\nIf clean remove [Directory/nil] - Will remove all .lua.c files. If clean remove %Directory% Will target directory. Blank for current.\nex. %{red bright}[moonxx clean remove]%{reset} | %{yellow bright}[moonxx clean remove ~/tests]%{reset}\n\nIf clean move [Directory/nil] - Will keep .lua files in dir, as well as make and copy .lua and .lua.c to a src directory\nIf clean move nil, will work on current directory.\nex. %{red bright}[moonxx clean move]%{reset} | %{yellow bright}[moonxx clean move ~/tests]%{reset}\n--\n\n%{blue bright}1-Option%{reset}%{red bright}[nil/blank] - DEFAULT%{reset} -> Will compile all .moon and .lua files in directory. In addition, it will link each compiled executable\nwith all other .lua and .moon files in directory other than itself. All files will be compiled linked to eachother.\nex. %{red bright}[moonxx]%{reset}\n\n"))
  elseif agone == "clean" then
    if agtwo ~= nil then
      if agtwo == "remove" then
        if agthree ~= nil then
          Cleaner:DirectoryOutputs(agthree, true, nil)
        elseif agthree == nil then
          Cleaner:DirectoryOutputs(".", true, nil)
        end
      elseif agtwo == "move" then
        if agthree ~= nil then
          Cleaner:DirectoryOutputs(agthree, false, nil)
        elseif agthree == nil then
          Cleaner:DirectoryOutputs(".", false, nil)
        end
      elseif agtwo == nil then
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
  elseif agone ~= "help" then
    local MainFil = agone
  end
  if agtwo ~= nil then
    local Mode = agtwo
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
  elseif agtwo == nil then
    if MainFil ~= nil then
      return Mods:CompileLua("gcc", MainFil, nil, "")
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
