import std;

struct Machine {
    real memory_size = 0;
    real[] memory = new real[0];
    Registers registers;
    Flags flags;
    int ip;
    int sp;
    int bp;
    int[] stack = new int[0];
}

struct Registers {
    int a;
    int b;
    int c;
    int d;
    string e;
    float f;
    float g;
    double h;
    real i;
    real j;
}

struct Flags {
    bool zero;
    bool negative;
    bool overflow;
    bool carry;
    bool parity;
}

int add(ref Machine machine, real[] params) {
    handleRegisters(machine, params, 2);
    machine.registers.a = cast(int)(params[0] + params[1]);
    handleFlags(machine, machine.registers.a);
    return 2;
}

int sub(ref Machine machine, real[] params) {
    handleRegisters(machine, params, 2);
    machine.registers.a = cast(int)(params[0] - params[1]);
    handleFlags(machine, machine.registers.a);
    return 2;
}

int mul(ref Machine machine, real[] params) {
    handleRegisters(machine, params, 2);
    machine.registers.a = cast(int)(params[0] * params[1]);
    handleFlags(machine, machine.registers.a);
    return 2;
}

int div(ref Machine machine, real[] params) {
    handleRegisters(machine, params, 2);
    machine.registers.f = cast(float)(params[0] / params[1]);
    handleFlags(machine, machine.registers.f);
    return 2;
}

int addf(ref Machine machine, real[] params) {
    handleRegisters(machine, params, 2);
    machine.registers.f = cast(float)params[0] + cast(float)params[1];
    handleFlags(machine, machine.registers.f);
    return 2;
}

int subf(ref Machine machine, real[] params) {
    handleRegisters(machine, params, 2);
    machine.registers.f = cast(float)params[0] - cast(float)params[1];
    handleFlags(machine, machine.registers.f);
    return 2;
}

int mulf(ref Machine machine, real[] params) {
    handleRegisters(machine, params, 2);
    machine.registers.f = cast(float)params[0] * cast(float)params[1];
    handleFlags(machine, machine.registers.f);
    return 2;
}

int and(ref Machine machine, real[] params) {
    handleRegisters(machine, params, 2);
    machine.registers.a = cast(int)(cast(int)params[0] & cast(int)params[1]);
    handleFlags(machine, machine.registers.a);
    return 2;
}

int not(ref Machine machine, real[] params) {
    handleRegisters(machine, params, 1);
    machine.registers.a = cast(int)(~cast(int)params[0]);
    handleFlags(machine, machine.registers.a);
    return 1;
}

int or(ref Machine machine, real[] params) {
    handleRegisters(machine, params, 2);
    machine.registers.a = cast(int)(cast(int)params[0] | cast(int)params[1]);
    handleFlags(machine, machine.registers.a);
    return 2;
}

int xor(ref Machine machine, real[] params) {
    handleRegisters(machine, params, 2);
    machine.registers.a = cast(int)(cast(int)params[0] ^ cast(int)params[1]);
    handleFlags(machine, machine.registers.a);
    return 2;
}

int cp(ref Machine machine, real[] params) {
    handleRegisters(machine, params, 1);
    for (int j = 0; j < 9; j++) {
            if (params[1] == (real.max - j)) {
                if(j!=5)setRegister(machine, j,params[1]);
            }
        }
    return 0;
}
int jmp(ref Machine machine, real[] params) {
    handleRegisters(machine, params, 1);
    machine.ip = (cast(int)params[0])-1;
    return 0;
}
int function(ref Machine machine, real[] params)[26] commands;
void handleOpcode(ref Machine machine, real opcode, real[] params) {
    writeln("opcode:");
    writeln(opcode);
    machine.ip += commands[cast(ulong)opcode](machine, params) + 1;
}

void handleRegisters(ref Machine machine, ref real[] paramList, int count) {
    for (int i = 0; i < count; i++) {
        for (int j = 0; j < 9; j++) {
            if (paramList[i] == (real.max - j)) {
                if(j!=5)paramList[i] = acessRegister(machine, j);
            }
        }
    }
}
real acessRegister(ref Machine machine, real id) {
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
        machine.registers.h = cast(double)value;
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
    Flags flags= machine.flags;
    if (res == 0) flags.zero = true;
    if (res < 0) flags.negative = true;

}
Machine parse(real[] prgm) {
    commands[1] = &add;
    commands[2] = &sub;
    commands[3] = &mul;

    Machine machine = Machine();
    machine.memory_size = cast(real)prgm.length;
    machine.memory = new real[cast(ulong)machine.memory_size];
    machine.memory = prgm;

    while (machine.ip < machine.memory_size) {
        real[] params = machine.memory[machine.ip + 1 .. $];
        handleOpcode(machine, machine.memory[machine.ip], params);
        writeln("state:");
        writeln(machine.registers);
    }
    return machine;
}
real[] compile(string[] source) {
    bool eof = false;
    real[] prgm = new real[0];
   for(int i = 0; i < source.length; i++) {
        string line = source[i];
        real res = 0;
        if (line.indexOf("0x") != -1) {
            res = cast(real)chompPrefix(line, "0x").to!uint(16);
        } else if (line.isNumeric()) {
            res =  cast(real)line.to!uint(10);
        } else {
            switch (line) {
            case "%A":
                res = real.max - 9;
                break;
            case "%B":
                res = real.max - 8;
                break;
            case "%C":
                res = real.max - 7;
                break;
            case "%D":
                res = real.max - 6;
                break;
            case "%E":
                res = real.max - 5;
                break;
            case "%F":
                res = real.max - 4;
                break;
            case "%G":
                res = real.max - 3;
                break;
            case "%H":
                res = real.max - 2;
                break;
            case "%I":
                res = real.max - 1;
                break;
            case "%J":
                res = real.max;
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
                res = 26;
                break;
            case "decf":
                res = 27;
                break;
            
            default:
                break;
            }
        }

        

        prgm.length++;prgm[prgm.length - 1] = res;

    }
    return prgm;
}
Machine parseString(string source) {

    writeln("Tokens:")
    writeln(source.replace(','," ").replace(";"," ").split(" "));
    return parse(compile(source.replace(','," ").replace(";"," ").split(" ")));
}