import std;
import data;
import log;
void handleFlags(ref Machine machine, real res) {
    machine.flags.zero = false;
    machine.flags.negative = false;
    //writeln(res,res<0);
    if (res == 0)
        machine.flags.zero = true;
    if (res < 0)
        machine.flags.negative = true;

}
real[] handleRegisters(ref Machine machine, real[] paramRaw, int count) {
    int c = count;
    if (count == 0){
        c = cast(int)paramRaw.length - 1;
    }
    real[] paramList = new real[c+1];
    for (int i = 0; i < c; i++) {
        //writeln("[DEBUG] Handling register ",printRegister(paramList[i])," ",(4294967296 - paramList[i])<(10)," ",cast(real)4294967296 - paramList[i] );
        if(isRegister(paramRaw[i])){paramList[i]=getRegister(machine,paramRaw[i] );}else{paramList[i]=paramRaw[i];}
    }
    
    return paramList;
}
bool isRegister(real id) {
    return id.isNaN()&&(id.getNaNPayload()!=0);
}
real getRegister(ref Machine machine, real id) {
    real value;
    id=id.getNaNPayload();
    writeln("get: ",id);
    switch (cast(int)id) {
    default:
        value=0;
        break;
    case (11):
        value=machine.registers.sbp;
        break;
    case (10):
        value=machine.registers.sp;
        break;
    case (9):
        value=cast(real)machine.registers.a;
        break;
    case (8):
        value=cast(real)machine.registers.b;
        break;
    case (7):
        value=cast(real)machine.registers.c;
        break;
    case (6):
        value=cast(real)machine.registers.d;
        break;
    case (5):
        value=cast(real)machine.registers.e;
        break;
    case (4):
        value=cast(real)machine.registers.f;
        break;
    case (3):
        value=cast(real)machine.registers.g;
        break;
    case (2):
        value=cast(real)machine.registers.h;
        break;
    case (1):
        value=cast(real)machine.registers.i;
        break;
    case (12):
        value=cast(real)machine.registers.j;
        break;
    }
    if(machine._debug)writeln("[DEBUG] Getting register ",printRegister(id), ", value: ",value);
    return value;

}

void setRegister(ref Machine machine, real id, real value) {
    if(machine._debug)writeln("[DEBUG] Setting register ", printRegister(id)," to ", value);
    id=id.getNaNPayload();
     writeln("set: ",id);
    switch (cast(int)id) {
    default:
        break;
    case(11):
        machine.registers.sbp=cast(real)value;
        break;
    case(10):
        machine.registers.sp=cast(real)value;
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
    case (12):
        machine.registers.j = value;
        break;

    }
}
