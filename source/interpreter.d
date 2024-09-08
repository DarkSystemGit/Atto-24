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
    bool sign;
    bool parity;
}

int add(ref Machine machine, real[] params) {
    machine.registers.a = cast(int)(params[0] + params[1]);
    return 2;
}

int sub(ref Machine machine, real[] params) {
    machine.registers.a = cast(int)(params[0] - params[1]);
    return 2;
}

int mul(ref Machine machine, real[] params) {
    machine.registers.a = cast(int)(params[0] * params[1]);
    return 2;
}

int div(ref Machine machine, real[] params) {
    machine.registers.f = cast(float)(params[0] / params[1]);
    return 2;
}

int addf(ref Machine machine, real[] params) {
    machine.registers.f = cast(float)params[0] + cast(float)params[1];
    return 2;
}

int subf(ref Machine machine, real[] params) {
    machine.registers.f = cast(float)params[0] - cast(float)params[1];
    return 2;
}

int mulf(ref Machine machine, real[] params) {
    machine.registers.f = cast(float)params[0] * cast(float)params[1];
    return 2;
}

int and(ref Machine machine, real[] params) {
    machine.registers.a = cast(int)(params[0] & params[1]);
    return 2;
}

int not(ref Machine machine, real[] params) {
    machine.registers.a = cast(int)(~params[0]);
    return 1;
}

int or(ref Machine machine, real[] params) {
    machine.registers.a = cast(int)(params[0] | params[1]);
    return 2;
}

int xor(ref Machine machine, real[] params) {
    machine.registers.a = cast(int)(params[0] ^ params[1]);
    return 2;
}

int cp(ref Machine machine, real[] params) {
    handleRegisters(machine, params, 1);
    switch (params[1]) {
        default:
            break;
        case (real.max - 9):
           machine.registers.a=params[1];
            break;
        case (real.max - 8):
            machine.registers.b=params[1];
            break;
        case (real.max - 7):
            machine.registers.c=params[1];
            break;
        case (real.max - 6):
            machine.registers.d=*params[1];
            break;
       
        case (real.max - 4):
            machine.registers.f=params[1];
            break;
        case (real.max - 3):
           machine.registers.g=params[1];
            break;
        case (real.max - 2):
            machine.registers.h=params[1];
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

int function(ref Machine machine, real[] params)[26] commands;
void handleOpcode(ref Machine machine, real opcode, real[] params) {
    writeln("opcode:");
    writeln(opcode);
    machine.ip += commands[cast(ulong)opcode](machine, params) + 1;
}

void handleRegisters(ref Machine machine, ref real[] paramList, int count) {
    for (int i = 0; i < count; i++) {
        switch (paramList[i]) {
        default:
            break;
        case (real.max - 9):
            paramList[i] = machine.registers.a;
            break;
        case (real.max - 8):
            paramList[i] = machine.registers.b;
            break;
        case (real.max - 7):
            paramList[i] = machine.registers.c;
            break;
        case (real.max - 6):
            paramList[i] = cast(real)machine.registers.d;
            break;
        case (real.max - 5):
            // Handle string e (you might need to convert it to a real value)
            break;
        case (real.max - 4):
            paramList[i] = machine.registers.f;
            break;
        case (real.max - 3):
            paramList[i] = machine.registers.g;
            break;
        case (real.max - 2):
            paramList[i] = machine.registers.h;
            break;
        case (real.max - 1):
            paramList[i] = machine.registers.i;
            break;
        case real.max:
            paramList[i] = machine.registers.j;
            break;
        }
    }
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
