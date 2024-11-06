import std;
import data;
import log;
void handleFlags(ref Machine machine, real res) {
    machine.flags.zero = false;
    machine.flags.negative = false;
    if (res == 0)
        machine.flags.zero = true;
    if (res < 0)
        machine.flags.negative = true;

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
                
                    paramList[i] = getRegister(machine, j);
        }
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
    case (5):
        return cast(real)machine.registers.e;
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
        case (5):
        machine.registers.e = cast(int)value;
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
