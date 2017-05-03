require "lbc"
find_extension = (str) ->
    return str\match("[^.]+$")
find_name_no_ext = (str) ->
    ext = find_extension(str)
    return string.sub(str,0,#str - (#ext + 1))
strhextobin = (hex) ->
    return "
    require \\'lbc\\'"
class MoonMake_Resolve
    Options: {["linker"]: {"-I/usr/local/include","-L/usr/local/lib -llua -lm -ldl"},
    ["compiler"]: "clang",
    ["arguments"]: (filename,outname) -> return " -o " .. find_name_no_ext(filename) .. " -Os " .. filename,
    ["include"]:{"lua.h","lauxlib.h","lualib.h","stdio.h",
    "stdlib.h"},
    ["embedded"]: "true"}
    Get_link: ->
        retStr = nil
        for istr in *MoonMake_Resolve.Options["linker"]
            if retStr
                retStr = retStr .. " " .. istr
            else
                retStr = istr
        return retStr
    Options_add: (what,value) ->
        cntr = 0
        for o in *MoonMake_Resolve.Options[tostring(what)]
            cntr = cntr + 1
        MoonMake_Resolve.Options[tostring(what)][cntr + 1] = tostring(value)
    Headers_Std: ->
        hdrz = nil
        for istr in *MoonMake_Resolve.Options["include"]
            if hdrz
                hdrz = hdrz .. "
#include <" .. istr .. ">"
            else
                hdrz = "#include <" .. istr .. ">"
        return hdrz .. "
int main(void) {",
    Lua_Init: -> 
        return "
lua_State *Lmpptr;
int lpntrex,reslov;
Lmpptr = luaL_newstate();"
    Lua_Load: (hexarr,file=nil) ->
        if file
            return ("
luaL_openlibs(Lmpptr);
lpntrex = luaL_loadfile(Lmpptr,\"" .. file .. "\");
if(lpntrex) {
fprintf(stderr,\"Err:| %s\\n\",lua_tostring(Lmpptr,-1));
}
reslov = lua_pcall(Lmpptr,0,LUA_MULTRET,0);
}")
        else
            return ("
luaL_openlibs(Lmpptr);
const char *hxarrtb = \"" .. strhextobin(hexarr) .. "\"";
lpntrex = luaL_dostring(Lmpptr,hxarrtb);
if(lpntrex) {
fprintf(stderr,\"Err:| %s\\n\",lua_tostring(Lmpptr,-1));
}
reslov = lua_pcall(Lmpptr,0,LUA_MULTRET,0);
}")
input = {
    ["embedded"]: "true",
    ["compiler"]: "clang",
    ["target"]: "none"
}
bin_to_hex = (traits) ->
    f = io.open(traits["filename"],"rb")
    if f
        str = f\read("*all")\tohex!
        f\close!
        return str
    else
        print("error on file open")
        return 0
on_Entry = {
    get_args: ->
        cntr = 0
        for ag in *arg
            cntr = cntr + 1
            for ke,va in pairs(input)
                if ag == ke
                    input[ke] = arg[cntr + 1] if arg[cntr + 1] != nil
    fileInfo: ->
        traits = {}
        if input["target"] == "none"
            return 0
        else
            tf = io.open(input["target"],"r")
            if tf
                traits["filename"] = input["target"]
                traits["realname"] = find_name_no_ext(input["target"])
                traits["context"] = find_extension(input["target"])
        if traits["filename"] == nil
            print("no target found")
            return 0
        else
            traits["hex"] = bin_to_hex(traits)
            return traits
}
Make_C_File = (embedded=true,filename,exrarg) ->
    filename = find_name_no_ext(filename) .. ".c"
    retStr = (MoonMake_Resolve\Headers_Std! .. MoonMake_Resolve\Lua_Init!)
    if embedded
        retStr = retStr .. MoonMake_Resolve.Lua_Load(exrarg,nil) if exrarg != nil
    elseif embedded == false
        retStr = retStr .. MoonMake_Resolve.Lua_Load(nil,find_name_no_ext(filename) .. ".mpp") if filename != nil
    elseif embedded == nil
        return 0
    if retStr
        fil = io.open(filename,"w+") if filename != nil
        if fil
            fil\write(retStr)
            fil\close!
            return retStr
        else
            return 0
check_sesensible = ->
    if input["embedded"] == "true"
        getTraits = on_Entry.fileInfo!
        if getTraits != 0
            Make_C_File(true,getTraits["filename"],getTraits["hex"])
    elseif input["embedded"] == "false"
        getTraits = on_Entry.fileInfo!
        if getTraits != 0
            Make_C_File(false,getTraits["filename"],nil) if getTraits != 0

on_Entry.get_args!
check_sesensible!