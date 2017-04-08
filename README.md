Moonscript++ | BETA STAGE. A little language that compiles to C, Binarys and or C#.

Welcome, Moonscript is the dominant language for the future of programming in my opinion. Sadly my program is so far written in C#(.netcore) which easily supports 99% of linux. If your distro isnt supported, simply download and make the Linux.x64 build from the website. 

STATUS :
Working. But not up to my standard of quality. I see a beauty in the practicality  and efficiency of moonscript, its compiler is simple and friendly, giving developers new or old a productive lightweight language to execel.

DOES It WORK DUDE? Yes. But its not 100% simple yet. for instance

dotnet program.dll -b

(dotnet is for the C# dotnet framework host. Its basically like doing  [person@localhost]$lua myluafile.lua


will automatically build all moonscript files it finds in directory to .lua(AS WELL AS C# PROGJECTS. THIS FUNCTION ISNT COMPLETE.)

then

dotnet program.dll -c

will automatically compile all .lua files it finds in directory to C binary.

HOW TO USE
download and install dotnet, luastatic, moonscript 5.0 (on github) and YOU NEED THE lua 5.3.4 source from the website. You need to build this yourself and install is optional. THIS IS IMPORTANT. Like stated, this is in betaphase. In a couple days it will autodetect and or use standard lua installation. 

Steps after building lua.

Copy all output from bin to a new folder in home directory called ll_53
(this means all the lua source in bin, as well as compiled. liblua.a and lua binary and lua.h all of them in bin)

make sure your liblua.a is simply liblua.a not liblua5.3.x.a and same with lua. Like stated this is a five minute fix but this project is under heavy development and its simipler for me to do this for testing purposes. 

What doesnt work, the C# Extractor works(used to write arbitrary C# code inside a moonscript file) but is not complete. Use dotnet program.dll -h to see comands. I recommend against using this feature of -c=moon (C# Extractor) until its complete, so i will not explain how to use, if your intrested look at source but it should be done relativily soon. 

GOALS:
Use the moonscript compile feature to automate the call of dotnet and program.dll and simply install the bin into /usr/local/bin

Fix alot of shit.
 Thanks.
