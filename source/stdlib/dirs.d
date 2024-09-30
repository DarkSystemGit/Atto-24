
import data;
import registers;
import std;
import utils;
import std.file;
//syscall 9; mkdir(string* path,bool recursive)
int mkdir(ref Machine machine,real[] p){
     real[] params=handleRegisters(machine, p, 2);
     char[] path=readString(machine,cast(int)params[0]);
     if(!params[1]){
     std.file.mkdir(path);}else{mkdirRecurse(path);}
     return 2;
}
//syscall 10; rmdir(string* path)
int rmdir(ref Machine machine,real[] p){
     real[] params=handleRegisters(machine, p, 1);
     char[] path=readString(machine,cast(int)params[0]);
     rmdirRecurse(path);
     return 1;
}
//syscall 11; getcwd(char[]* mempos)
int getcwd(ref Machine machine,real[] p){
    real[] params=handleRegisters(machine, p, 1);
    int mempos=cast(int)params[0];
    char[] path=cast(char[])std.file.getcwd();
    writeString(machine,mempos,path);
     return 1;
}
//syscall 12; cd(string* path)
int cd(ref Machine machine,real[] p){
     real[] params=handleRegisters(machine, p, 1);
     char[] path=readString(machine,cast(int)params[0]);
     chdir(path);
     return 1;
}
//syscall 13; isDir(string* path,register ret)
int isDir(ref Machine machine,real[] p){
    real[] params=handleRegisters(machine, p, 1);
    char[] path=readString(machine,cast(int)params[0]);
    bool ex;
    if(exists(path)){ex=std.file.isDir(path);}
    setRegister(machine,(cast(real)4294967296) -params[1],ex);
    return 2;
}
//syscall 16; ls(string* path,char[][] mempos)
int ls(ref Machine machine,real[] p){
    real[] params=handleRegisters(machine, p, 2);
    char[] path=readString(machine,cast(int)params[0]);
    int mempos=cast(int)params[1];
    char[][] files=cast(char[][])listdir(cast(string)path);
    for(int i=0;i<files.length;i++){
     writeString(machine,mempos,files[i]);
     mempos+=files[i].length;
    }
     return 2;
}    