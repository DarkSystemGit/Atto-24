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
int getKeys(ref Machine machine,real[] params){
    //controller:
    // 1
    //2 4 5 6
    // 3
    //1:up, 2:left, 3:down, 4:right, 5:z, 6:x
    int[] sdlKeys=cast(int[])machine.objs.gfx.getPressedKeys();
     int[] keys=[cast(int)sdlKeys.length];
    foreach(int i,int key;sdlKeys){
        if(i<8){switch(key){
            case 82:
            //up
            keys~=1;
            break;
            case 81:
            //down
            keys~=3;
            break;
            case 80:
            //left
            keys~=2;
            break;
            case 79:
            //right
            keys~=4;
            break;
            case 29:
            //z
            keys~=5;
            break;
            case 27:
            //x
            keys~=6;
            break;
            default:
            break;
        }}
    };
    if(machine.objs.gfxInputAddr==0){
        machine.objs.inputs=machine.heap.getObj(8);
        machine.objs.gfxInputAddr=machine.heap.getDataPtr(machine.objs.inputs);
    }
    utils.write(machine,machine.heap.getDataPtr(machine.objs.inputs),keys);
     setRegister(machine,(cast(real)4294967296)-params[0],machine.heap.getDataPtr(machine.objs.inputs));
    return 1;
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
//Sprites
UserSprite toSprite(real[] data,ref Machine m){
    UserSprite sp;
    /*Struct Sprite{
        int x; 
        int y;
        float angle;
        ubyte* pixels;
        uint[] scaledDims;
    }*/
    sp.x=cast(int)data[0];
    sp.y=cast(int)data[1];
    sp.angle=cast(float)data[2];
    ubyte[] pixels=new ubyte[16*16];
    for(int i=0;i<16*16;i++){
        pixels[i]=cast(ubyte)m.memory[cast(int)data[3]+i];
    }
    sp.pixels=pixels;
    sp.scaledDims=[cast(uint)data[4],cast(uint)data[5]];
    return sp;
}
int[int] sprites;
//initSprite(reg addr,int x,int y,int angle,ubyte[64]* pixels)
int initSprite(ref Machine machine,real[] p){
    real[] params=handleRegisters(machine, p[1..4], 4);
    real[] sp=new real[6];
    sp[0]=params[1];
    sp[1]=params[2];
    sp[2]=params[3];
    sp[3]=params[4];
    sp[4]=16;
    sp[5]=16;
    heapObj obj=machine.heap.getObj(6);
    sprites[machine.heap.getDataPtr(obj)]=obj.id;
    utils.write(machine,machine.heap.getDataPtr(obj),sp);
    setRegister(machine,(cast(real)4294967296)-params[0],machine.heap.getDataPtr(obj));
    return 5;
}
int resizeSprite(ref Machine machine,real[] p){
    real[] params=handleRegisters(machine, p, 3);
    machine.memory[params[0]+4]=params[1];
    machine.memory[params[0]+5]=params[2];
    return 3;
}
int scaleSprite(ref Machine machine,real[] p){
    real[] params=handleRegisters(machine, p, 3);
    machine.memory[params[0]+4]=machine.memory[params[0]+4]*params[1];
    machine.memory[params[0]+5]=machine.memory[params[0]+4]*params[2];
    return 3;
}
int drawSprite(ref Machine machine,real[] p){
    real[] params=handleRegisters(machine, p, 1);
    UserSprite usp=toSprite(machine.memory[cast(int)params[0]...cast(int)params[0]+6],machine);
    Sprite sp;
    sp.angle=usp.angle;
    sp.pixels=usp.pixels;
    sp.scaledDims=usp.scaledDims;
    sp.move(usp.x,usp.y);
    
}
int freeSprite(ref Machine machine,real[] p){
    real[] params=handleRegisters(machine, p, 1);
    machine.heap.freeObj(sprites[cast(int)params[0]]);
    return 1;
}