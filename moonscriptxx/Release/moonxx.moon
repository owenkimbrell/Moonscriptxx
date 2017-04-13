local ^
JustCompd = ""
TargetFiles = {}
KeepModules = {}
colors = require "ansicolors"
CmdnB = {
    Config: (dirr) =>
        os.execute("cd " .. dirr .. " && sudo ./configure")
    AskSudo: (str) =>
        os.execute("sudo " .. str)
    UnZipInstall: (what,where) =>
        print "Extracting " .. what .. "..."
        @AskSudo("tar xf " .. what .. " -C " .. where)
    MakeB: (dirr,argss="") =>
        print "Making " .. dirr
        os.execute("cd " .. dirr .. " && sudo make" .. argss)
    CopyMach: (what,where) =>
        @AskSudo("cp " .. what .. " " .. where)
	    print "Copied " .. what
    MovER: (what,where) =>
        @AskSudo("mv " .. what .. " " .. where)
    RetCmd: (cmdd,argss) =>
        retter = io.popen(cmdd .. " " .. argss)
        return retter
    BuildSpec: (nameo) =>
        @AskSudo("luarocks install " .. nameo)
}
Mods = {
    GetFilesInDir: (dirr) =>
        count = 1
        filos = CmdnB\RetCmd "/bin/ls",dirr
        for namo in filos\lines!
            TargetFiles[count] = namo
            count = count + 1
    -- Args : compilr: Which compiler to use | filosi: file | requirez: what modueles to require | compargs: Args to send to compiler
    CompileLua: (compilr="CC=gcc",filosi,requirez,compargs) =>
        secspace = " "
        includes = ""
        if compilr == ""
            compilr = "gcc"
        if requirez != nil
            for incl in *requirez
                includes = includes .. incl .. " "
        elseif requirez == nil
            includes = ""
            secspace = ""
        print(colors("%{green bright}Linked Modules: " .. includes))
        if compargs != ""
            for filll in *requirez 
                print(colors("%{yellow}Compiling with: " .. filll .. " as a module"))
            os.execute("CC=" .. compilr .. " luastatic " .. filosi .. " " .. includes .. secspace .. "/usr/local/lib/moonxxx/mnxx/ll_53_standard/src/liblua.a " .. "-I/usr/local/lib/moonxxx/mnxx/ll_53_standard/src " .. compargs)
            JustCompd = filosi
        elseif compargs == ""
            print(colors("%{magenta bright}Main program entry file: " .. filosi))
            for filll in *requirez 
                print(colors("%{yellow}Compiling with: " .. filll .. " as a module"))
            os.execute("CC=" .. compilr .. " luastatic " .. filosi .. " " .. includes .. secspace .. "/usr/local/lib/moonxxx/mnxx/ll_53_standard/src/liblua.a " .. "-I/usr/local/lib/moonxxx/mnxx/ll_53_standard/src")
            JustCompd = filosi
    BuildAllMoon: (filosi) =>
        for filoz in *filosi
            os.execute("moonc " .. filoz)
            os.execute "echo Built with moon-compiler version: && moonc -v"
    BuildMoon: (filo) =>
        os.execute("moonc " .. filo)
        os.execute "echo Built with moon-compiler version: && moonc -v"
}
Search = {
    ForExt: (dir,ext) =>
        retTable = {}
        count = 1
        Mods\GetFilesInDir(dir)
        for fil in *TargetFiles
            indx,eindx = string.find(fil,ext)
            lngth = #fil
            if indx != nil
                theExt = string.sub(fil,indx,eindx)
                if ext == theExt
                    if lngth == eindx
                        retTable[count] = fil
                        count = count + 1
                        if fil != "./src"
                            print(colors("%{cyan bright}Found " .. fil))
        return retTable
}
DoCompile = {
    MoonWholeDir: (dirr) =>
        tFiles = Search\ForExt dirr,".moon"
        Mods\BuildAllMoon tFiles
    CompileWholeDir: (dirr,mainf,compiler,cargs) =>
        sendTable = {}
        count = 1
        tFiles = Search\ForExt dirr,".lua"
        for fil in *tFiles
            if fil != mainf
                sendTable[count] = fil
                count = count + 1
        KeepModules = sendTable
        Mods\CompileLua(compiler,mainf,sendTable,cargs)
    MoonFile: (filee) =>
        Mods\BuildMoon filee
}
CompGcc = {
    CompileCrntDir: (main,cargss) =>
        MoonFunction\BuildCrntDir!
        DoCompile\CompileWholeDir(".",main,"gcc",cargss)
    CompileDir: (dir,main,cargs) =>
        MoonFunction\BuildWholeMoonDir dir
        DoCompile\CompileWholeDir(dir,main,"gcc",cargs)
}
CompClang = {
    CompileCrntDir: (main,cargss) =>
        MoonFunction\BuildCrntDir!
        DoCompile\CompileWholeDir(".",main,"clang",cargss)
    CompileDir: (dir,main,cargs) =>
        MoonFunction\BuildWholeMoonDir dir
        DoCompile\CompileWholeDir(dir,main,"clang",cargs)
}
MoonFunction = {
    BuildCrntDir: =>
        DoCompile\MoonWholeDir "."
    BuildSingleMoon: (filee) =>
        DoCompile\MoonFile filee
    BuildWholeMoonDir: (dirr) =>
        DoCompile\MoonWholeDir dirr
}
-- ModulesN: ONLY RUN THIS AFTER BUILDING. MODULESN IS THE MODULES DETECTED BY COMPILER TO NOT MOVE OR DELETE.
Cleaner = {
    DirectoryOutputs: (dir,delete=false,modulesn=KeepModules) =>
        if modulesn == nil
            modulesn = Search\ForExt(dir,".lua")
        countLock = 0
        if delete == true
            tFiles = Search\ForExt dir, ".lua.c"
            for fil in *tFiles
                os.execute("rm " .. fil)
                print(colors("%{red}Removed output file: " .. fil))
        elseif delete == false
            hasSrcDir = false
            Mods\GetFilesInDir dir
            for fils in *TargetFiles
                if fils == "src"
                    hasSrcDir = true
                elseif fils != "src"
                    doubleCheck = Search\ForExt dir, "src"
                    for isit in *doubleCheck
                        if isit != nil
                            hasSrcDir = true
            if hasSrcDir == true
                tFiles = Search\ForExt dir, ".lua.c"
                for fil in *tFiles
                    os.execute("mv " .. fil .. " " .. dir .. "/src")
                    print(colors("%{blue underline}Moved: " .. fil .. " to " .. dir .. "/src"))
                tFiles = Search\ForExt dir, ".lua"
                for fil in *tFiles
                    for mod in *modulesn
                        if mod != fil
                            os.execute("mv " .. fil .. " " .. dir .. "/src")
                            os.execute("cp " .. dir .. "/src/* .")
                            print(colors("%{blue underline}Moved: " .. fil .. " to " .. dir .. "/src"))
                            print(colors("%{red bright}keep compiled executable in same folder as required modules."))
                        elseif mod == fil
                            print(colors("%{green underline}Not moving needed module: " .. mod))
            if hasSrcDir == false
                if countLock = 0
                    os.execute "mkdir " .. dir .. "/src"
                    countLock = countLock + 1
                @DirectoryOutputs(dir,false)
}
--MoonFunction | BuildSingleMoon (filename) / BuildCrntDir! / BuildWholeMoonDir (dir)
--CompClang | CompileCrntDir (main,compiler-args) / CompileDir (dir,main,compiler-args)
--CompGcc | CompileCrntDir (main,compiler-args) / CompileDir (dir,main,compiler-args)
--Cleaner | DirectoryOutputs (dir, delete[bool],modules-toSave)
--Search | ForExt (dir,extension)
--Mods | GetFilesInDir (dir #returns files as table) / CompileLua(compiler, main-file, modules[table],compiler-arguments)
agone = arg[1]
agtwo = arg[2]
agthree = arg[3]
agfour = arg[4]
agfive = arg[5]
agsix = arg[6]
CheckArgs = ->
    if agone == "help"
        print(colors("%{yellow bright}Usage{reset} -> %{blue bright}(1-Option)%{reset}%{red bright}[/mainfile/clean/nil/help]%{reset} %{green bright}(2-Mode)%{reset}%{red bright}[compile/nil]%{reset} %{magenta bright}(3-Target)%{reset}%{red bright}[all/none]%{reset} %{cyan bright}(4-Directory)%{reset}%{red bright}[current/DirectoryName]%{reset} %{cyanbg}(5-CompilerArgs)%{reset}%{red bright}[Arguemnts/nil]%{reset} %{yellowbg}(6-Compiler)%{reset}%{red bright}[clang/gcc/nil]%{reset}


%{cyan}Note:%{reset} If nil(aka blank), leave blank and Moonscript++ will make value default, which will be listed below.

%{blue bright}1-Option%{reset}%{red bright}[MainFile]%{reset} -> %{red}Specify main file name%{reset}, to create a executable. %{red bright}All .lua files in directory will be linked as modules, but are still needed.%{reset}
--
%{blue bright}1-Option%{red bright}[Cleaner]%{reset} -> %{red bright}clean%{reset} [%{red}remove%{reset}%{yellow}[Directory/nil]%{reset}/ %{red}move%{reset}%{yellow}[Directory/Nil]]%{reset} |
If clean remove [Directory/nil] - Will remove all .lua.c files. If clean remove %Directory% Will target directory. Blank for current.
ex. %{red bright}[moonxx clean remove]%{reset} | %{yellow bright}[moonxx clean remove ~/tests]%{reset}

If clean move [Directory/nil] - Will keep .lua files in dir, as well as make and copy .lua and .lua.c to a src directory
If clean move nil, will work on current directory.
ex. %{red bright}[moonxx clean move]%{reset} | %{yellow bright}[moonxx clean move ~/tests]%{reset}
--

%{blue bright}1-Option%{reset}%{red bright}[nil/blank] - DEFAULT%{reset} -> Will compile all .moon and .lua files in directory. In addition, it will link each compiled executable
with all other .lua and .moon files in directory other than itself. All files will be compiled linked to eachother.
ex. %{red bright}[moonxx]%{reset}

"))
    elseif agone == "clean"
        if agtwo != nil
            if agtwo == "remove"
                if agthree != nil
                    Cleaner\DirectoryOutputs(agthree,true,nil)
                elseif agthree == nil
                    Cleaner\DirectoryOutputs(".",true,nil)
            elseif agtwo == "move"
                if agthree != nil
                    Cleaner\DirectoryOutputs(agthree,false,nil)
                elseif agthree == nil
                    Cleaner\DirectoryOutputs(".",false,nil)
            elseif agtwo == nil
                Cleaner\DirectoryOutputs(".",false,nil)
    elseif agone == nil
        sendTab = {}
        buildAllEm = Search\ForExt ".", ".moon"
        for filz in *buildAllEm
            os.execute("moonc " .. filz)
        doAllEm = Search\ForExt ".",".lua"
        for lfil in *doAllEm
            DoCompile\CompileWholeDir(".",lfil,"gcc","")
    elseif agone != "help"
        MainFil = agone
    if agtwo != nil
        Mode = agtwo
        if agthree != nil
            Target = agthree
            if agfour == "current"
                Dir = "current"
                if agfive == "none"
                    Cargss = "none"
                elseif agfive != "none"
                    Cargss = agfive
            elseif agfour != "current"
                Dir = agfour
                if agfive == "none"
                    Cargss = "none"
                    if agsix != nil
                        Compilly = agsix
                        ParseArgs\CheckTarget!
                    elseif agsix == nil
                        Compilly = "gcc"
                        ParseArgs\CheckTarget!
                elseif agfive != "none"
                    Cargss = agfive
                    if agsix != nil
                        Compilly = agsix
                        ParseArgs\CheckTarget!
                elseif agfive == nil
                    Cargss = ""
                    Compilly = "gcc"
                    ParseArgs\CheckTarget!
        elseif agthree == nil
            if MainFil != nil
                Mods\CompileLua("gcc",MainFil,nil,"")
    elseif agtwo == nil
        if MainFil != nil
            Mods\CompileLua("gcc",MainFil,nil,"")
ParseArgs = {
    CheckMode: =>
        if MainFil != nil
            return true
        elseif Mode != "compile"
            return true
    CheckTarget: =>
        if @CheckMode! == true
            if Target == "all"
                if Dir == "current"
                    if Compilly == "clang"
                        CompClang\CompileCrntDir(MainFil,Cargss)
                    elseif Compilly == "gcc"
                        CompGcc\CompileCrntDir(MainFil,Cargss)
                elseif Dir != "current"
                    if Compilly == "clang"
                        CompClang\CompileDir(Dir,MainFil,Cargss)
                    elseif Compilly == "gcc"
                        CompGcc\CompileDir(Dir,MainFil,Cargss)
            elseif Target != "all"
                if Dir == "current"
                    if Compilly == "clang"
                        Mods\CompileLua("CC=clang",MainFil,nil,Cargss)
                    elseif Compilly == "gcc"
                        Mods\CompileLua("CC=gcc",MainFil,nil,Cargss)
                elseif Dir != "current"
                    if Compilly == "clang"
                        Mods\CompileLua("CC=clang",MainFil,nil,Cargss)
                    elseif Compilly == "gcc"
                        Mods\CompileLua("CC=gcc",MainFil,nil,Cargss)
}
CheckArgs!
ParseArgs\CheckTarget!