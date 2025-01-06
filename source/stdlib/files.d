
import data;
import registers;
import std;
import utils;
import std.file;
import thepath;
//syscall 3;readFile(string* path,char[]* mempos,int size)
int readFile(ref Machine machine,real[] p) {
    real[] params=handleRegisters(machine, p, 3);
    byte[] file=new byte[cast(ulong)params[2]];
    char[] path=new char[1];
    int mempos=cast(int)params[1];
    bool eol;
    for(int i=0;!eol;i++){
        if(cast(int)machine.memory[cast(ulong)params[0]+i]!=0){
        path.length++;
        path[i]=cast(char)cast(int)machine.memory[cast(ulong)params[0]+i];
        }else{eol=true;}
    }
    path.length--;
    file=cast(byte[])read(getSandboxedPath(machine,path));
    for(int i=0;i<file.length;i++){
        int pos=i+mempos;
        if(pos>machine.memory.length-1)machine.memory.length=pos+1;
        machine.memory[pos]=cast(real)file[i];
         machine.memory_size=machine.memory.length;
    }
   
    return 3;
}
//syscall 4;writeFile(string* path,string* str,int size)
int writeFile(ref Machine machine,real[] p) {
    real[] params=handleRegisters(machine, p, 3);
    int filePath=cast(int)params[0];
    int fileLength=cast(int)params[2];
    int filePos=cast(int)params[1];
    bool eol;
    char[] path=new char[1];
    byte[] file=new byte[fileLength];
    for(int i=0;i<fileLength;i++){
        file[i]=cast(byte)machine.memory[i+filePos];
    }
    for(int i=0;!eol;i++){
        if(cast(int)machine.memory[cast(ulong)filePath+i]!=0){
            path.length++;
            path[i]=cast(char)cast(int)machine.memory[filePath+i];
        }else{eol=true;}
    }
    path.length--;
    
    std.file.write(getSandboxedPath(machine,path),file);
    return 3;
}
//syscall 5;getFileLength(string* path,register ret)
int getFileLength(ref Machine machine,real[] p) {
    real[] params=handleRegisters(machine, p, 1);
    char[] path=new char[1];
    bool eol;
    for(int i=0;!eol;i++){
        if(cast(int)machine.memory[cast(ulong)params[0]+i]!=0){
            path.length++;
            path[i]=cast(char)cast(int)machine.memory[cast(ulong)params[0]+i];
        }else{eol=true;}}
        path.length--;
        
    setRegister(machine,p[1],getSize(getSandboxedPath(machine,path)));
    return 2;
}
//syscall 6;getFileLastModified(string* path,register ret)
int getFileLastModified(ref Machine machine,real[] p) {
    real[] params=handleRegisters(machine, p, 1);
    char[] path=readString(machine,cast(int)params[0]);
    long time=path.timeLastModified(SysTime.min).toUnixTime();
    setRegister(machine,p[1],time);
    return 2;
}
//syscall 7;removeFile(string* path)
int removeFile(ref Machine machine,real[] p) {
    real[] params=handleRegisters(machine, p, 1);
    char[] path=readString(machine,cast(int)params[0]);
    
    remove(getSandboxedPath(machine,path));
    
    return 1;
}
//syscall 14; isFile(string* path,register ret)
int isFile(ref Machine machine,real[] p){
    real[] params=handleRegisters(machine, p, 1);
    char[] path=readString(machine,cast(int)params[0]);
    bool ex;
    if(exists(getSandboxedPath(machine,path))){ex=std.file.isFile(getSandboxedPath(machine,path));}
    
    setRegister(machine,p[1],ex);
    return 2;
}
//syscall 15; rename(string* path,string* name)
int rename(ref Machine machine,real[] p){
    real[] params=handleRegisters(machine, p, 2);
    char[] path=readString(machine,cast(int)params[0]);
    char[] name=readString(machine,cast(int)params[1]);
    
    std.file.rename(getSandboxedPath(machine,path),name);
    return 2;
}
