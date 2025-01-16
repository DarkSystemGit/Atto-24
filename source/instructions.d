import std;
import registers;
import data;
import stdlib;
int add(ref Machine machine, double[] p) {
    double[] params=handleRegisters(machine, p, 2);
    machine.currThread.registers.a = cast(int)(params[0] + params[1]);
    
    return 2;
}

int sub(ref Machine machine, double[] p) {
    double[] params=handleRegisters(machine, p, 2);
    machine.currThread.registers.a = cast(int)(params[0] - params[1]);
    
    return 2;
}

int mul(ref Machine machine, double[] p) {
    double[] params=handleRegisters(machine, p, 2);
    machine.currThread.registers.a = cast(int)(params[0] * params[1]);
    
    return 2;
}

int div(ref Machine machine, double[] p) {
    double[] params=handleRegisters(machine, p, 2);
    machine.currThread.registers.f = cast(float)(params[0] / params[1]);
    
    return 2;
}
int mod(ref Machine machine, double[] p) {
     double[] params=handleRegisters(machine, p, 2);
    machine.currThread.registers.f = params[0] % params[1];
    
    return 2;
}
int addf(ref Machine machine, double[] p) {
    double[] params=handleRegisters(machine, p, 2);
    machine.currThread.registers.f = cast(float)params[0] + cast(float)params[1];
    
    return 2;
}

int subf(ref Machine machine, double[] p) {
    double[] params=handleRegisters(machine, p, 2);
    machine.currThread.registers.f = cast(float)params[0] - cast(float)params[1];
    
    return 2;
}

int mulf(ref Machine machine, double[] p) {
    double[] params=handleRegisters(machine, p, 2);
    machine.currThread.registers.f = cast(float)params[0] * cast(float)params[1];
    
    return 2;
}

int and(ref Machine machine, double[] p) {
    double[] params=handleRegisters(machine, p, 2);
    machine.currThread.registers.a = cast(int)(cast(int)params[0] & cast(int)params[1]);
    
    return 2;
}

int not(ref Machine machine, double[] p) {
    double[] params=handleRegisters(machine, p, 1);
    machine.currThread.registers.a = cast(int)(~cast(int)params[0]);
    
    return 1;
}

int or(ref Machine machine, double[] p) {
    double[] params=handleRegisters(machine, p, 2);
    machine.currThread.registers.a = cast(int)(cast(int)params[0] | cast(int)params[1]);
    
    return 2;
}

int xor(ref Machine machine, double[] p) {
    double[] params=handleRegisters(machine, p, 2);
    machine.currThread.registers.a = cast(int)(cast(int)params[0] ^ cast(int)params[1]);
    
    return 2;
}

int cp(ref Machine machine, double[] p) {

    double[] params=handleRegisters(machine, p, 1);
    if(isRegister(p[1]))setRegister(machine, p[1], params[0]);
    return 2;
}

int jmp(ref Machine machine, double[] p) {
    double[] params=handleRegisters(machine, p, 1);
    machine.currThread.ip = (cast(int)params[0]) - 2;
    return 1;
}
int jg(ref Machine machine, double[] p) {
    double[] params=handleRegisters(machine, p, 1);
    if (!machine.flags.negative) {
        machine.currThread.ip = (cast(int)params[0]) - 2;
    }
    return 1;
}
int jng(ref Machine machine, double[] p) {
    double[] params=handleRegisters(machine, p, 1);
    if (machine.flags.negative) {
        machine.currThread.ip = (cast(int)params[0]) - 2;
    }
    return 1;
}
int jz(ref Machine machine, double[] p) {
    double[] params=handleRegisters(machine, p, 1);
    if (machine.flags.zero) {
        machine.currThread.ip = (cast(int)params[0]) - 2;
    }
    return 1;
}

int jnz(ref Machine machine, double[] p) {
    double[] params=handleRegisters(machine, p, 1);
    if (!machine.flags.zero) {
        machine.currThread.ip = (cast(int)params[0])-2;
    }
    return 1;
}

int read(ref Machine machine, double[] p) {
    double[] params=handleRegisters(machine, p, 1);
    setRegister(machine,p[1],machine.currThread.mem[cast(ulong)params[0]]);
    return 2;
}

int write(ref Machine machine, double[] p) {
    double[] params=handleRegisters(machine, p, 2);
    /*if(params[1]>machine.currThread.mem.length) {
        machine.currThread.mem.length = cast(ulong)params[1];
    }*/
    machine.currThread.mem[cast(ulong)params[1]] = params[0];
    return 2;

}

int push(ref Machine machine, double[] p) {
    double[] params=handleRegisters(machine, p, 1);
    machine.stack.length++;
    machine.currThread.registers.sbp++;
    machine.stack.insertInPlace(cast(ulong)machine.currThread.registers.sbp-1, params[0]);
    return 1;
}

int pop(ref Machine machine, double[] params) {
    setRegister(machine,  params[0],machine.stack[cast(ulong)(machine.currThread.registers.sbp-1)]);
    machine.stack = machine.stack.remove(cast(ulong)(machine.currThread.registers.sbp-1));
    machine.currThread.registers.sbp--;
    machine.stack.length--;
    return 1;
}

int mov(ref Machine machine, double[] params) {
    double clear =  params[0];
        
    cp(machine, params);

    setRegister(machine, clear, 0);
    return 2;
}

int call(ref Machine machine, double[] p) {
    double[] params=handleRegisters(machine, p, 1);
    machine.raddr~=machine.currThread.ip+1;
    machine.currThread.ip = (cast(int)params[0]) - 2;
    return 1;
}

int ret(ref Machine machine, double[] p) {
    //writeln(machine.raddr);
    machine.currThread.ip = machine.raddr[machine.raddr.length-1];
    machine.raddr.length--;
    return 0;
}

int inc(ref Machine machine, double[] params) {
    double reg =  params[0];
    setRegister(machine, reg, getRegister(machine, reg) + 1);

    return 1;
}

int dec(ref Machine machine, double[] params) {
    double reg =  params[0];

    setRegister(machine, reg, getRegister(machine, reg) - 1);

    return 1;

}

int cmp(ref Machine machine, double[] p) {
    double[] params=handleRegisters(machine, p, 2);
    machine.flags.zero = false;
    machine.flags.negative = false;
    handleFlags(machine, params[0] - params[1]);
    //writeln(params[0]," ",params[1]," ",machine.flags);
    return 2;
}

int nop(ref Machine m, double[] p) {
    return 0;
}
int sys(ref Machine m, double[] p) {
    sysManager sys=new sysManager();
    double[] params=handleRegisters(m, p, 1);
    return sys.syscall(m,params[0],p[1..$]);  
   
}
int setErrAddr(ref Machine m, double[] p) {
    double[] params=handleRegisters(m, p, 1);
    m.errAddr=cast(int)params[0];
    return 1;
}
int exit(ref Machine m, double[] p) {
    m.running=false;
    if(m.objs.gfx !is null)m.objs.gfx.kill();
    m.objs.gfx=null;
    return 0;
}
int breakpoint(ref Machine m, double[] p) {
    m._debug=true;
    m.dprompt=true;
    return 0;
}
