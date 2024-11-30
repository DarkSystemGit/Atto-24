import dgfx;
import std;
import data;
import utils;
import mem;
import registers;
int initGFX(ref Machine machine,real[] p){
    real[] params=handleRegisters(machine, p, 2);
    string title=readString(machine,cast(int)params[0]).to!string;
    machine.objs.gfx=new GFX(title,[320,240]);
    machine.objs.vramAddr=cast(int)params[1];
    return 2;
}
int getVRAMBuffer(ref Machine machine,real[] params){
    heapObj obj=machine.heap.getObj(240*320);
    machine.objs.vramAddr=machine.heap.getDataPtr(obj);
    setRegister(machine,(cast(real)4294967296)-params[0],machine.heap.getDataPtr(obj));
    setRegister(machine,(cast(real)4294967296)-params[1],obj.id);
    return 2;
}
int freeGFX(ref Machine machine,real[] params){
    machine.objs.gfx.kill();
    machine.objs.vramAddr=0;
    return 0;
}
int renderGFX(ref Machine machine,real[] params){
    //writeln(machine.objs.vramAddr,machine.memory[machine.objs.vramAddr]);
    //writeln("RENDERED");
    for(int i=0;i<(320*240);i++){
        
        machine.objs.gfx.pixels[i]=cast(ubyte)(machine.memory[machine.objs.vramAddr+i]);
    }
    machine.objs.gfx.render();
    if((machine.objs.gfx.events.length>0)&&(machine.objs.gfx.events[machine.objs.gfx.events.length-1]=="QuitEvent")){
            machine.objs.gfx.kill();
            machine.objs.gfx=null;
    }
        //writeln(machine.objs.gfx.pixels);
    return 0;
}
int pollEvents(ref Machine m,real[] p){
    real addrregister=(cast(real)4294967296)-p[0];
    real idregister=(cast(real)4294967296)-p[1];
    int[] eventBytes=[];
    foreach(string ev;m.objs.gfx.events){
        ev~=cast(char)0;
        foreach(char c;ev){
            eventBytes~=cast(int)c;
        }
    }
    eventBytes=[cast(int)m.objs.gfx.events.length]~eventBytes;
    heapObj obj=m.heap.getObj(cast(int)eventBytes.length);
    setRegister(m,addrregister,m.heap.getDataPtr(obj));
    setRegister(m,idregister,obj.id);
    utils.write(m,m.heap.getDataPtr(obj),eventBytes);
    return 2;
}
int windowClosed(ref Machine m,real[] p){
    real register=(cast(real)4294967296)-p[0];
    setRegister(m,register,0);
    if(m.objs.gfx is null)setRegister(m,register,1);
    return 1;
}
int setPalette(ref Machine machine,real[] p){
    real[] params=handleRegisters(machine, p, 1);
    uint[] colors=new uint[256];
    for(int i=0;i<256;i++){
        colors[i]=cast(uint)machine.memory[cast(int)params[0]+i];
    }
    machine.objs.gfx.palette=colors;
    return 1;
}