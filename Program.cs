using System;
using System.IO;
using System.Text;
using System.Diagnostics;

namespace Test
{
    class Heem
    {
        static void Main(string[] args)
        {
            Mods.getArgs(args);
        }
    }
    class interpMoon
    {
        public static void readFiles(string dirr)
        {
            string[] filse = Mods.getFiles(dirr);
            foreach (string cfils in filse)
            {
                if (cfils.EndsWith(".moon"))
                {
                    using (Stream strrR = File.OpenRead(cfils))
                    {
                        using (StreamReader strRe = new StreamReader(strrR))
                        {
                            string wholeFil = strRe.ReadToEnd();
                            int indxx = wholeFil.IndexOf("--&!") + 4;
                            int indxxx = wholeFil.IndexOf("--!&");
                            int posi = indxxx - indxx;
                            string csmode = wholeFil.Substring(indxx, posi);
                            csmode = csmode.Replace("--", "");
                            wholeFil.Remove(indxx, posi);

                            using (Stream prjcs = File.Create(dirr + "/" + "output.cs"))
                            {
                                using (StreamWriter strRetwo = new StreamWriter(prjcs))
                                {

                                }
                            }
                        }
                    }
                }
            }
        }
    }

    class Mods
    {
        public static bool ifExists(string[] filserch, string loktype)
        {
            foreach (string fillo in filserch)
            {
                if (fillo.EndsWith(loktype))
                {
                    return true;
                }
            }
            return false;
        }
        public static string getCrntDir()
        {
            return Directory.GetCurrentDirectory();
        }
        public static string[] getFiles(string strr)
        {
            return Directory.GetFiles(strr);
        }
        public static string[] getProject(string[] filess)
        {
            int count = 0;
            string[] strB = new string[filess.Length];
            foreach (string fll in filess)
            {
                if (fll.EndsWith(".moon"))
                {
                    strB[count] = fll + " |MN";
                    count++;
                }
                else if (fll.EndsWith(".cs"))
                {
                    strB[count] = fll + " |C#";
                    count++;
                }
                else if (fll.EndsWith(".c"))
                {
                    strB[count] = fll + " |C";
                    count++;
                }
                else if (fll.EndsWith(".csproj"))
                {
                    strB[count] = fll + " |C#P";
                    count++;
                }
                else if (fll.EndsWith(".lua"))
                {
                    strB[count] = fll + " |L";
                    count++;
                }
            }
            return strB;
        }
        public static void getArgs(string[] argos)
        {
            foreach (string argg in argos)
            {
                string cdirr = getCrntDir();
                string[] dfils = getFiles(cdirr);
                string[] pfils = getProject(dfils);
                if (argg == "-b=moon")
                {
                    buildFiles(dfils, false, false, false);
                }
                if (argg == "-b")
                {
                    makeMnxxProj(dfils);
                    buildFiles(dfils, false, false, true);
                }
                if (argg == "-b=msbuild")
                {
                    makeMnxxProj(dfils);
                    buildFiles(dfils, true, false, true);
                }
                if (argg == "-c=moon")
                {
                    interpMoon.readFiles(cdirr);
                }
                if (argg == "-c")
                {
                    buildFiles(dfils, false, true, false);
                }
                if (argg == "-h")
                {
                    string[] helpme = new string[10];
                    helpme[0] = "-b | builds moonscript, and dotnet files found in directory. Does not include binaries from moonscript/lua. For this use, -c";
                    helpme[1] = "-b=msbuild | builds moonscript, and dotnet files (WITH MSBUILD) found in directory. Does not include binaries from moonscript/lua. For this use, -c";
                    helpme[2] = "-c=moon | diffrent from -c, this pre-parses moonscript files to build arbitrary C# code to be used with moonscript. See examples in docs. Does not do any thing else.";
                    helpme[3] = "-c | finds all built moonsript files and turns them into standalone executables in C. To build moonscript files, use -b=moon(only .moon are built) or -b(all files are built)";
                    helpme[4] = "-b=moon | only builds moonscript files in directory.";
                    helpme[5] = "-n <name> | creates a new c#project for moonscript++ to use for arbitrary C# code inside .moon files. Essential for this function to work.";
                    foreach (string stringo in helpme)
                    {
                        Console.WriteLine(stringo);
                    }
                }
                try
                {
                    if (argg == "-n")
                    {
                        dotnett.newConsl(argos[1]);
                    }
                }
                catch (System.IndexOutOfRangeException)
                {
                    Console.WriteLine("Error, no name entered.");
                }
            }
        }
        public static void buildFiles(string[] filos, bool builddType, bool tocee, bool buildnet)
        {
            foreach (string filo in filos)
            {
                if (filo.EndsWith(".moon"))
                {
                    if (tocee)
                    {
                        moonscr.buildMoonn(filo, true);
                    }
                    else
                    {
                        moonscr.buildMoonn(filo, false);
                    }

                }
                if (filo.EndsWith(".csproj") && buildnet)
                {
                    dotnett.restoree(filo);
                    if (builddType)
                    {
                        dotnett.msbuildd(filo);
                    }
                    else
                    {
                        dotnett.dnetbuildd(filo);
                    }
                }
            }
        }
        public static void dueProcess(string namee, string argsss)
        {
            ProcessStartInfo psi = new ProcessStartInfo() { FileName = namee, Arguments = argsss, };
            Process procy = Process.Start(psi);
            procy.WaitForExit();
        }
        public static void makeMnxxProj(string[] filus)
        {
            string cdirr = getCrntDir();
            string[] pfils = getProject(filus);
            Stream fss = File.OpenWrite(cdirr + "/proj.moonxx");
            using (StreamWriter srw = new StreamWriter(fss))
            {
                foreach (string cstr in pfils)
                {
                    srw.WriteLine(cstr);
                }
            }
        }
    }
    class dotnett
    {
        public static void newConsl(string namee)
        {
            Mods.dueProcess("dotnet", "new console -n " + namee + " -o " + Mods.getCrntDir());
        }
        public static void restoree(string filooo)
        {
            Mods.dueProcess("dotnet", "restore " + filooo);
        }
        public static void msbuildd(string filooo)
        {
            Console.WriteLine("Building " + filooo + " with msbuild | .net version");
            Mods.dueProcess("dotnet", "--version");
            Mods.dueProcess("dotnet", "msbuild " + filooo);
        }
        public static void dnetbuildd(string filooo)
        {
            Console.WriteLine("Building " + filooo + " with standard build | .net version");
            Mods.dueProcess("dotnet", "--version");
            Mods.dueProcess("dotnet", "build " + filooo);
        }
    }
    class moonscr
    {
        public static void buildMoonn(string filooo, bool tocee)
        {
            Console.WriteLine("Building " + filooo + " with moonc version ");
            Mods.dueProcess("moonc", "-v");
            Mods.dueProcess("moonc", filooo);
            if (tocee)
            {
                if (Mods.ifExists(Mods.getFiles(Mods.getCrntDir()), ".lua"))
                {
                    foreach (string nfs in Mods.getFiles(Mods.getCrntDir()))
                    {
                        if (nfs.EndsWith(".lua"))
                        {
                            //TODO: FIX THIS!! Going to create temp binary and just execute that.
                            //moonscr.luaaStatic(nfs, Mods.getFiles(Mods.getCrntDir()), "/usr/local/lib/moonxxx/mnxx/ll_53_standard/src/liblua.a", "-I/usr/local/lib/moonxxx/mnxx/ll_53_standard/src/lua");
                            Mods.dueProcess("moonstatic","");
                        }
                    }
                }
            }
        }
        public static void luaaStatic(string filoo, string[] ppfils, string wliblua, string wluadir)
        {
            //TODO: MAKE INSTALLER FOR LUA5.3 SO THAT IT HAS GENERAL LOCATION FOR LIBS ON ALL MACHINES
            string libdirr = wliblua;
            string luadirr = wluadir;
            if (Directory.Exists(libdirr) && Directory.Exists(wluadir))
            {
                Mods.dueProcess("sudo", "luastaic " + filoo + " " + libdirr + " " + luadirr);
            }
            else
            {
                Console.WriteLine("No (lua-5.3.4) - directory found at " + libdirr + " or " + luadirr + " Please install lua or create ll_53 contatining built lua 5.3.4 in home dir (~/ll_53)");
            }
        }
        public static string[] readPfils(string[] pfils, string cdirrr)
        {
            string[] retStrArr = new string[pfils.Length];
            int count = 0;
            Stream strM = File.OpenRead(cdirrr + "/proj.moonxx");
            using (StreamReader strR = new StreamReader(strM))
            {
                while (strR.Peek() >= 0)
                {
                    retStrArr[count] = strR.ReadLine();
                    count++;
                }
            }
            return retStrArr;
        }
    }
}
