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
        noMods = true
        secspace = " "
        includes = ""
        if compilr == ""
            compilr = "gcc"
        if requirez != nil
            noMods = false
            for incl in *requirez
                includes = includes .. incl .. " "
        if requirez == nil
            noMods = true
            includes = ""
            secspace = ""
        if noMods == false
            print(colors("%{green bright}Linked Modules: " .. includes))
        if compargs != ""
            if noMods == false
                for filll in *requirez 
                    print(colors("%{yellow}Compiling with: " .. filll .. " as a module"))
            elseif noMods == true
                print(colors("%{yellow bright}Compiling with no modules%{reset} " .. filosi))
                os.execute("CC=" .. compilr .. " luastatic " .. filosi .. " /usr/local/lib/moonxxx/mnxx/ll_53_standard/src/liblua.a -I/usr/local/lib/moonxxx/mnxx/ll_53_standard/src " .. compargs)
            if noMods == false
                os.execute("CC=" .. compilr .. " luastatic " .. filosi .. " " .. includes .. secspace .. "/usr/local/lib/moonxxx/mnxx/ll_53_standard/src/liblua.a " .. "-I/usr/local/lib/moonxxx/mnxx/ll_53_standard/src " .. compargs)
            JustCompd = filosi
        elseif compargs == ""
            print(colors("%{magenta bright}Main program entry file: " .. filosi))
            if noMods == false
                for filll in *requirez 
                    print(colors("%{yellow}Compiling with: " .. filll .. " as a module"))
            elseif noMods == true
                print(colors("%{yellow bright}Compiling with no modules%{reset} " .. filosi))
                os.execute("CC=" .. compilr .. " luastatic " .. filosi .. " /usr/local/lib/moonxxx/mnxx/ll_53_standard/src/liblua.a -I/usr/local/lib/moonxxx/mnxx/ll_53_standard/src")
            if noMods == false
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
    cleanMode = false 
    if agone == "help"
        print(colors("%{red bright}moonxx%{reset} %{blue bright}leave-blank%{reset} | %{yellow bright}clean%{reset} | %{cyan bright}compile%{reset}


%{cyan}Note:%{reset} if you run moonxx and leave arguments blank and Moonscript++ will make value default, which will be listed below.

--
%{blue bright}If left blank (ex.%{reset} %{red bright}moonxx%{reset}%{blue bright} ) Moonscript++ will compile all%{reset} %{yellow bright}.moon%{reset} %{blue bright}and%{reset} %{yellow bright}.lua%{reset} %{blue bright}files found in directory, and each%{reset} %{yellow bright}.lua / .moon%{reset} %{blue bright}file will be
dynamically included in the currently being compiled moonscript(or lua) file.
__________________________________________________________________________

%{yellow bright}clean | Options: %{reset}%{green bright}remove%{reset}%{yellow bright} / %{reset}%{magenta bright} move%{reset}
%{green bright} remove : will delete all noise (.lua.c) files. These can be regenerated, so dont worry.%{reset}
%{magenta bright} move : creates a src directory and copies .lua.c and .lua files into the directory%{reset}
%{yellow bright}ex.%{reset} %{red bright} moonxx clean remove%{reset}
__________________________________________________________________________

%{cyan bright} compile | Options: %{reset}%{red bright}File name%{reset}    | %{cyan bright}This will compile a single file with no modules%{reset}
%{cyan bright}ex.%{reset} %{red bright} moonxx compile myFile.moon%{reset}
"))
    elseif agone == "clean"
        if agtwo != nil
            if agtwo == "remove"
                if agthree != nil
                    cleanMode = true
                    Cleaner\DirectoryOutputs(agthree,true,nil)
                elseif agthree == nil
                    cleanMode = true
                    Cleaner\DirectoryOutputs(".",true,nil)
            elseif agtwo == "move"
                if agthree != nil
                    cleanMode = true
                    Cleaner\DirectoryOutputs(agthree,false,nil)
                elseif agthree == nil
                    cleanMode = true
                    Cleaner\DirectoryOutputs(".",false,nil)
            elseif agtwo == nil
                cleanMode = true
                Cleaner\DirectoryOutputs(".",false,nil)
    elseif agone == nil
        sendTab = {}
        buildAllEm = Search\ForExt ".", ".moon"
        for filz in *buildAllEm
            os.execute("moonc " .. filz)
        doAllEm = Search\ForExt ".",".lua"
        for lfil in *doAllEm
            DoCompile\CompileWholeDir(".",lfil,"gcc","")
    elseif agone == "compile"
        Mode = "compile"
    if agtwo != nil
        if cleanMode == false
            MainFil = agtwo
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
        if cleanMode == false
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