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

class sysManager{
int function(ref Machine machine, real[] params)[] syscalls=[&print,&printASCII];
int syscall(Machine m, real sys,real[] params) {
    return syscalls[cast(ulong)sys](m,params)+1;
}}