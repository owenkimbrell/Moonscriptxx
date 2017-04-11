local execprog = {
  build = function(self, args)
    return os.execute("/usr/local/bin/dotnet /usr/local/lib/moonxxx/moonstatic.dll " .. args)
  end,
  compile = function(self)
    return os.execute("/usr/local/bin/dotnet /usr/local/lib/moonxxx/moonstatic.dll -c")
  end,
  help = function(self)
    return os.execute("/usr/local/bin/dotnet /usr/local/lib/moonxxx/moonstatic.dll -h")
  end,
  newproj = function(self, name)
    return os.execute("/usr/local/bin/dotnet /usr/local/lib/moonxxx/moonstatic.dll -n " .. name)
  end
}
print("Lynxish Assembler | Moonscript++\n-b | Builds all\n-b=msbuild | Builds C# with msbuild\n-c | Compiles all\n-c=moon | Experimental C# extractor\n-h | Displays help\n-n | New C# Project\n")
local inpt = io.read()
if inpt == "-b" then
  return execprog:build(inpt)
elseif inpt == "-c" then
  return execprog:compile()
elseif inpt == "-h" then
  return execprog:help()
elseif inpt == "-n" then
  print("Enter a name for the project")
  local inpname = io.read()
  if inpname ~= "" then
    return execprog:newproj(inpname)
  elseif inpname == "" then
    return print("No name entered..")
  end
elseif inpt == "-b=msbuild" then
  return execprog:build(inpt)
end
