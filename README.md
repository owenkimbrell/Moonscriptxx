Moonscript++ | BETA STAGE. A little language that compiles to C, Binarys and or C#.

Welcome, Moonscript is the dominant language for the future of programming in my opinion. Sadly my program is so far written in C#(.netcore) which easily supports 99% of linux. If your distro isnt supported, simply download and make the Linux.x64 build from the website. 

STATUS :
Installer and binaries for /usr/local/bin WRITTEN IN MOONSCRIPT AND COMPILED THEMSELVES INTO C BINARIES. BIG THANKS TO LUASTATIC AND MOONSCRIPT for making this possible.

DOES It WORK DUDE? Yes. But its not 100% simple yet. for instance

moonxx -c will compile all moonscript found in directory to a executable.


HOW TO INSTALL AND USE

git clone https://github.com/owenkimbrell/Moonscriptxx/edit/master/

install .net core. Soon this will be unessecary but for now just pre-install it.

install luarocks AND OR clone the repo into mnxx/ (name cloned repo 'luarocks')

install luastatic AND OR clone the repo into mnxx/ (name cloned repo 'luastatic')

install moonscript AND OR clone the repo into mnxx/ (name cloned repo 'moonscript')

AFTER CLONING AND OR INSTALLING REPOS AND MOONSCRIPT++ copy the mnxx directory(containing chosen resources into the installer dir)

after mnxx dir is inside installer dir

cd into the installer directory
./installer

how to use. cd into a directory with a .moon or .lua file and
moonxx

then chose -b or -c (-b builds scripts to lua | -c builds and compiles moonscript and or lua into binary)

moonxx
-h 
will display other options. More to come. All binaries other than moonstatic.dll are written in moonscript and have the actual lua and lua.c outputs as well availible. 

WHATS NEXT? Craziness. Alot is comming. Be warned. Moonscript++ will be shipping soon stable. Thanks.
