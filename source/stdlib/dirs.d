import data;
import registers;
import std;
import utils;
import std.file;
import thepath;

import mem;

//syscall 9; mkdir(string* path,bool recursive)
int mkdir(ref Machine machine, double[] p)
{
     double[] params = handleRegisters(machine, p, 2);
     char[] path = cast(char[]) getSandboxedPath(machine, readString(machine, cast(int) params[0]));
     if (!params[1])
     {
          std.file.mkdir(path);
     }
     else
     {
          mkdirRecurse(path);
     }
     return 2;
}
//syscall 10; rmdir(string* path)
int rmdir(ref Machine machine, double[] p)
{
     double[] params = handleRegisters(machine, p, 1);
     char[] path = cast(char[]) getSandboxedPath(machine, readString(machine, cast(int) params[0]));
     rmdirRecurse(path);
     return 1;
}
//syscall 11; getcwd(char[]* mempos)
int getcwd(ref Machine machine, double[] p)
{
     char[] path = cast(char[]) std.file.getcwd();
     path = cast(char[])(Path(cast(string) path).relativeTo(Path(machine.basepath)).toString);
     int addr=machine.currThread.heap.getDataPtr(machine.currThread.heap.getObj(cast(int)path.length));
     writeString(machine, addr, path);
     setRegister(machine, p[0], addr);
     return 1;
}
//syscall 12; cd(string* path)
int cd(ref Machine machine, double[] p)
{
     double[] params = handleRegisters(machine, p, 1);
     char[] path = cast(char[]) getSandboxedPath(machine, readString(machine, cast(int) params[0]));
     chdir(path);
     return 1;
}
//syscall 13; isDir(string* path,register ret)
int isDir(ref Machine machine, double[] p)
{
     double[] params = handleRegisters(machine, p, 1);
     char[] path = cast(char[]) getSandboxedPath(machine, readString(machine, cast(int) params[0]));
     bool ex;
     if (exists(path))
     {
          ex = std.file.isDir(path);
     }
     setRegister(machine, p[1], ex);
     return 2;
}
//syscall 16; ls(string* path,char[][] mempos)
int ls(ref Machine machine, double[] p)
{
     double[] params = handleRegisters(machine, p, 2);
     char[] path = cast(char[]) getSandboxedPath(machine, readString(machine, cast(int) params[0]));
     int mempos = cast(int) params[1];
     char[][] files = cast(char[][]) listdir(cast(string) path);
     for (int i = 0; i < files.length; i++)
     {
          writeString(machine, mempos, files[i]);
          mempos += files[i].length;
     }
     return 2;
}
