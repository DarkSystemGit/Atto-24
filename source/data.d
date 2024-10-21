import std;
import mem;
import time;
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
    bool err;
    int errAddr;
    real bp;
    Objects objs;
    machineHeap heap;
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
        writeln("   Heap:");
       foreach(heap; machine.heap.objs) {heap.print();writeln("");}
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
    int e;
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
struct Objects{
    Time[] times;
    int addTime(Time t){
        t.id=times.length;
        times ~= t;
        return t.id;
    }
}