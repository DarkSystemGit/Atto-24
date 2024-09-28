import std;
import std.datetime : SysTime;
import std.file;
import core.thread;
import core.time;
import data;
import registers;
char[] readString(ref Machine machine, int mempos) {
    char[] str = new char[0];
    bool eol;
    for(int i=0;!eol;i++){
        if(cast(int)machine.memory[mempos+i]!=0){
            str.length++;
            str[i]=cast(char)cast(int)machine.memory[mempos+i];
        }else{eol=true;}}
    return str;
}
void writeString(ref Machine machine, int mempos, char[] str) {
    str.length++;
    str[str.length-1]=cast(char)0;
     for(int i=0;i<str.length;i++){
        int pos=i+mempos;
        if(pos>machine.memory.length-1)machine.memory.length=pos+1;
        machine.memory[pos]=cast(real)str[i];
        machine.memory_size=machine.memory.length;
    }
    machine.registers.a=cast(int)str.length;
}
//print
int print(ref Machine machine, real[] p) {
       real[] params=handleRegisters(machine, p, 1);
        write(params[0]);
        return 1;
}
int printASCII(ref Machine machine,real[] p) {
     real[] params=handleRegisters(machine, p, 1);
     
        write(params[0].to!char);
        return 1;
    }
int printStr(ref Machine machine,real[] p) {
    real[] params=handleRegisters(machine, p, 1);
    int mempos=cast(int)params[0];
    bool eol;
    for(int i=0;!eol;i++){

        if((machine.memory.length>mempos+i)&&(cast(int)machine.memory[mempos+i]!=0)){
            write(cast(char)cast(int)machine.memory[mempos+i]);
        }else{eol=true;}}
    return 1;
}
//files
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
    file=cast(byte[])read(path);
    for(int i=0;i<file.length;i++){
        int pos=i+mempos;
        if(pos>machine.memory.length-1)machine.memory.length=pos+1;
        machine.memory[pos]=cast(real)file[i];
         machine.memory_size=machine.memory.length;
    }
    return 3;
}
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
    std.file.write(path,file);
    return 3;
}
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
    setRegister(machine,(cast(real)4294967296) -params[1],getSize(path));
    return 2;
}
int getFileLastModified(ref Machine machine,real[] p) {
    real[] params=handleRegisters(machine, p, 1);
    char[] path=readString(machine,cast(int)params[0]);
    long time=path.timeLastModified(SysTime.min).toUnixTime();
    setRegister(machine,(cast(real)4294967296) -params[1],time);
    return 2;
}
int removeFile(ref Machine machine,real[] p) {
    real[] params=handleRegisters(machine, p, 1);
    char[] path=readString(machine,cast(int)params[0]);
    remove(path);
    return 1;
}
int sleep(ref Machine machine,real[] p) {
    real[] params=handleRegisters(machine, p, 1);
    Thread.sleep(dur!("msecs")(cast(int)params[0]));
    return 1;
}
int mkdir(ref Machine machine,real[] p){
     real[] params=handleRegisters(machine, p, 2);
     char[] path=readString(machine,cast(int)params[0]);
     if(!params[1]){
     std.file.mkdir(path);}else{mkdirRecurse(path);}
     return 2;
}
int rmdir(ref Machine machine,real[] p){
     real[] params=handleRegisters(machine, p, 1);
     char[] path=readString(machine,cast(int)params[0]);
     rmdirRecurse(path);
     return 1;
}
int getcwd(ref Machine machine,real[] p){
    real[] params=handleRegisters(machine, p, 1);
    int mempos=cast(int)params[0];
    char[] path=cast(char[])std.file.getcwd();
    writeString(machine,mempos,path);
     return 1;
}
int cd(ref Machine machine,real[] p){
     real[] params=handleRegisters(machine, p, 1);
     char[] path=readString(machine,cast(int)params[0]);
     chdir(path);
     return 1;
}
int isDir(ref Machine machine,real[] p){
    real[] params=handleRegisters(machine, p, 1);
    char[] path=readString(machine,cast(int)params[0]);
    bool ex;
    if(exists(path)){ex=std.file.isDir(path);}
    setRegister(machine,(cast(real)4294967296) -params[1],ex);
    return 2;
}
int isFile(ref Machine machine,real[] p){
    real[] params=handleRegisters(machine, p, 1);
    char[] path=readString(machine,cast(int)params[0]);
    bool ex;
    if(exists(path)){ex=std.file.isFile(path);}
    setRegister(machine,(cast(real)4294967296) -params[1],ex);
    return 2;
}
class sysManager{
int function(ref Machine machine, real[] params)[] syscalls=[
    &print,&printASCII,&printStr,&readFile,
    &writeFile,&getFileLength,&getFileLastModified,&removeFile,
    &sleep,&mkdir,&rmdir,&getcwd,
    &cd,&isDir,&isFile
    ];
int syscall(ref Machine m, real sys,real[] params) {
    return syscalls[cast(ulong)sys](m,params)+1;
}}