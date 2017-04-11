execprog = {
    build: (args) =>
        os.execute "/usr/local/bin/dotnet /usr/local/lib/moonxxx/moonstatic.dll " .. args
    compile: =>
        os.execute "/usr/local/bin/dotnet /usr/local/lib/moonxxx/moonstatic.dll -c"
    help: =>
        os.execute "/usr/local/bin/dotnet /usr/local/lib/moonxxx/moonstatic.dll -h"
    newproj: (name) =>
        os.execute "/usr/local/bin/dotnet /usr/local/lib/moonxxx/moonstatic.dll -n " .. name
}
print "Lynxish Assembler | Moonscript++
-b | Builds all
-b=msbuild | Builds C# with msbuild
-c | Compiles all
-c=moon | Experimental C# extractor
-h | Displays help
-n | New C# Project
"
inpt = io.read!
if inpt == "-b"
    execprog\build inpt
elseif inpt == "-c"
    execprog\compile!
elseif inpt == "-h"
    execprog\help!
elseif inpt == "-n"
    print "Enter a name for the project"
    inpname = io.read!
    if inpname != ""
        execprog\newproj inpname
    elseif inpname == ""
        print "No name entered.."
elseif inpt == "-b=msbuild"
    execprog\build inpt
