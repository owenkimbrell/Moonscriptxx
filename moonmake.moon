--BUG: Module isnt found with luac compiliation of lua bytecode when using require lbc. FIX: DO NOT USE REQUIRE, OR FIND STOPPER FOR IT.
require "lbc"
require "moonxx"
to_hex = (str) ->
    return str\tohex!
from_hex = (hex) ->
    return hex\fromhex!
--BUG: find_extension and find_name return directories. FIX: Temporary, an if statement checks that filename and extension are not equal. If same, removes entry
find_extension = (str) ->
    return str\match("[^.]+$")
find_name_and_ext = (str) ->
    return str\match("([^/]-([^.]+))$")
find_name = (str) ->
    return str\match("[^/]+$")
find_name_no_ext = (str) ->
    ext = find_extension(str)
    return string.sub(str,0,#str - (#ext + 1))
print_all_of = (whattable,is_pairs=false) ->
    if is_pairs == true
        for ke,va in pairs(whattable)
            print(ke,va)
    else
        for t in *whattable
            for ke,va in pairs(t)
                print(ke,va)
class Profile
--TODO: Add verbose support.
    @options = {
        ["target"]: "none",
        ["directory"]: './',
        ["compiler"]: "clang",
        ["module"]: "none",
        ["strip"]: "true"
    }
    @profiles = {}
    @new: =>
        for fil in io.popen("/bin/ls " .. @options["directory"])\lines!
            if find_name(fil) != find_extension(fil)
                table.insert(@profiles,{
                    [find_name(fil)]: find_extension(fil)
                })
class Interact extends Profile
    @todo = {}
    @whattodo: =>
        for profile in *super.profiles
            for key,value in pairs(profile)
                switch value
                    when "moon"
                        if super.options["target"] == "none"
                            mooncStr = "moonc -o " .. find_name_no_ext(key) .. ".lua " .. key
                            table.insert(@todo,{
                                [tostring(key)]: mooncStr
                            })
                        else
                            if key == super.options["target"]
                                mooncStr = "moonc -o " .. find_name_no_ext(key) .. ".lua " .. key
                                table.insert(@todo,{
                                    [tostring(key)]: mooncStr
                                })
                                return 0
                    when "lua"
                        if super.options["target"] == "none"
                            luacString = "none"
                            if super.options["module"] == "none"
                                luacString = "luac -o " .. find_name_no_ext(key) .. ".mpp " .. key
                                luacString = "luac -s -o " .. find_name_no_ext(key) .. ".mpp " .. key if super.options["strip"] == "true"
                            else
                                luacString = "luac -o " .. find_name_no_ext(key) .. ".mpp " .. key .. " " .. super.options["module"]
                                luacString = "luac -s -o " .. find_name_no_ext(key) .. ".mpp " .. key .. " " .. super.options["module"] if super.options["strip"] == "true"
                            table.insert(@todo,{
                                [tostring(key)]: luacString
                            })
                        else
                            if super.options["target"] == key
                                luacString = "none"
                                if super.options["module"] == "none"
                                    luacString = "luac -o " .. find_name_no_ext(key) .. ".mpp " .. key
                                    luacString = "luac -s -o " .. find_name_no_ext(key) .. ".mpp " .. key if super.options["strip"] == "true"
                                else
                                    luacString = "luac -o " .. find_name_no_ext(key) .. ".mpp " .. key .. " " .. super.options["module"]
                                    luacString = "luac -s -o " .. find_name_no_ext(key) .. ".mpp " .. key .. " " .. super.options["module"] if super.options["strip"] == "true"
                                table.insert(@todo,{
                                    [tostring(key)]: luacString
                                })
                                return 0
    @new: =>
        cntr = 0
        for ag in *arg
            cntr = cntr + 1
            if ag == "help"
                for ke,va in pairs(super.options)
                    print("Option:",ke,"|| Default:",va)
                return 0
            if ag == "module"
                if super.options["module"] == "none"
                    if arg[cntr + 1] != nil
                        super.options["module"] = arg[cntr + 1]
                else
                    if arg[cntr + 1] != nil
                        crrnt = super.options["module"]
                        super.options["module"] = crrnt .. " " .. arg[cntr + 1]
            for ke,va in pairs(super.options)
                if ke == ag
                    if arg[cntr + 1] != nil
                        super.options[ke] = arg[cntr + 1] if ke != "module"
        super\new!
        @whattodo!
class Builder
    @context = {}
    initiate: ->
        Interact\new!
    sendtobyte:(where) ->
        fil = io.open(where,"rb")
        binhex = nil
        if fil
            binhex = fil\read("*all")\tohex!
            fil\close!
        filtwo = io.open(where,"w")
        filtwo\write(binhex) if binhex != nil
        filtwo\close!
    getassets: ->
        for p in *Builder.context
            for ke,va in pairs(p)
                switch va
                    when "moon"
                        if Profile.options["target"] == "none"
                            if Profile.options["module"] == "none"
                                if Profile.options["strip"] == "true"
                                    os.execute("luac -s -o " .. find_name_no_ext(ke) .. ".mpp " .. find_name_no_ext(ke) .. ".lua")
                                else
                                    os.execute("luac -o " .. find_name_no_ext(ke) .. ".mpp " .. find_name_no_ext(ke) .. ".lua")
                            else
                                if Profile.options["strip"] == "true"
                                    os.execute("luac -s -o " .. find_name_no_ext(ke) .. ".mpp " .. find_name_no_ext(ke) .. ".lua " .. Profile.options["module"])
                                else
                                    os.execute("luac -o " .. find_name_no_ext(ke) .. ".mpp " .. find_name_no_ext(ke) .. ".lua " .. Profile.options["module"])
                        else
                            if ke == Profile.options["target"]
                                if Profile.options["module"] == "none"
                                    if Profile.options["strip"] == "true"
                                        os.execute("luac -s -o " .. find_name_no_ext(ke) .. ".mpp " .. find_name_no_ext(ke) .. ".lua")
                                        break
                                    else
                                        os.execute("luac -o " .. find_name_no_ext(ke) .. ".mpp " .. find_name_no_ext(ke) .. ".lua")
                                        break
                                else
                                    if Profile.options["strip"] == "true"
                                        os.execute("luac -s -o " .. find_name_no_ext(ke) .. ".mpp " .. find_name_no_ext(ke) .. ".lua " .. Profile.options["module"])
                                        break
                                    else
                                        os.execute("luac -o " .. find_name_no_ext(ke) .. ".mpp " .. find_name_no_ext(ke) .. ".lua " .. Profile.options["module"])
                                        break
    make: =>
        @initiate!
        for tab in *Interact.todo
            for ke,va in pairs(tab)
                if Profile.options["target"] == "none"
                    os.execute(va)
                    table.insert(@context,{
                        [tostring(ke)]: tostring(find_extension(ke))
                    })
                elseif Profile.options["target"] == ke
                    os.execute(va)
                    table.insert(@context,{
                        [tostring(ke)]: tostring(find_extension(ke))
                    })
                    break
        @getassets!
Builder\make!
Builder.sendtobyte("./moonxx.mpp")