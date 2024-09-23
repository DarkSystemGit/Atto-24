import std;
import data;
import registers;
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
        //writeln(cast(int)path[i]);
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
   
    writeln("Read, mem: ",machine.memory);
    return 3;
}
class sysManager{
int function(ref Machine machine, real[] params)[] syscalls=[&print,&printASCII,&readFile];
int syscall(Machine m, real sys,real[] params) {
    return syscalls[cast(ulong)sys](m,params)+1;
}}