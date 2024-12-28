import data;
import registers;
import utils;
import mem;
import std.math;
import std.stdio;
import std.array;
/*
struct Array{
    bool dynamic;
    int capacity;
    union{
        arraybody* dyn;
        arraybody static;
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
    arrstruct=[false,params[0],0];
    arrstruct.length+=cast(long)params[0];
    heapObj obj=machine.heap.getObj(cast(int)arrstruct.length);
    real objaddr=machine.heap.getDataPtr(obj);
    setRegister(machine,p[1],objaddr);
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
    capacity=exp2(ceil(log2(capacity+1)));
    arr.length=cast(long)capacity;
    arr[0]=0;
    heapObj arrobj=machine.heap.getObj(cast(int)arr.length);
    real bodyptr=machine.heap.getDataPtr(arrobj);
    arrstruct=[true,capacity,bodyptr];
    real arrptr=machine.heap.getDataPtr(machine.heap.getObj(cast(int)arrstruct.length));
    utils.write(machine,bodyptr,arr);
    utils.write(machine,arrptr,arrstruct);
    setRegister(machine,p[1],arrptr);
    return 2;
}
//getArrayBody(array* arr,reg addr)
int getArrayBody(ref Machine machine,real[] p){
    real[] params=handleRegisters(machine,p,1);
    real bodyptr;
    if(machine.memory[cast(ulong)params[0]]==0){
        bodyptr=params[0]+2;
    }else{
        bodyptr=machine.memory[cast(ulong)(params[0]+2)];
    }
    setRegister(machine,p[1],bodyptr);
    return 2;
}
//getArrayCapcity(array* arr,reg addr)
int getArrayCapacity(ref Machine machine,real[] p){
    real[] params=handleRegisters(machine,p,1);
    real length;
    if(machine.memory[cast(ulong)params[0]]==0){
        length=machine.memory[cast(ulong)params[0]+1];
    }else{
        length=cast(ulong)machine.memory[cast(ulong)(params[0]+1)];
    }
    setRegister(machine,p[1],length);
    return 2;
}
//getArrayLength(array* arr,reg addr)
int getArrayLength(ref Machine machine,real[] p){
    real[] params=handleRegisters(machine,p,1);
    real length;
    if(machine.memory[cast(ulong)params[0]]==0){
        length=machine.memory[cast(ulong)params[0]+2];
    }else{
        length=machine.memory[cast(ulong)machine.memory[cast(ulong)(params[0]+2)]];
    }
    setRegister(machine,p[1],length);
    return 2;
}
//getArrayData(array* arr,reg addr)
int getArrayData(ref Machine machine,real[] p){
    real[] params=handleRegisters(machine,p,1);
    real bodyptr;
    if(machine.memory[cast(ulong)params[0]]==0){
        bodyptr=params[0]+3;
    }else{
        bodyptr=machine.memory[cast(ulong)(params[0]+2)]+1;
    }
    setRegister(machine,p[1],bodyptr);
    return 2;
}
UserArray getArray(ref Machine machine,real addr){
    UserArray arr;
    arr.capacity=&machine.memory[cast(ulong)addr+1];
    if(machine.memory[cast(ulong)addr]==0){
        arr.ptr=&machine.memory[cast(ulong)addr+2];
        arr.body=machine.memory[cast(ulong)(addr+3)..cast(ulong)(addr+3+*arr.capacity)];
        arr.length=&(machine.memory[cast(ulong)addr+2]);
    }else{
        arr.dynamic=true;
        arr.ptr=&machine.memory[cast(ulong)(addr+2)];
        arr.body=machine.memory[cast(ulong)(*arr.ptr+1)..cast(ulong)(*arr.ptr+1+*arr.capacity)];
        arr.length=&(machine.memory[cast(ulong)*arr.ptr]);
    }
    return arr;
}

void growArray(ref Machine machine,ref UserArray arr,real newlength){
    if(newlength>=*arr.capacity){
        //writeln(arr,[*arr.length,*arr.capacity,*arr.ptr],arr.body);
        real oldlength=*arr.length;
        int newCapacity=cast(int)exp2(ceil(log2(newlength+*arr.capacity)));
        heapObj currObj;
        heapObj newObj=machine.heap.getObj(newCapacity);
        utils.write(machine,newObj.start,machine.memory[cast(ulong)(*arr.ptr)..cast(ulong)(*arr.ptr+1+*arr.capacity)]);
        foreach(heapObj obj;machine.heap.objs){
            if(obj.start==*arr.ptr){currObj=obj;break;}
        }
        machine.heap.free(currObj.id);
        *arr.capacity=cast(real)newCapacity;
        *arr.ptr=cast(real)newObj.start;
        arr.body=machine.memory[cast(ulong)(*arr.ptr)..cast(ulong)(*arr.ptr+*arr.capacity)];
        *arr.length=oldlength;
        //writeln([*arr.length,*arr.capacity,*arr.ptr],arr.body);
    }
}
//arrayPush(array* arr,real data)
int arrayPush(ref Machine machine,real[] p){
    real[] params=handleRegisters(machine,p,2);
    UserArray arr=getArray(machine,params[0]);

    if(arr.dynamic){growArray(machine,arr,*arr.length+1);}else if(*arr.length+1>*arr.capacity){throw new Exception("Exceeded array capcity");};
    (*arr.length)++;
    arr.body[cast(ulong)(*arr.length-1)]=params[1];
    return 2;
}
//arrayPop(array* arr,int pos, reg register)
int arrayPop(ref Machine machine,real[] p){
    real[] params=handleRegisters(machine,p,2);
    UserArray arr=getArray(machine,params[0]);
    setRegister(machine,p[2],arr.body[cast(ulong)(params[1])]);
    real[] newbody=(arr.body).replaceSlice(arr.body[cast(ulong)params[1]..$],arr.body[cast(ulong)params[1]+1..$]);
    (*arr.length)--;
    newbody.length=arr.body.length;
    arr.body[0..$]=newbody;
    return 3;
}
//arraySlice(array* arr,int start, int end, reg addr)
int arraySlice(ref Machine machine,real[] p){
    real[] params=handleRegisters(machine,p,3);
    real start=params[1];
    real end=params[2];
    UserArray arr=getArray(machine,params[0]);
    real[] newarrstruct=[false,end-start,end-start]~arr.body[cast(ulong)start..cast(ulong)end];
    heapObj obj=machine.heap.getObj(cast(int)newarrstruct.length);
    real objaddr=machine.heap.getDataPtr(obj);
    utils.write(machine,objaddr,newarrstruct);
    setRegister(machine,p[3],objaddr);
    return 4;
}
//arraySplice(array* arr,int start, int end, reg addr)
int arraySplice(ref Machine machine,real[] p){
    real[] params=handleRegisters(machine,p,3);
    real start=params[1];
    real end=params[2];
    UserArray arr=getArray(machine,params[0]);
    real[] newarrstruct=[false,end-start,end-start]~arr.body[cast(ulong)start..cast(ulong)end];
    heapObj obj=machine.heap.getObj(cast(int)newarrstruct.length);
    real objaddr=machine.heap.getDataPtr(obj);
    utils.write(machine,objaddr,newarrstruct);
    setRegister(machine,p[3],objaddr);
    real[] newbody=arr.body.replaceSlice(arr.body[cast(ulong)start..cast(ulong)end],arr.body[cast(ulong)end..$]);
    newbody.length=arr.body.length;
    arr.body[0..$]=newbody;
    return 4;
}
//arrayInsert(array* arr,int pos, array* data)
int arrayInsert(ref Machine machine,real[] p){
    real[] params=handleRegisters(machine,p,3);
    UserArray arr=getArray(machine,params[0]);
    UserArray data=getArray(machine,params[2]);
    real[] newbody=arr.body.dup;
    newbody.insertInPlace(cast(int)params[1],data.body[1..$]);
    
    arr.body[0..$]=newbody;
    return 3;
}
