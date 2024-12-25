import data;
import registers;
import utils;
import mem;
import std.math;
/*
struct Array{
    bool dynamic;
    union{
        arraybody static;
        dynamic dyn{
            int capacity;
            arraybody data;
        };
    }
}

struct arraybody{
    int length;
    real[] data;
}
*/
//newStaticArray(int length, reg addr)
int newStaticArray(ref Machine machine,real[] p){
    real[] params=handleRegisters(machine,p,1);
    real[] arrstruct;
    arrstruct=[0,params[0]];
    arrstruct.length+=cast(long)params[0];
    heapObj obj=machine.heap.getObj(cast(int)arrstruct.length);
    real objaddr=machine.heap.getDataPtr(obj);
    setRegister(machine,(cast(real)4294967296)-p[1],objaddr);
    utils.write(machine,objaddr,arrstruct);
    return 2;
}
//newDynamicArray(int length, reg addr)
int newDynamicArray(ref Machine machine,real[] p){
    real[] params=handleRegisters(machine,p,1);
    real[] arrstruct;
    real[] arr;
    real capacity=params[0];
    if(capacity<8)capacity=8;
    capacity=exp2(ceil(log2(capacity)));
    arr.length=cast(long)capacity+1;
    arr[0]=params[0];
    heapObj arrobj=machine.heap.getObj(cast(int)arr.length);
    real bodyptr=machine.heap.getDataPtr(arrobj);
    arrstruct=[true,capacity,bodyptr];
    real arrptr=machine.heap.getDataPtr(machine.heap.getObj(cast(int)arrstruct.length));
    utils.write(machine,bodyptr,arr);
    utils.write(machine,arrptr,arrstruct);
    setRegister(machine,(cast(real)4294967296)-p[1],arrptr);
    return 2;
}
//getArrayBody(array* arr,reg addr)
int getArrayBody(ref Machine machine,real[] p){
    real[] params=handleRegisters(machine,p,1);
    real bodyptr;
    if(machine.memory[cast(ulong)params[0]]==0){
        bodyptr=params[0]+1;
    }else{
        bodyptr=machine.memory[cast(ulong)(params[0]+2)];
    }
    setRegister(machine,(cast(real)4294967296)-p[1],bodyptr);
    return 2;
}