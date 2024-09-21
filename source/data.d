import std;
import io;
struct Machine {
    real memory_size = 0;
    real[] memory = new real[0];
    Registers registers;
    Flags flags;
    int ip;
    int raddr;
    int sp;
    int p;
    bool _debug;
    real bp;
    real[] stack = new real[0];
    void print() {
        Machine machine = this;
        writeln("Machine:");
        writeln("   Registers:");
        writeln("   A: ", machine.registers.a);
        writeln("   B: ", machine.registers.b);
        writeln("   C: ", machine.registers.c);
        writeln("   D: ", machine.registers.d);
        writeln("   E: ", machine.registers.e);
        writeln("   F: ", machine.registers.f);
        writeln("   G: ", machine.registers.g);
        writeln("   H: ", machine.registers.h);
        writeln("   I: ", machine.registers.i);
        writeln("   J: ", machine.registers.j);
        writeln("   Stack:");
        writeln("       ", machine.stack);
        writeln("   Memory:");
        writeln("       ", machine.memory);
        writeln("   Instruction Pointer: ", machine.ip);
        writeln("   Flags:");
        writeln("   Zero: ", machine.flags.zero);
        writeln("   Overflow: ", machine.flags.overflow);
        writeln("   Negative: ", machine.flags.negative);
        writeln("   Carry: ", machine.flags.carry);
    }
}

struct Registers {
    int a;
    int b;
    int c;
    int d;
    string e;
    float f;
    float g;
    real h;
    real i;
    real j;
}

struct Flags {
    bool zero;
    bool negative;
    bool overflow;
    bool carry;
}
class sysHandler{
    int paramCount;
    void syscall(Machine machine, real[] params);
}
class sysManager{
sysHandler[] syscalls=[new printHandler()];
int getParamCount(real syscall) {
    return syscalls[cast(ulong)syscall].paramCount;
}
void syscall(Machine m, real sys,real[] params) {
    syscalls[cast(ulong)sys].syscall(m,params);
}}