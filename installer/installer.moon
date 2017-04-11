print "This installer was written in moonscript and compiled with moonscript++ | Lynxish Assembler"
targetFiles = {}
--TODO: MAKE THIS STATIC
local *
libinstalldir = "/usr/local/lib/moonxxx"
os.execute("sudo mkdir " .. libinstalldir)
os.execute("sudo mkdir " .. libinstalldir .. "/mnxx")
cmdnB = {
    config: (dirr) =>
        os.execute("cd " .. dirr .. " && sudo ./configure")
    askSudo: (str) =>
        os.execute("sudo " .. str)
    unZipInstall: (what,where) =>
        print "Extracting " .. what .. "..."
        @askSudo("tar xf " .. what .. " -C " .. where)
    makeB: (dirr,argss="") =>
        print "Making " .. dirr
        os.execute("cd " .. dirr .. " && sudo make" .. argss)
    copyMach: (what,where) =>
        @askSudo("cp " .. what .. " " .. where)
	    print "Copied " .. what
    movER: (what,where) =>
        @askSudo("mv " .. what .. " " .. where)
    retCmd: (cmdd,argss) =>
        retter = io.popen(cmdd .. " " .. argss)
        return retter
    buildSpec: (nameo) =>
        @askSudo("luarocks install " .. nameo)
}

mods = {
    getFilesInDir: (dirr) =>
        count = 1
        filos = cmdnB\retCmd "/bin/ls",dirr
        for namo in filos\lines!
            targetFiles[count] = namo
            count = count + 1
}
installerr = {
    extract: =>
        mods\getFilesInDir "."
        for tfil in *targetFiles
            if tfil == "mnxx"
                os.execute("sudo cp -r mnxx /usr/local/lib/moonxxx") 
            elseif tfil == "moonxx"
                cmdnB\copyMach tfil, "/usr/local/bin"
            elseif tfil == "moonstatic"
                cmdnB\copyMach tfil, "/usr/local/bin"
	        elseif tfil == "Release"
		        os.execute "sudo cp -r Release/* /usr/local/lib/moonxxx" 
            elseif tfil == "moonXx"
                os.execute "sudo cp moonXx/moonxx /usr/local/bin"
    makersMark: =>
        mods\getFilesInDir libinstalldir .. "/mnxx"
        for tdirs in *targetFiles
            if tdirs == "luarocks"
                cmdnB\config libinstalldir .. "/mnxx/" .. tdirs
                cmdnB\makeB libinstalldir .. "/mnxx/" .. tdirs, " build"
                cmdnB\makeB libinstalldir .. "/mnxx/" .. tdirs, " install"
                mods\getFilesInDir libinstalldir .. "/mnxx"
                for tddirs in *targetFiles
                    if tddirs == "moonscript"
                        os.execute("sudo luarocks install moonscript")
                    if tddirs == "luastatic"
                        os.execute("sudo luarocks install luastatic")
            elseif tdirs == "ll_53_standard"
                os.execute("mkdir ~/ll_53")
                cmdnB\makeB libinstalldir .. "/mnxx/" .. tdirs," linux"
                cmdnB\copyMach libinstalldir .. "/mnxx/" .. tdirs .. "/src/lua", "~/ll_53"
                cmdnB\copyMach libinstalldir .. "/mnxx/" .. tdirs .. "/src/liblua.a", "~/ll_53"
            elseif tdirs == "ll_53_jit"
                os.execute("mkdir ~/ll_53")
                os.execute("mkdir ~/ll_53/jit")
                cmdnB\makeB libinstalldir .. "/mnxx/" .. tdirs,""
}
installerr\extract!
installerr\makersMark!