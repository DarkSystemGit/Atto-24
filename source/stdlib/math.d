import std.math;
import std.stdio;
import data;
import registers;
import utils;
import mem;
//abs(int val,reg r)
int mabs(ref Machine machine,double[] p){
    double[] params=handleRegisters(machine,p,1);
    setRegister(machine,p[1],fabs(params[0]));
    return 2;
}
//sqrt(int val,reg r)
int msqrt(ref Machine machine,double[] p){
    double[] params=handleRegisters(machine,p,1);
    setRegister(machine,p[1],sqrt(params[0]));
    return 2;
}
//cbrt(int val,reg r)
int mcbrt(ref Machine machine,double[] p){
    double[] params=handleRegisters(machine,p,1);
    setRegister(machine,p[1],cbrt(params[0]));
    return 2;
}
//hypot(int val,reg r)
int mhypot(ref Machine machine,double[] p){
    double[] params=handleRegisters(machine,p,2);
    setRegister(machine,p[2],hypot(params[0],params[1]));
    return 3;
}
//sin(int val,reg r)
int msin(ref Machine machine,double[] p){
    double[] params=handleRegisters(machine,p,1);
    setRegister(machine,p[1],sin(params[0]));
    return 2;
}
//cos(int val,reg r)
int mcos(ref Machine machine,double[] p){
    double[] params=handleRegisters(machine,p,1);
    setRegister(machine,p[1],cos(params[0]));
    return 2;
}
//tan(int val,reg r)
int mtan(ref Machine machine,double[] p){
    double[] params=handleRegisters(machine,p,1);
    setRegister(machine,p[1],tan(params[0]));
    return 2;
}
//asin(int val,reg r)
int masin(ref Machine machine,double[] p){
    double[] params=handleRegisters(machine,p,1);
    setRegister(machine,p[1],asin(params[0]));
    return 2;
}
//acos(int val,reg r)
int macos(ref Machine machine,double[] p){
    double[] params=handleRegisters(machine,p,1);
    setRegister(machine,p[1],acos(params[0]));
    return 2;
}
//atan(int val,reg r)
int matan(ref Machine machine,double[] p){
    double[] params=handleRegisters(machine,p,1);
    setRegister(machine,p[1],atan(params[0]));
    return 2;
}
//ceil(int val,reg r)
int mceil(ref Machine machine,double[] p){
    double[] params=handleRegisters(machine,p,1);
    setRegister(machine,p[1],ceil(params[0]));
    return 2;
}
//floor(int val,reg r)
int mfloor(ref Machine machine,double[] p){
    double[] params=handleRegisters(machine,p,1);
    setRegister(machine,p[1],floor(params[0]));
    return 2;
}
//round(int val,reg r)
int mround(ref Machine machine,double[] p){
    double[] params=handleRegisters(machine,p,1);
    setRegister(machine,p[1],round(params[0]));
    return 2;
}
//int(int val,reg r)
int mint(ref Machine machine,double[] p){
    double[] params=handleRegisters(machine,p,1);
    setRegister(machine,p[1],int(cast(int)params[0]));
    return 2;
}
//pow(int val,int exp,reg r)
int mpow(ref Machine machine,double[] p){
    double[] params=handleRegisters(machine,p,2);
    setRegister(machine,p[2],pow(params[0],params[1]));
    return 3;
}
//log(int val,reg r)
int mlog(ref Machine machine,double[] p){
    double[] params=handleRegisters(machine,p,1);
    setRegister(machine,p[1],log(params[0]));
    return 2;
}
//isFinite(int val,reg r)
int mfinite(ref Machine machine,double[] p){
    double[] params=handleRegisters(machine,p,1);
    if(params[0]<4294967296){setRegister(machine,p[1],isFinite(params[0]));}else{setRegister(machine,p[1],0);}
    return 2;
}