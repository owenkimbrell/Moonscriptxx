_**Moonscript++**_ >||< **Lynxish Assembler**
--------------------
  **Version 1.0.4**
  **Compiles Moonscript into binary executables, to distrobute to large groups of machines. Increases security, performance, and compatibility.**
**___________________**

##Major update comming May 10.##

1. Has new compiler made by **me**, _compiles, and embeddes bytecode EVERY time_.
-1. Still has option for compiliation through **Luastatic** _by ers35_
2. New lighterweight and easier to edit make system. With custom .mnmake script system based on 'Makefile' syntax.
**____________________**

### Wiki : https://github.com/owenkimbrell/Moonscriptxx/wiki ###

**___________________________________________**

_Changes_
* Removed all .netcore dependencies.
* Updated system, relies on itself.
* Easier to use
-----------------------------
_Whats New_
* Single binary, currently compiled for x64_86 PC's
* Simple to compile yourself, in a single step. Explained in section _Compiling_
* More stable, and functional. **Now when autodetecting moonscript in directory, it will automatically include all .lua files not specified as the main file. Also, if no main file is specified, all files will be compiled, excluding themselves as modules _but_ including all other .lua files in directory as modules**
* Has a cleaner function, _for usage see **How to use**_. This basically cleans up and formats your directory for development/release

______________________________________________-


_Installing_ | **Installer comming within next couple days**

`mkdir ~/moonplusplus`

`cd ~/moonplusplus`

`git clone https://github.com/owenkimbrell/Moonscriptxx`

`cd Moonscriptxx`

`cd mnxx`

`cd ll_53_standard`

`cd src`

`make && cd ~/moonplusplus/Moonscriptxx`

`mkdir /usr/local/lib/moonxxx && cp mnxx /usr/local/lib/moonxxx`

`cd moonscriptxx/Release`

NOW, if you have a intel/amd supporting amd64 architecture(_most people_) you can simply

`cp moonxx /usr/local/bin && cp ansicolors.lua /usr/local/bin && chmod +x /usr/local/bin/moonxx`

_Compiling_

IF YOU WANT TO COMPILE IT YOURSELF, first do all the above steps execept the copying into your /usr/local/bin

`moon moonxx.moon`

_This will run the same program in moonscript instead of a binary, which will compile itself, and link it to ansicolors.lua_
**It also will replace the default moonxx binary, then follow the same steps for copying and allowing execution privilage**

`cp moonxx /usr/local/bin && cp ansicolors.lua /usr/local/bin && chmod +x /usr/local/bin/moonxx`


**How to use**

* `moonxx`    | Running this in a terminal will compile all .moon files in directory, on each compiliation it will link it with all .lua or .moon files found in directory EXECPT itself.

* `moonxx clean remove`    | Will delete noise files generated on compiliation

* `moonxx clean move`      | Will make a src directory and copy the output .lua and .lua.c files into the src directory


**Notes**
1. If using modules, its ok to delete the .lua.c. As well as the .lua of the **main** targeted executable. However, the .lua file of the referenced module needs to remain in the structure its required in the .moon file.
2. Structure as of now, is the same as .moon. ALL FUNCTIONS WORK. In fact, no errors come of coding unless you coded it wrong. No special format is required. Simply run moonxx in the directory

Big thanks to luastatic(ers35) and Moonscript(Leafo)
Happy coding. Many more features on the way within days. Spread the word, _**maybe click on the star and watch buttons in the top right corner.**_ _Thanks_
