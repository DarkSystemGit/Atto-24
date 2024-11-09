import std;
import instructions;
import data;
import log;
import registers;
import compiler;
import mem;

int function(ref Machine machine, real[] params)[30] commands;
void handleOpcode(ref Machine machine, real opcode, real[] params)
{
    if (isNaN(opcode))
        opcode = 0;
    int pcount = commands[cast(ulong) opcode](machine, params) + 1;
    machine.ip += pcount;
    if (machine._debug)
        writeln("[DEBUG] Executed opcode ", printOpcode(opcode), "(", printParams(
                params[0 .. pcount - 1]), ");");

}

Machine execBytecode(real[] prgm, bool d)
{
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
    commands[26] = &setErrAddr;
    commands[27] = &exit;
    commands[28] = &div;
    commands[29] = &mod;
    Machine machine = Machine();
    machine._debug = d;
    machine.memory_size = (cast(real) prgm.length + 50);
    machine.memory = prgm;
    machine.memory.length = cast(ulong) machine.memory_size;
    machine.heap = new machineHeap(cast(int) machine.memory_size, machine.memory[cast(ulong) machine.memory_size .. $]);
    machine.memory.length = machine.heap.ptr;
    machine.memory_size = machine.memory.length;
    machine.running=true;
    while ((machine.ip < machine.memory.length)&&machine.running)
    {
        if (!machine.err)
        {
            try
            {
                
                real[] params = machine.memory[machine.ip + 1 .. $];
                handleOpcode(machine, machine.memory[machine.ip], params);
            }
            catch (Exception e)
            {   
                machine.err = true;
                machine.stack.length++;
                machine.stack[machine.stack.length - 1] =machine.ip;
            }
        }
        else
        {   
            machine.ip = machine.errAddr;
            machine.err = false;
        }
    }
    return machine;
}


