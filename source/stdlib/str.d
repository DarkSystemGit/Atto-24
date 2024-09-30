import std;
import data;
import registers;
import utils;
//syscall 17; strlen(string* str,register ret)
int strlen(ref Machine machine,real[] p){
    real[] params=handleRegisters(machine, p, 1);
    char[] str=readString(machine,cast(int)params[0]);
    setRegister(machine,(cast(real)4294967296)-params[1],str.length);
    return 2;
}
//syscall 18; strcat(string* str,string* str2,char[]* mempos)
int strcat(ref Machine machine,real[] p){
    real[] params=handleRegisters(machine, p, 3);
    char[] str=readString(machine,cast(int)params[0]);
    str.length--;
    str~=readString(machine,cast(int)params[1]);
    int mempos=cast(int)params[2];
    writeString(machine,mempos,str);
    return 3;
}
//syscall 19; strcpy(string* str,string* cmp,int len)
int strcpy(ref Machine machine,real[] p){
    real[] params=handleRegisters(machine, p, 3);
    char[] str=readString(machine,cast(int)params[0]);
    int mempos=cast(int)params[1];
    int len=cast(int)params[2];
    for(int i=0;i<len;i++){
        int pos=i+mempos;
        if(pos>machine.memory.length-1)machine.memory.length=pos+1;
        machine.memory[pos]=cast(real)str[i];
        machine.memory_size=machine.memory.length;
    }
    machine.registers.a=cast(int)params[2];
    return 3;
}
//syscall 20; strcmp(string* str,string* cmp)
int strcmp(ref Machine machine,real[] p){
    real[] params=handleRegisters(machine, p, 2);
    real register=(cast(real)4294967296)-params[2];
    setRegister(machine,register,readString(machine,cast(int)params[0])==readString(machine,cast(int)params[1]));
    return 3;
}