import std;
import data;
import registers;
import utils;
struct heapObj{
    int size;
    int start;
    int end;
    bool free=true;
    int id;
    void print(){
        writefln("  size: %d",size);
        writefln("  start: %d",start);
        writefln("  end: %d",end);
        writefln("  free: %d",free);
        writefln("  id: %d",id);
    }
}
class machineHeap{
    int[][] sizes=new int[0][2];
    int ptr;
    heapObj[] objs=new heapObj[1];
    real[] memory;
    this(int ptr,real[] memory){
        this.ptr=ptr;
        this.memory=memory;
        heapObj startobj;
        int[] objSize=[0,0];
        startobj.size=0;
        startobj.start=0;
        startobj.end=1;
        startobj.free=false;
        startobj.id=0;
        objs[0]=startobj;
        sizes.length=1;
        sizes[0]=objSize;
    }
    heapObj getObj(int size){
        heapObj obj;
        bool f;
        sizes.sort!((a,b)=>a[0]<b[0]);
    foreach(int[] i;sizes){
        
        if(i[0]>size-1){
            if(objs[i[1]].free){
                f=true;
                obj=objs[i[1]];break;
                
                }
        }
    }
    if(!f){
        addObj(size);
        return getObj(size);
    }else{
        obj.free=false;
        return obj;
    }
    }
    int getDataPtr(heapObj obj){return obj.start+ptr;}
    void addObj(int size){
        heapObj obj;
        obj.size=size;
        obj.free=true;
        obj.start=objs[objs.length-1].end+1;
        obj.end=obj.start+size;
        obj.id=cast(int)objs.length;
        objs~=obj;
        sizes~=[cast(int)size,cast(int)objs.length-1];
        memory.length=obj.end+1;
    }
    void free(int id){
        objs[id].free=true;
        for(int i=objs[id].start;i<objs[id].end;i++){memory[i]=0;}
    }
}
//syscall 23;memdump()
int memdump(ref Machine machine,real[] p) {
    machine.print();
    return 0;
}
//syscall 24; malloc(int size,register addr,register id)
int malloc(ref Machine machine,real[] p){
    real[] params=handleRegisters(machine, p, 1);
    heapObj obj=machine.heap.getObj(cast(int)params[0]);
    setRegister(machine,(cast(real)4294967296)-params[1],machine.heap.getDataPtr(obj));
    setRegister(machine,(cast(real)4294967296)-params[2],obj.id);
    return 3;
}
//syscall 25; free(int id)
int free(ref Machine machine,real[] p){
    real[] params=handleRegisters(machine, p, 1);
    machine.heap.free(cast(int)params[0]);
    return 1;
}    
//syscall 26; memcpy(int src,int dest,int size)
int memcopy(ref Machine machine,real[] p){
    real[] params=handleRegisters(machine, p, 3);
    int src=cast(int)params[0];
    int dest=cast(int)params[1];
    int size=cast(int)params[2];
    for(int i=0;i<size;i++){
        machine.memory[dest+i]=machine.memory[src+i];
    }
    return 3;
}
//syscall 27; memfill(int addr,int len,int value)
int memfill(ref Machine machine,real[] p){
    real[] params=handleRegisters(machine, p, 3);
    int addr=cast(int)params[0];
    int len=cast(int)params[1]; 
    int value=cast(int)params[2];
    for(int i=0;i<len;i++){
        machine.memory[addr+i]=value;
    }
    return 3;
}
//syscall 28; cast(value,type)
int cast(ref Machine machine,real[] p){
    real[] params=handleRegisters(machine, p, 2);
    real value=params[0];
    int type=cast(int)params[1];
    switch(type){
        case 0:
        machine.registers.a=cast(int)cast(bool)value;
        break;
        case 1:
        machine.registers.a=cast(int)cast(char)value;
        break;
        case 2:
        machine.registers.a=cast(int)cast(short)value;  
        break;
        case 3:
        machine.registers.a=cast(int)value;
        break;
        case 4:
        machine.registers.a=cast(int)cast(long)value;
        break;
        case 5:
        machine.registers.f=cast(float)value;
        break;
        case 6:
        machine.registers.d=cast(double)value;
        break;
        case 7:
        machine.registers.a=cast(int)cast(byte)value;
        break;
    }
    return 2;
}