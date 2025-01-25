import std;
import instructions;
import data;
import log;
import registers;
import compiler;
import mem;
import colorize;
import thepath;
import core.sys.posix.signal;
int function(ref Machine machine, double[] params)[34] commands;
bool running;
void handleOpcode(ref Machine machine, double opcode, double[] params)
{   
    machine.currThread.registers.sp=machine.stack.length;
    if (isNaN(opcode))
        opcode = 0;
    int pcount = commands[cast(ulong) opcode](machine, params) + 1;
    //writeln(pcount," ",machine.currThread.ip," ",opcode);
    if(machine.tswitch!=-1){
        Thread ot=machine.threads.getThread(machine.tswitch);
        if (machine._debug){
        writeln("[DEBUG] Addr: ",ot.ip-1,", Executed opcode ", printOpcode(opcode), "(", printParams(
                params[0 .. pcount - 1]), "); | Bytecode: ",ot.mem[ot.ip-pcount..ot.ip]);
        writeln("Switched to Thread ",machine.currThread.id," at ",machine.currThread.ip," ");}
        ot.ip+=pcount;
        machine.tswitch=-1;

    }else{
        machine.currThread.ip += pcount;
        if (machine._debug)
        writeln("[DEBUG] Addr: ",machine.currThread.ip-1,", Executed opcode ", printOpcode(opcode), "(", printParams(
                params[0 .. pcount - 1]), "); | Bytecode: ",machine.currThread.mem[machine.currThread.ip-pcount..machine.currThread.ip]);

    }
    
}
extern(C) void sighandler(int num) nothrow @nogc @system{
    //writeln("SIGINT");
    running=false;
}
Machine execBytecode(double[] prgm, bool d,Path bp)
{   
    chdir(bp.toString);
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
    commands[33]=  &instructions.interruptHandler;
    Machine machine;
    machine._debug = d;
    machine.basepath=bp.toString;
    machine.dprompt=true;
    machine.threads=new ThreadList(&machine);
    machine.currThread=machine.threads.head;
    machine.currThread.mem.length = cast(ulong) prgm.length+64;
    machine.currThread.mem[0..prgm.length] = prgm[];
    machine.currThread.heap= new Heap(machine.currThread);
    machine.currThread.mem.length = machine.currThread.heap.ptr;
    machine.running=true;
    running=machine.running;
    while ((machine.currThread.ip < machine.currThread.mem.length)&&running)
    {  
            if(machine.intScheduled){
                machine.intHandler.doInturrupt(0,machine);
                machine.intScheduled=false;
            }
            if(!machine.running){
                if(machine.currThread.id==0){break;}
                if(!(machine.currThread.next.id==machine.currThread.id)){machine.running=true;machine.threads.switchThread(0);machine.tswitch=-1;}
            }
            if(machine._debug){
                dbgloop(machine);
            }
            try{
                double[] params = machine.currThread.mem[machine.currThread.ip + 1 .. $];
                handleOpcode(machine, machine.currThread.mem[machine.currThread.ip], params);
            }catch (Throwable t)
            {   
                handleError(machine,t);
            }
       
    }
    exit(machine,[]);
    return machine;
}
void handleError(ref Machine machine,Throwable t){

                if(machine._debug)writeln("[DEBUG] An Error Occured at ",machine.currThread.ip,"\n",t);
                machine.stack.length++;
                machine.currThread.registers.sbp++;
                machine.stack.insertInPlace(cast(ulong)machine.currThread.registers.sbp-1, machine.currThread.ip);
                if(machine.currThread.errAddr!=0){
                machine.currThread.ip = machine.currThread.errAddr;}else{
                    machine.stack.length--;
                    cwrite(("[ERROR] ").color(fg.red).color(mode.bold));
                    cwriteln(("An Error occured at this address: "~machine.currThread.ip.to!string).color(mode.bold));
                    cwriteln(("Thread ID:"~machine.currThread.id.to!string).color(mode.bold));
                    cwriteln("Stack:".color(mode.bold));
                    cwriteln(machine.stack.to!string().color(mode.bold));
                    cwriteln(("SBP: "~machine.currThread.registers.sbp.to!string()).color(mode.bold));
                    cwriteln(("SP: "~machine.currThread.registers.sp.to!string()).color(mode.bold));
                    cwriteln("Call Stack:".color(mode.bold));
                    cwriteln(machine.raddr.to!string().color(mode.bold));
                    cwriteln(("Registers:").color(mode.bold));
                    cwriteln(("A: "~machine.currThread.registers.a.to!string()).color(mode.bold));
                    cwriteln(("B: "~machine.currThread.registers.b.to!string()).color(mode.bold));
                    cwriteln(("C: "~machine.currThread.registers.c.to!string()).color(mode.bold));
                    cwriteln(("D: "~machine.currThread.registers.d.to!string()).color(mode.bold));
                    cwriteln(("E: "~machine.currThread.registers.e.to!string()).color(mode.bold));
                    cwriteln(("F: "~machine.currThread.registers.f.to!string()).color(mode.bold));
                    cwriteln(("G: "~machine.currThread.registers.g.to!string()).color(mode.bold));
                    cwriteln(("H: "~machine.currThread.registers.h.to!string()).color(mode.bold));
                    cwriteln(("I: "~machine.currThread.registers.i.to!string()).color(mode.bold));
                    cwriteln(("J: "~machine.currThread.registers.j.to!string()).color(mode.bold));
                    machine.running=false;
                    machine.unhandledErr=true;
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
        case "dumptmem":
            writeln(m.currThread.mem);
            break;
        case "dumpthreads":
            m.threads.print();
            break;
        case "dumpInternal":
            writeln(m);
            break;  
        case "memusage":
            writeln((m.currThread.mem.length/1024).to!string~"KB");
            break;
        case "kill":
            running=false;   
            break;  
        case "isRunning":
            writeln("Run State:  ",m.running);
            break;
        case "%A":
            writeln(m.currThread.registers.a);
            break;
        case "%B":
            writeln(m.currThread.registers.b);
            break;
        case "%C":
            writeln(m.currThread.registers.c);
            break;
        case "%D":
            writeln(m.currThread.registers.d);
            break;
        case "%E":
            writeln(m.currThread.registers.e);
            break;
        case "%F":
            writeln(m.currThread.registers.f);
            break;
        case "%G":
            writeln(m.currThread.registers.g);
            break;
        case "%H":
            writeln(m.currThread.registers.h);
            break;
        case "%I":
            writeln(m.currThread.registers.i);
            break;
        case "%J":
            writeln(m.currThread.registers.j);
            break;
        case "%SP":
            writeln(m.currThread.registers.sp);
            break;   
        case "%SBP":
            writeln(m.currThread.registers.sbp);
            break;     
        case "flags":
            writeln(m.currThread.flags);
            break; 
        case "stack":
            writeln(m.stack);
            break;
        case "disprompt":
            m.dprompt=false;
            break;
        case "help":
            cwriteln("Debugger Commands:".color(mode.bold));
            writeln("continue: Continue Execution");
            writeln("dump: Dump Machine State");
            writeln("kill: Kill Machine");
            writeln("isRunning: Check if machine is running");
            writeln("%A: Print Register A");
            writeln("%B: Print Register B");
            writeln("%C: Print Register C");
            writeln("%D: Print Register D");
            writeln("%E: Print Register E");
            writeln("%F: Print Register F");
            writeln("%G: Print Register G");
            writeln("%H: Print Register H");
            writeln("%I: Print Register I");
            writeln("%J: Print Register J");
            writeln("%SP: Print Stack Pointer");
            writeln("%SBP: Print Stack Base Pointer");
            writeln("flags: Print Flags");
            writeln("stack: Print Stack");
            writeln("write: Write to memory");
            writeln("disprompt: Disable Debugger Prompt");
            writeln("help: Print this help message");
            writeln("memusage: Print Memory Usage");
            writeln("dumptmem: Print Thread Memory");
            writeln("dumpthreads: Print Threads");
            break;   
        default: 
            if(line.canFind("dump")){
                string[] parts=line.split(" ");
                if(parts.length==1)writeln(m.currThread.mem[parts[0].to!ulong]);
                writeln(m.currThread.mem[parts[1].to!int..parts[2].to!int]);
            }else if(line.canFind("write")){
                string[] parts=line.split(" ");
                m.currThread.mem[parts[1].to!ulong]=parts[2].to!double;
            }else if(line.canFind("bp")){
                string[] parts=line.split(" ");

            }else{return true;}  
        }
        return false;
}
void dbgloop(ref Machine machine){
    if(!machine.dprompt)return;
    try{
    cwrite((machine.currThread.ip.to!string~">").color(mode.bold));
                string line;
                while((line=readln())is null){}
                line=line.strip();
                if(!debugPrompt(machine,line))dbgloop(machine);}catch(Throwable){cwriteln("Invalid Command".color(mode.bold).color(fg.red));dbgloop(machine);}
}
void interrupt(ref Machine m,int id){
    //m.intScheduled=true;
}