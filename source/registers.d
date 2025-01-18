import std;
import data;
import log;
void handleFlags(ref Machine machine, double res) {
    machine.currThread.flags.zero = false;
    machine.currThread.flags.negative = false;
    //writeln(res,res<0);
    if (res == 0)
        machine.currThread.flags.zero = true;
    if (res < 0)
        machine.currThread.flags.negative = true;

}
double[] handleRegisters(ref Machine machine, double[] paramRaw, int count) {
    int c = count;
    if (count == 0){
        c = cast(int)paramRaw.length - 1;
    }
    double[] paramList = new double[c+1];
    for (int i = 0; i < c; i++) {
        //writeln("[DEBUG] Handling register ",printRegister(paramList[i])," ",(4294967296 - paramList[i])<(10)," ",cast(double)4294967296 - paramList[i] );
        if(isRegister(paramRaw[i])){paramList[i]=getRegister(machine,paramRaw[i] );}else{paramList[i]=paramRaw[i];}
    }
    
    return paramList;
}
bool isRegister(double id) {
    return id.isNaN()&&(id.getNaNPayload()!=0);
}
double getRegister(ref Machine machine, double id) {
    double value;
     if(machine._debug)std.stdio.write("[DEBUG] Getting register ",printRegister(id));
    id=id.getNaNPayload();
    //writeln("get: ",id);
    switch (cast(int)id) {
    default:
        value=0;
        break;
    case (11):
        value=machine.currThread.registers.sbp;
        break;
    case (10):
        value=machine.currThread.registers.sp;
        break;
    case (9):
        value=cast(double)machine.currThread.registers.a;
        break;
    case (8):
        value=cast(double)machine.currThread.registers.b;
        break;
    case (7):
        value=cast(double)machine.currThread.registers.c;
        break;
    case (6):
        value=cast(double)machine.currThread.registers.d;
        break;
    case (5):
        value=cast(double)machine.currThread.registers.e;
        break;
    case (4):
        value=cast(double)machine.currThread.registers.f;
        break;
    case (3):
        value=cast(double)machine.currThread.registers.g;
        break;
    case (2):
        value=cast(double)machine.currThread.registers.h;
        break;
    case (1):
        value=cast(double)machine.currThread.registers.i;
        break;
    case (12):
        value=cast(double)machine.currThread.registers.j;
        break;
    }
    if(machine._debug)writeln( ", value: ",value);
    return value;

}

void setRegister(ref Machine machine, double id, double value) {
    if(machine._debug)writeln("[DEBUG] Setting register ", printRegister(id)," to ", value);
    id=id.getNaNPayload();
    //writeln("set: ",id);
    switch (cast(int)id) {
    default:
        break;
    case(11):
        machine.currThread.registers.sbp=cast(double)value;
        break;
    case(10):
        machine.currThread.registers.sp=cast(double)value;
        break;
    case (9):
        machine.currThread.registers.a = cast(int)value;
        break;
    case (8):
        machine.currThread.registers.b = cast(int)value;
        break;
    case (7):
        machine.currThread.registers.c = cast(int)value;
        break;
    case (6):
        machine.currThread.registers.d = cast(int)value;
        break;
        case (5):
        machine.currThread.registers.e = cast(int)value;
        break;
    case (4):
        machine.currThread.registers.f = cast(float)value;
        break;
    case (3):
        machine.currThread.registers.g = cast(float)value;
        break;
    case (2):
        machine.currThread.registers.h = cast(double)value;
        break;
    case (1):
        machine.currThread.registers.i = value;
        break;
    case (12):
        machine.currThread.registers.j = value;
        break;

    }
}
