import data;
import registers;
import utils;
//addThread(double len,double[]* code)
int addThread(ref Machine machine,double[] p){
    double[] params=handleRegisters(machine,p,2);
    ulong len=cast(ulong)params[0];
    double[] code=machine.currThread.mem[cast(ulong)params[1]..cast(ulong)params[1]+len];
    Thread t=new Thread();
    t.mem=code.dup;
    t.mem.length+=64;
    machine.threads.addThread(t);
    return 2;
}
//switchThread()
int switchThread(ref Machine machine,double[] params){
    machine.threads.switchThread();
    return 0;
}
//getThreadID(register a)
int getThreadID(ref Machine m,double[] p){
    setRegister(m,p[0],m.currThread.id);
    return 1;
}
//removeThread(int id)
int removeThread(ref Machine m,double[] p){
    double[] params=handleRegisters(m,p,1);
    m.threads.removeThread(params[0]);
    return 1;
}

