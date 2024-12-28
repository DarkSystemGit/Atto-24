import std;
import instructions;
import data;
import log;
import registers;
import compiler;
import mem;
import colorize;
import core.sys.posix.signal;
int function(ref Machine machine, real[] params)[33] commands;
bool running;
void handleOpcode(ref Machine machine, real opcode, real[] params)
{   
    machine.registers.sp=machine.stack.length;
    if (isNaN(opcode))
        opcode = 0;
    int pcount = commands[cast(ulong) opcode](machine, params) + 1;
    //writeln(pcount," ",machine.ip," ",opcode);
    machine.ip += pcount;
    if (machine._debug)
        writeln("[DEBUG] Addr: ",machine.ip-1,", Executed opcode ", printOpcode(opcode), "(", printParams(
                params[0 .. pcount - 1]), "); | Bytecode: ",machine.memory[machine.ip-pcount..machine.ip-1]);

}
extern(C) void sighandler(int num) nothrow @nogc @system{
    //writeln("SIGINT");
    running=false;
}
Machine execBytecode(real[] prgm, bool d)
{   
    signal(SIGINT, &sighandler);
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
    commands[30]=  &breakpoint;
    commands[31] = &jg;
    commands[32] = &jng;
    Machine machine = Machine();
    machine._debug = d;
    machine.memory_size = (cast(real) prgm.length + 50);
    machine.memory = prgm;
    machine.memory.length = cast(ulong) machine.memory_size;
    machine.heap = new machineHeap(cast(int) machine.memory_size, &machine);
    machine.memory.length = machine.heap.ptr;
    machine.memory_size = machine.memory.length;
    machine.running=true;
    running=machine.running;
    while ((machine.ip < machine.memory.length)&&machine.running&&running)
    {
            if(machine._debug){
                dbgloop(machine);
            }
            try{
                try{
                real[] params = machine.memory[machine.ip + 1 .. $];
                handleOpcode(machine, machine.memory[machine.ip], params);}catch(Error e){handleError(machine);writeln(e);}
            }catch (Exception e)
            {   
                writeln(e);
                handleError(machine);
            }
       
    }
    exit(machine,[]);
    return machine;
}
void handleError(ref Machine machine){
                if(machine._debug)writeln("[DEBUG] An Error Occured at ",machine.ip);
                machine.stack.length++;
                machine.stack[machine.stack.length - 1] =machine.ip;
                if(machine.errAddr!=0){
                machine.ip = machine.errAddr;}else{
                    machine.stack.length--;
                    cwrite(("[ERROR] ").color(fg.red).color(mode.bold));
                    cwriteln(("An Error occured at this address: "~machine.ip.to!string).color(mode.bold));
                    cwriteln("Stack:".color(mode.bold));
                    cwriteln(machine.stack.to!string().color(mode.bold));
                    cwriteln(("SBP: "~machine.registers.sbp.to!string()).color(mode.bold));
                    cwriteln(("SP: "~machine.registers.sp.to!string()).color(mode.bold));
                    cwriteln("Call Stack:".color(mode.bold));
                    cwriteln(machine.raddr.to!string().color(mode.bold));
                    cwriteln(("Registers:").color(mode.bold));
                    cwriteln(("A: "~machine.registers.a.to!string()).color(mode.bold));
                    cwriteln(("B: "~machine.registers.b.to!string()).color(mode.bold));
                    cwriteln(("C: "~machine.registers.c.to!string()).color(mode.bold));
                    cwriteln(("D: "~machine.registers.d.to!string()).color(mode.bold));
                    cwriteln(("E: "~machine.registers.e.to!string()).color(mode.bold));
                    cwriteln(("F: "~machine.registers.f.to!string()).color(mode.bold));
                    cwriteln(("G: "~machine.registers.g.to!string()).color(mode.bold));
                    cwriteln(("H: "~machine.registers.h.to!string()).color(mode.bold));
                    cwriteln(("I: "~machine.registers.i.to!string()).color(mode.bold));
                    cwriteln(("J: "~machine.registers.j.to!string()).color(mode.bold));
                    machine.running=false;
                }
}
bool debugPrompt(ref Machine m,string line){
    switch (line){
        case "continue":
            m._debug=false;
            break;
        case "dump":
            m.print(); 
            break;
        case "kill":
            running=false;   
            break;  
        case "isRunning":
            writeln("Run State:  ",m.running);
            break;
        case "%A":
            writeln(m.registers.a);
            break;
        case "%B":
            writeln(m.registers.b);
            break;
        case "%C":
            writeln(m.registers.c);
            break;
        case "%D":
            writeln(m.registers.d);
            break;
        case "%E":
            writeln(m.registers.e);
            break;
        case "%F":
            writeln(m.registers.f);
            break;
        case "%G":
            writeln(m.registers.g);
            break;
        case "%H":
            writeln(m.registers.h);
            break;
        case "%I":
            writeln(m.registers.i);
            break;
        case "%J":
            writeln(m.registers.j);
            break;
        case "%SP":
            writeln(m.registers.sp);
            break;   
        case "%SBP":
            writeln(m.registers.sbp);
            break;     
        case "flags":
            writeln(m.flags);
            break;    
        default: 
            if(line.canFind("dump")){
                string[] parts=line.split(" ");
                writeln(m.memory[parts[1].to!int..parts[2].to!int]);
            }else{return true;}  
        }
        return false;
}
void dbgloop(ref Machine machine){
    try{
    write(machine.ip,">");
                string line;
                while((line=readln())is null){}
                line=line.strip();
                if(!debugPrompt(machine,line))dbgloop(machine);}catch(Throwable){writeln("Invalid Command");dbgloop(machine);}
}