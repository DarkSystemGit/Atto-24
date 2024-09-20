import std;
import instructions;

struct Machine {
    real memory_size = 0;
    real[] memory = new real[0];
    Registers registers;
    Flags flags;
    int ip;
    int raddr;
    int sp;
    int p;
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

int function(ref Machine machine, real[] params)[26] commands;
void handleOpcode(ref Machine machine, real opcode, real[] params) {
    int pcount = commands[cast(ulong)opcode](machine, params) + 1;
    machine.ip += pcount;
}

void handleRegisters(ref Machine machine, ref real[] paramList, int count) {
    int c = count;
    if (count == 0)
        c = cast(int)paramList.length - 1;

    for (int i = 0; i < c; i++) {

        for (int j = 0; j <= 9; j++) {
            if (paramList[i] == (cast(real)4294967296 - j)) {
                if (j != 5)
                    paramList[i] = getRegister(machine, j);
            }
        }
    }

}

real getRegister(ref Machine machine, real id) {
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
    writeln("Setting register ", id," to ", value);
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

Machine execBytecode(real[] prgm) {
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
    commands[16] = &nop;
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
    writeln("Bytecode:");
    writeln(prgm);
    return prgm;
}

string[] parseString(string source) {
    writeln("Tokens:");
    writeln(source.strip().replace(',', " ").replace(";", "").replace("\n"," ").split(" "));
    return source.strip().replace(',', " ").replace(";", "").replace("\n"," ").split(" ");
}

Machine runPrgm(string name,string source) {
    writeln("UASM Interpreter v1.0.0");
    writeln("Compiling...");
    real[] prgm = compile(source);
    writeln("Executing...");
    Machine machine = execBytecode(prgm);
    writeln("Program ",name," finsished");
    machine.print();
    return machine;
}
