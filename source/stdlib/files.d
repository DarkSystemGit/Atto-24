
import data;
import registers;
import std;
import utils;
import std.file;
import thepath;
int readFile(ref Machine machine,double[] p) {
    double[] params=handleRegisters(machine, p, 3);
    double[] file=new double[cast(ulong)params[2]];
    char[] path=new char[1];
    int mempos=cast(int)params[1];
    bool eol;
    for(int i=0;!eol;i++){
        if(cast(int)machine.currThread.mem[cast(ulong)params[0]+i]!=0){
        path.length++;
        path[i]=cast(char)cast(int)machine.currThread.mem[cast(ulong)params[0]+i];
        }else{eol=true;}
    }
    path.length--;
    file=cast(double[])read(getSandboxedPath(machine,path));
    for(int i=0;i<file.length;i++){
        int pos=i+mempos;
        if(pos>machine.currThread.mem.length-1)machine.currThread.mem.length=pos+1;
        machine.currThread.mem[pos]=cast(double)file[i];
    }
   
    return 3;
}
int writeFile(ref Machine machine,double[] p) {
    double[] params=handleRegisters(machine, p, 3);
    int filePath=cast(int)params[0];
    int fileLength=cast(int)params[2];
    int filePos=cast(int)params[1];
    bool eol;
    char[] path=new char[1];
    double[] file=new double[fileLength];
    for(int i=0;i<fileLength;i++){
        file[i]=machine.currThread.mem[i+filePos];
    }
    for(int i=0;!eol;i++){
        if(cast(int)machine.currThread.mem[cast(ulong)filePath+i]!=0){
            path.length++;
            path[i]=cast(char)cast(int)machine.currThread.mem[filePath+i];
        }else{eol=true;}
    }
    path.length--;
    std.file.write(getSandboxedPath(machine,path),file);
    return 3;
}
//syscall 4;writeTextFile(string* path,char[]* data,int size)
int writeTextFile(ref Machine machine,double[] p){
    double[] params=handleRegisters(machine, p, 3);
    int filePath=cast(int)params[0];
    int fileLength=cast(int)params[2];
    int filePos=cast(int)params[1];
    bool eol;
    char[] path=new char[1];
    byte[] file=new byte[fileLength];
    for(int i=0;i<fileLength;i++){
        file[i]=cast(byte)machine.currThread.mem[i+filePos];
    }
    for(int i=0;!eol;i++){
        if(cast(int)machine.currThread.mem[cast(ulong)filePath+i]!=0){
            path.length++;
            path[i]=cast(char)cast(int)machine.currThread.mem[filePath+i];
        }else{eol=true;}
    }
    path.length--;
    
    std.file.write(getSandboxedPath(machine,path),file);
    return 3;
}
//syscall 3;readTextFile(string* path,char[]* mempos,int size)
int readTextFile(ref Machine machine,double[] p) {
    double[] params=handleRegisters(machine, p, 3);
    byte[] file=new byte[cast(ulong)params[2]];
    char[] path=new char[1];
    int mempos=cast(int)params[1];
    bool eol;
    for(int i=0;!eol;i++){
        if(cast(int)machine.currThread.mem[cast(ulong)params[0]+i]!=0){
        path.length++;
        path[i]=cast(char)cast(int)machine.currThread.mem[cast(ulong)params[0]+i];
        }else{eol=true;}
    }
    path.length--;
    file=cast(byte[])read(getSandboxedPath(machine,path));
    for(int i=0;i<file.length;i++){
        int pos=i+mempos;
        if(pos>machine.currThread.mem.length-1)machine.currThread.mem.length=pos+1;
        machine.currThread.mem[pos]=cast(double)file[i];
    }
   
    return 3;
}
//syscall 5;getFileLength(string* path,register ret)
int getFileLength(ref Machine machine,double[] p) {
    double[] params=handleRegisters(machine, p, 1);
    char[] path=new char[1];
    bool eol;
    for(int i=0;!eol;i++){
        if(cast(int)machine.currThread.mem[cast(ulong)params[0]+i]!=0){
            path.length++;
            path[i]=cast(char)cast(int)machine.currThread.mem[cast(ulong)params[0]+i];
        }else{eol=true;}}
        path.length--;
        
    setRegister(machine,p[1],getSize(getSandboxedPath(machine,path)));
    return 2;
}
//syscall 6;getFileLastModified(string* path,register ret)
int getFileLastModified(ref Machine machine,double[] p) {
    double[] params=handleRegisters(machine, p, 1);
    char[] path=readString(machine,cast(int)params[0]);
    long time=path.timeLastModified(SysTime.min).toUnixTime();
    setRegister(machine,p[1],time);
    return 2;
}
//syscall 7;removeFile(string* path)
int removeFile(ref Machine machine,double[] p) {
    double[] params=handleRegisters(machine, p, 1);
    char[] path=readString(machine,cast(int)params[0]);
    
    remove(getSandboxedPath(machine,path));
    
    return 1;
}
//syscall 14; isFile(string* path,register ret)
int isFile(ref Machine machine,double[] p){
    double[] params=handleRegisters(machine, p, 1);
    char[] path=readString(machine,cast(int)params[0]);
    bool ex;
    if(exists(getSandboxedPath(machine,path))){ex=std.file.isFile(getSandboxedPath(machine,path));}
    
    setRegister(machine,p[1],ex);
    return 2;
}
//syscall 15; rename(string* path,string* name)
int rename(ref Machine machine,double[] p){
    double[] params=handleRegisters(machine, p, 2);
    char[] path=readString(machine,cast(int)params[0]);
    char[] name=readString(machine,cast(int)params[1]);
    
    std.file.rename(getSandboxedPath(machine,path),name);
    return 2;
}
