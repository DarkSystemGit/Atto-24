import std;
import instructions;
import data;
import print;
import registers;
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

    while (machine.ip < machine.memory_size) {
        real[] params = machine.memory[machine.ip + 1 .. $];
        handleOpcode(machine, machine.memory[machine.ip], params);
    }
    return machine;
}

real[] compile(string src,bool bytecode) {
    string[] source = parseString(src,bytecode);
    bool eof = false;
    real[] prgm = new real[0];
    bool str;
    for (int i = 0; i < source.length; i++) {
        bool e=true;
        string line = source[i];
        real res = 0;
        
        if (line.indexOf("0x") != -1) {
            res = cast(real)chompPrefix(line, "0x").to!uint(16);
        } else if (line.isNumeric()) {
            res = cast(real)line.to!uint(10);
        }else if(str){
            if(line!="\""){
            res=cast(real)((cast(char[])line)[0]);}else{
                str=false;
                res=0;
            }
        } else {
            switch (line) {
            case "%A":
                res = cast(real)4294967296 - 9;
                break;
            case "%B":
                res = cast(real)4294967296 - 8;
                break;
            case "%C":
                res = cast(real)4294967296 - 7;
                break;
            case "%D":
                res = cast(real)4294967296 - 6;
                break;
            case "%E":
                res = cast(real)4294967296 - 5;
                break;
            case "%F":
                res = cast(real)4294967296 - 4;
                break;
            case "%G":
                res = cast(real)4294967296 - 3;
                break;
            case "%H":
                res = cast(real)4294967296 - 2;
                break;
            case "%I":
                res = cast(real)4294967296 - 1;
                break;
            case "%J":
                res = cast(real)4294967296;
                break;
            case "add":
                res = 1;
                break;
            case "sub":
                res = 2;
                break;
            case "mul":
                res = 3;
                break;
            case "addf":
                res = 4;
                break;
            case "subf":
                res = 5;
                break;
            case "mulf":
                res = 6;
                break;
            case "and":
                res = 7;
                break;
            case "not":
                res = 8;
                break;
            case "or":
                res = 9;
                break;
            case "xor":
                res = 10;
                break;
            case "cp":
                res = 11;
                break;
            case "jmp":
                res = 12;
                break;
            case "jnz":
                res = 13;
                break;
            case "jz":
                res = 14;
                break;
            case "cmp":
                res = 15;
                break;
            case "sys":
                res = 16;
                break;
            case "read":
                res = 17;
                break;
            case "write":
                res = 18;
                break;
            case "push":
                res = 19;
                break;
            case "pop":
                res = 20;
                break;
            case "mov":
                res = 21;
                break;
            case "call":
                res = 22;
                break;
            case "ret":
                res = 23;
                break;
            case "inc":
                res = 24;
                break;
            case "dec":
                res = 25;
                break;
            case "incf":
                res = 24;
                break;
            case "decf":
                res = 25;
                break;
            case "true":
            res=1;
            break;
            case "false":
            res=0;
            break;    
            case "\"":
                str=true;
                e=false;
                break;
            case "":
                e=false;
                break;

            default:
                break;
            }
        }

        if(e){prgm.length++;
        prgm[prgm.length - 1] = res;}

    }
    if(bytecode){writeln("Bytes: ",prgm);writeln("Length: ",prgm.length);}
    return prgm;
}

string[] parseString(string source,bool bytecode) {
    string[] rawSrc=source.strip().replace(',', " ").replace(";", "").replace("\n"," ").split(" ");
    string[] tokens = new string[0];
    foreach (string line;rawSrc) {
        if(line.indexOf("\"")==0){
            string[] temp = line.split("");
            tokens ~=temp;
        }else{
            tokens~= [line];
        }
    }
    if(bytecode)writeln("Tokens: ",tokens);
    return tokens;
}

void runPrgm(string name,string source,bool d,bool bytecode) {
    writeln("UASM Interpreter v1.0.0");
    writeln("Compiling...");
    real[] prgm = compile(source,bytecode);
    if(!bytecode){
    writeln("Executing...");
    Machine machine = execBytecode(prgm,d);
    }
}
