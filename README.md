Moonscript++ - Standalone executable compiler for Moonscript(By Leafo)
Compiler uses Luastatic(By ers53)

How to install
Download .net core SDK/Runtime version 1.1.1

Ubuntu 16.10(SDK)
https://go.microsoft.com/fwlink/?linkid=843460 (.deb) | Or sudo apt-get install dotnet-dev-1.0.1
---
https://go.microsoft.com/fwlink/?linkid=843446 (.tar.gz)
____________________

Ubuntu 16.04(SDK)
https://go.microsoft.com/fwlink/?linkid=843456 (.deb) | Or sudo apt-get install dotnet-dev-1.0.1
---
https://go.microsoft.com/fwlink/?linkid=843462 (.tar.gz)
____________________

Fedora 24(SDK)
https://go.microsoft.com/fwlink/?linkid=843461 (.tar.gz)
(Instructions)
https://www.microsoft.com/net/core#linuxfedora
____________________

Debian 8(SDK)
https://go.microsoft.com/fwlink/?linkid=843453 (.tar.gz)
(Instructions)
https://www.microsoft.com/net/core#linuxdebian
____________________

RHEL(SDK)
https://go.microsoft.com/fwlink/?linkid=843459 (.tar.gz) | Or yum install rh-dotnetcore10
_____________________

openSUSE 42.1(SDK)
https://go.microsoft.com/fwlink/?linkid=843451 (tar.gz)
(Instructions)
https://www.microsoft.com/net/core#linuxopensuse
______________________

openSUSE 13.2(SDK)
https://go.microsoft.com/fwlink/?linkid=843447 (tar.gz)
(Instructions)
https://www.microsoft.com/net/core#linuxopensuse
________________________

Next, make a folder in your home firectory
--
  mkdir ~/gits
-- (Then clone this repository into the new folder)
  cd ~/gits
  git clone https://github.com/owenkimbrell/Moonscriptxx
-- (Then cd into Moonscriptxx, and then into mnxx)
  cd Moonscriptxx
  cd mnxx
-- (Then clone luastatic, luarocks, and moonscript) | OR (Prefered : install luarocks)
  git clone https://github.com/luarocks/luarocks
  git clone https://github.com/ers35/luastatic
  git clone https://github.com/leafo/moonscript (Will have to download dependencies for moonscript, use luarock if unsure)
OR (Prefered Method - Through luarocks)
  sudo apt-get install luarocks | sudo dnf install luarocks
  sudo luarocks install busted
  sudo luarocks install luafilesystem
  sudo luarocks install luastatic
  sudo luarocks install moonscript
--(Then cd back into the Moonscriptxx folder, and move it into the installer)
  cd ..
  mv mnxx installer
--(Then change permissions on installer(executable found inside folder not folder)
  cd installer
  sudo chmod +x installer
--(Then install)
  ./installer

  
How to use (After installation step)
Now you may run moonxx(The executable that links moonstatic and moonstatic.dll together)
This has multiple options, but essentially is for finding all .moon files in a directory, and compiling them to lua, and then c, and finally an executable. (Using moonc, and luastatic, respectivly).

Example( lets imagine a .moon file or mulitiple .moon files containing moonscript is in a directory, and i mean any directory.) -  [ someName.moon ]

moonxx -c     <-- This will compile all .moon files into a executable, with no file extension. This is known as a binary. To run this binary

./someName

Will run the program without needing moonc or lua or moon binaries. This application can be distrobuted to multiple platforms, without needing lua or moonscript installed.
This will also output someName.lua and someName.lua.c


Alot more is comming. Please share, and spread the goodword of luastatic and moonscript, as well as moonscript++. Run moonxx -h for more options. Thanks. 
