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
    int* d;
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
    switch (cast(int)params[1]) {
        default:
            break;
        case (real.max - 9):
           machine.registers.a=cast(int)params[1];
            break;
        case (real.max - 8):
            machine.registers.b=cast(int)params[1];
            break;
        case (real.max - 7):
            machine.registers.c=cast(int)params[1];
            break;
        case (real.max - 6):
            machine.registers.d=*params[1];
            break;
       
        case (real.max - 4):
            machine.registers.f=cast(float)params[1];
            break;
        case (real.max - 3):
           machine.registers.g=cast(float)params[1];
            break;
        case (real.max - 2):
            machine.registers.h=cast(double)params[1];
            break;
        case (real.max - 1):
           machine.registers.i=params[1];
            break;
        case real.max:
            machine.registers.j=params[1];
            break;
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
                if(j!=5)paramList[i] = acessRegister(machine, paramList[i]);
            }
        }
    }
}
real acessRegister(ref Machine machine, real id) {
    switch (cast(int)id) {
        default:
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
