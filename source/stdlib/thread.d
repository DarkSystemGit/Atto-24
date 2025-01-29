import data;
import registers;
import utils;
import mem;
import std;

//addThread(double len,double[]* code)
int addThread(ref Machine machine, double[] p)
{
    if (!isTzero(machine))
        return 2;
    double[] params = handleRegisters(machine, p, 2);
    ulong len = cast(ulong) params[0];
    double[] code = machine.currThread.mem[cast(ulong) params[1] .. cast(ulong) params[1] + len];
    Thread t = new Thread();
    t.mem = code.dup;
    t.mem.length += 64;
    t.heap = new Heap(t);
    machine.threads.addThread(t);
    return 2;
}
//switchThread()
int switchThread(ref Machine machine, double[] params)
{
    machine.threads.switchThread();
    return 0;
}
//getThreadID(register a)
int getThreadID(ref Machine m, double[] p)
{
    setRegister(m, p[0], m.currThread.id);
    return 1;
}
//removeThread(int id)
int removeThread(ref Machine m, double[] p)
{
    if (!isTzero(m))
        return 1;
    double[] params = handleRegisters(m, p, 1);
    m.threads.removeThread(cast(int) params[0]);
    return 1;
}

int dumpThreads(ref Machine machine, double[] p)
{
    if (!isTzero(machine))
        return 0;
    machine.threads.print();
    return 0;
}

bool isTzero(ref Machine m)
{
    return m.currThread.id == 0;
}

int getThreadInfo(ref Machine m, double[] p)
{
    int id = cast(int)(handleRegisters(m, p, 1)[0]);
    Thread t = m.threads.getThread(id);
    double[] flags = [t.flags.zero, t.flags.negative];
    double[] reg = [
        t.registers.a, t.registers.b, t.registers.c, t.registers.d, t.registers.e,
        t.registers.f, t.registers.g, t.registers.h, t.registers.i, t.registers.j
    ];
    double[] tstruct = [t.id, t.ip, t.registers.sbp] ~ reg ~ flags ~ [
        cast(double) t.errAddr
    ];
    heapObj obj = m.currThread.heap.getObj(cast(int) tstruct.length);
    utils.write(m, m.currThread.heap.getDataPtr(obj), tstruct);
    setRegister(m, p[1], m.currThread.heap.getDataPtr(obj));
    return 2;
}

int updateThread(ref Machine m, double[] p)
{
    double[] params = handleRegisters(m, p, 2);
    int id = cast(int) params[0];
    double[] data = m.currThread.mem[cast(ulong) params[1] .. cast(ulong)(params[1] + 16)];
    Thread t = m.threads.getThread(id);
    t.id = cast(int) data[0];
    t.ip = cast(int) data[1];
    t.registers.sbp = cast(int) data[2];
    t.registers.a = cast(int) data[3];
    t.registers.b = cast(int) data[4];
    t.registers.c = cast(int) data[5];
    t.registers.d = cast(int) data[6];
    t.registers.e = cast(int) data[7];
    t.registers.f = cast(float) data[8];
    t.registers.g = cast(float) data[9];
    t.registers.h = data[10];
    t.registers.i = data[11];
    t.registers.j = data[12];
    t.flags.zero = cast(bool) data[13];
    t.flags.negative = cast(bool) data[14];
    t.errAddr = cast(int) data[15];
    return 2;
}

int switchThreadId(ref Machine m, double[] p)
{
    double[] params = handleRegisters(m, p, 1);
    m.threads.switchThread(cast(int) params[0]);
    return 1;
}

int setInterrupt(ref Machine m, double[] p)
{
    double[] params = handleRegisters(m, p, 2);
    m.intHandler.handlers[cast(int) params[0]] = cast(int) params[1];
    return 2;
}
