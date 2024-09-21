import std;
import instructions;
import data;


int function(ref Machine machine, real[] params)[26] commands;
void handleOpcode(ref Machine machine, real opcode, real[] params) {
    int pcount = commands[cast(ulong)opcode](machine, params) + 1;
    machine.ip += pcount;
    if(machine._debug)writeln("[DEBUG] Executed opcode ", printOpcode(opcode), "(", printParams(params[0 .. pcount-1]),");");

}
string printOpcode(real opcode) {
    switch (cast(int)opcode) {
        case 0:
    return "NOP";
    break;
    case 1:
    return "ADD";
    break;
    case 2:
    return "SUB";
        break;
        case 3:
        return "MUL";
        break;
        case 4:
        return "ADDF";
        break;
        case 5:
        return "SUBF";
        break;
        case 6:
        return "MULF";
        break;
        case 7:
        return "AND";
        break;
        case 8:
        return "NOT";
        break;
        case 9:
        return "OR";
        break;
        case 10:
        return "XOR";
        break;
        case 11:
        return "CP";
        break;
        case 12:
        return "JMP";
        break;
        case 13:
        return "JNZ";
        break;
        case 14:
        return "JZ";
        break;
        case 15:
        return "CMP";
        break;
        case 16:
        return "SYS";
        break;
        case 17:
        return "READ";
        break;
        case 18:
        return "WRITE";
        break;
        case 19:
        return "PUSH";
        break;
        case 20:
        return "POP";
        break;
        case 21:
        return "MOV";
        break;
        case 22:
        return "CALL";
        break;
        case 23:
        return "RET";
        break;
        case 24:
        return "INC";
        break;
        case 25:
        return "DEC";
        break;
        default:
        return "UNKNOWN";
        break;}

}
string printParams(real[] params) {
    string[] res = new string[params.length];
    for (int i = 0; i < params.length; i++) {

        if((-1*(params[i]-(cast(real)4294967296)))>0) {
            res[i] = printRegister(-1*(params[i]-(cast(real)4294967296)));
            if(res[i]=="UNKNOWN") res[i] = params[i].to!string;
        }else{
            res[i] = params[i].to!string;
        }
    }
    return res.join(", ");
}


string printRegister(real id) {
    switch (cast(int)id) {
        case 9:
        return "A";
        break;
        case 8:
        return "B";
        break;
        case 7:
        return "C";
            break;
            case 6:
            return "D";
            break;
            case 5:
            return "E";
            break;
            case 4:
            return "F";
            break;
            case 3:
            return "G";
            break;
            case 2:
            return "H";
            break;
            case 1:
            return "I";
            break;
            case 0:
            return "J";
            break;
            default:
            return "UNKNOWN";
            break;
            }
}
real[] handleRegisters(ref Machine machine, real[] paramsRaw, int count) {
    int c = count;
    real[] paramList = paramsRaw.dup;
    if (count == 0){
        c = cast(int)paramList.length - 1;
    }
    for (int i = 0; i < c; i++) {
        for (int j = 0; j <= 9; j++) {
            if (paramList[i] == (cast(real)4294967296 - j)) {
                if (j != 5){
                    paramList[i] = getRegister(machine, j);
            }}
        }
    }
    
    return paramList;
}

real getRegister(ref Machine machine, real id) {
    if(machine._debug)writeln("[DEBUG] Getting register ",printRegister(id));
    switch (cast(int)id) {
    default:
        return 0;
        break;
    case (9):
        return cast(real)machine.registers.a;
        break;
    case (8):
        return cast(real)machine.registers.b;
        break;
    case (7):
        return cast(real)machine.registers.c;
        break;
    case (6):
        return cast(real)machine.registers.d;
        break;
    case (4):
        return cast(real)machine.registers.f;
        break;
    case (3):
        return cast(real)machine.registers.g;
        break;
    case (2):
        return cast(real)machine.registers.h;
        break;
    case (1):
        return cast(real)machine.registers.i;
        break;
    case (0):
        return cast(real)machine.registers.j;
        break;
    }
    return 0;

}

void setRegister(ref Machine machine, real id, real value) {
    if(machine._debug)writeln("[DEBUG] Setting register ", printRegister(id)," to ", value);
    switch (cast(int)id) {
    default:
        break;
    case (9):
        machine.registers.a = cast(int)value;
        break;
    case (8):
        machine.registers.b = cast(int)value;
        break;
    case (7):
        machine.registers.c = cast(int)value;
        break;
    case (6):
        machine.registers.d = cast(int)value;
        break;
    case (4):
        machine.registers.f = cast(float)value;
        break;
    case (3):
        machine.registers.g = cast(float)value;
        break;
    case (2):
        machine.registers.h = cast(real)value;
        break;
    case (1):
        machine.registers.i = value;
        break;
    case (0):
        machine.registers.j = value;
        break;

    }
}

void handleFlags(ref Machine machine, real res) {
    
    if (res == 0)
        machine.flags.zero = true;
    if (res < 0)
        machine.flags.negative = true;

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

real[] compile(string src) {
    string[] source = parseString(src);
    bool eof = false;
    real[] prgm = new real[0];
    for (int i = 0; i < source.length; i++) {
        bool e=true;
        string line = source[i];
        real res = 0;
        if (line.indexOf("0x") != -1) {
            res = cast(real)chompPrefix(line, "0x").to!uint(16);
        } else if (line.isNumeric()) {
            res = cast(real)line.to!uint(10);
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
    return prgm;
}

string[] parseString(string source) {
    return source.strip().replace(',', " ").replace(";", "").replace("\n"," ").split(" ");
}

Machine runPrgm(string name,string source,bool d) {
    writeln("UASM Interpreter v1.0.0");
    writeln("Compiling...");
    real[] prgm = compile(source);
    writeln("Executing...");
    Machine machine = execBytecode(prgm,d);
    writeln("Program ",name," finsished");
    return machine;
}
