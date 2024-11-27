import std;
import registers;
import data;
import stdlib;
int add(ref Machine machine, real[] p) {
    real[] params=handleRegisters(machine, p, 2);
    machine.registers.a = cast(int)(params[0] + params[1]);
    
    return 2;
}

int sub(ref Machine machine, real[] p) {
    real[] params=handleRegisters(machine, p, 2);
    machine.registers.a = cast(int)(params[0] - params[1]);
    
    return 2;
}

int mul(ref Machine machine, real[] p) {
    real[] params=handleRegisters(machine, p, 2);
    machine.registers.a = cast(int)(params[0] * params[1]);
    
    return 2;
}

int div(ref Machine machine, real[] p) {
    real[] params=handleRegisters(machine, p, 2);
    machine.registers.f = cast(float)(params[0] / params[1]);
    
    return 2;
}
int mod(ref Machine machine, real[] p) {
     real[] params=handleRegisters(machine, p, 2);
    machine.registers.f = params[0] % params[1];
    
    return 2;
}
int addf(ref Machine machine, real[] p) {
    real[] params=handleRegisters(machine, p, 2);
    machine.registers.f = cast(float)params[0] + cast(float)params[1];
    
    return 2;
}

int subf(ref Machine machine, real[] p) {
    real[] params=handleRegisters(machine, p, 2);
    machine.registers.f = cast(float)params[0] - cast(float)params[1];
    
    return 2;
}

int mulf(ref Machine machine, real[] p) {
    real[] params=handleRegisters(machine, p, 2);
    machine.registers.f = cast(float)params[0] * cast(float)params[1];
    
    return 2;
}

int and(ref Machine machine, real[] p) {
    real[] params=handleRegisters(machine, p, 2);
    machine.registers.a = cast(int)(cast(int)params[0] & cast(int)params[1]);
    
    return 2;
}

int not(ref Machine machine, real[] p) {
    real[] params=handleRegisters(machine, p, 1);
    machine.registers.a = cast(int)(~cast(int)params[0]);
    
    return 1;
}

int or(ref Machine machine, real[] p) {
    real[] params=handleRegisters(machine, p, 2);
    machine.registers.a = cast(int)(cast(int)params[0] | cast(int)params[1]);
    
    return 2;
}

int xor(ref Machine machine, real[] p) {
    real[] params=handleRegisters(machine, p, 2);
    machine.registers.a = cast(int)(cast(int)params[0] ^ cast(int)params[1]);
    
    return 2;
}

int cp(ref Machine machine, real[] p) {

    real[] params=handleRegisters(machine, p, 1);
    if((cast(real)4294967296-params[1])<10)setRegister(machine, (cast(real)4294967296-params[1]), params[0]);
    return 2;
}

int jmp(ref Machine machine, real[] p) {
    real[] params=handleRegisters(machine, p, 1);
    machine.ip = (cast(int)params[0]) - 2;
    return 1;
}

int jz(ref Machine machine, real[] p) {
    real[] params=handleRegisters(machine, p, 1);
    if (machine.flags.zero) {
        machine.ip = (cast(int)params[0]) - 2;
    }
    return 1;
}

int jnz(ref Machine machine, real[] p) {
    real[] params=handleRegisters(machine, p, 1);
    if (!machine.flags.zero) {
        machine.ip = (cast(int)params[0])-2;
    }
    return 1;
}

int read(ref Machine machine, real[] p) {
    real[] params=handleRegisters(machine, p, 1);
    setRegister(machine, (cast(real)4294967296) - params[1],
            machine.memory[cast(ulong)params[0]]);
    return 2;
}

int write(ref Machine machine, real[] p) {
    real[] params=handleRegisters(machine, p, 2);
    /*if(params[1]>machine.memory.length) {
        machine.memory.length = cast(ulong)params[1];
        machine.memory_size=cast(int)machine.memory.length;
    }*/
    machine.memory[cast(ulong)params[1]] = params[0];
    return 2;

}

int push(ref Machine machine, real[] p) {
    real[] params=handleRegisters(machine, p, 1);
    machine.stack.length = machine.stack.length + 1;
    machine.stack[machine.stack.length - 1] = params[0];
    return 1;
}

int pop(ref Machine machine, real[] params) {

    if (machine.stack.length != machine.bp) {
        setRegister(machine, (cast(real)4294967296) - params[0],machine.stack[machine.stack.length - 1]);
        machine.stack = machine.stack.remove(machine.stack.length - 1);
    } else {
        setRegister(machine, (cast(real)4294967296) - params[0], 0);
    }
    return 1;
}

int mov(ref Machine machine, real[] params) {
    real clear = (cast(real)4294967296) - params[0];
        
    cp(machine, params);

    setRegister(machine, clear, 0);
    return 2;
}

int call(ref Machine machine, real[] p) {
    real[] params=handleRegisters(machine, p, 1);
    machine.raddr~=machine.ip+1;
    machine.ip = (cast(int)params[0]) - 2;
    return 1;
}

int ret(ref Machine machine, real[] p) {
    real[] params=handleRegisters(machine, p, 1);
    for (int j = cast(int)params.length; j < params[0]; j++) {
        machine.stack = machine.stack.remove(machine.stack.length - 1);
    }
    machine.ip = machine.raddr[machine.raddr.length-1]-1;
    return 1;
}

int inc(ref Machine machine, real[] params) {
    real reg = cast(real)4294967296 - params[0];
    setRegister(machine, reg, getRegister(machine, reg) + 1);

    return 1;
}

int dec(ref Machine machine, real[] params) {
    real reg = cast(real)4294967296 - params[0];

    setRegister(machine, reg, getRegister(machine, reg) - 1);

    return 1;

}

int cmp(ref Machine machine, real[] p) {
    real[] params=handleRegisters(machine, p, 2);
    machine.flags.zero = false;
    machine.flags.negative = false;
    handleFlags(machine, cast(int)(params[0] - params[1]));
    return 2;
}

int nop(ref Machine m, real[] p) {
    return 0;
}
int sys(ref Machine m, real[] p) {
    sysManager sys=new sysManager();
    real[] params=handleRegisters(m, p, 1);
    return sys.syscall(m,params[0],params[1..$]);  
   
}
int setErrAddr(ref Machine m, real[] p) {
    real[] params=handleRegisters(m, p, 1);
    m.errAddr=cast(int)params[0];
    return 1;
}
int exit(ref Machine m, real[] p) {
    m.running=false;
    if(m.objs.gfx !is null)m.objs.gfx.kill();
    return 0;
}