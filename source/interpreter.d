import std;
import instructions;
import data;
import log;
import registers;
import compiler;
int function(ref Machine machine, real[] params)[26] commands;
void handleOpcode(ref Machine machine, real opcode, real[] params) {
    int pcount = commands[cast(ulong)opcode](machine, params) + 1;
    machine.ip += pcount;
    if(machine._debug)writeln("[DEBUG] Executed opcode ", printOpcode(opcode), "(", printParams(params[0 .. pcount-1]),");");

}



Machine execBytecode(real[] prgm,bool d) {
    commands[0] = &nop;
    commands[1] = &add;
    commands[2] = &sub;
    commands[3] = &mul;
    commands[4] = &addf;
    commands[5] = &subf;
    commands[6] = &mulf;
    commands[7] = &and;
    commands[8] = &not;
    commands[9] = &or;
    commands[10] = &xor;
    commands[11] = &cp;
    commands[12] = &jmp;
    commands[13] = &jnz;
    commands[14] = &jz;
    commands[15] = &cmp;
    commands[16] = &sys;
    commands[17] = &read;
    commands[18] = &write;
    commands[19] = &push;
    commands[20] = &pop;
    commands[21] = &mov;
    commands[22] = &call;
    commands[23] = &ret;
    commands[24] = &inc;
    commands[25] = &dec;
    Machine machine = Machine();
    machine._debug = d;
    machine.memory_size = cast(real)prgm.length;
    machine.memory = new real[cast(ulong)machine.memory_size];
    machine.memory = prgm;

    while (machine.ip < machine.memory.length) {
        real[] params = machine.memory[machine.ip + 1 .. $];
        handleOpcode(machine, machine.memory[machine.ip], params);
    }
    return machine;
}



void runPrgm(string source,bool d,bool bytecode) {
    writeln("UASM Interpreter v1.0.0");
    writeln("Compiling...");
    real[] prgm = compile(source,bytecode);
    if(!bytecode){
    writeln("Executing...");
    Machine machine = execBytecode(prgm,d);
    }
}
