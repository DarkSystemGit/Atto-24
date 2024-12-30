import data;
import registers;
import utils;
import mem;
import std.math;
import std.stdio;
import std.array;
import std.algorithm;
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
    machine.objs.arrayObjs~=arrayObj(obj.id,objaddr);
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
    machine.objs.arrayObjs~=arrayObj(arrobj.id,machine.heap.getDataPtr(arrobj));
    real bodyptr=machine.heap.getDataPtr(arrobj);
    arrstruct=[true,capacity,bodyptr];
    heapObj structObj=machine.heap.getObj(cast(int)arrstruct.length);
    real arrptr=machine.heap.getDataPtr(structObj);
    machine.objs.arrayObjs~=arrayObj(structObj.id,arrptr);
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
    if((newlength>=*arr.capacity)&&arr.dynamic){
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
    }else if(!arr.dynamic)throw new Exception("Cannot grow static array");
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
    real[] newbody=arr.body.replaceSlice(arr.body[cast(ulong)start..$],arr.body[cast(ulong)end..$]);
    real newlength=newbody.length;
    newbody.length=arr.body.length;
    arr.body[0..$]=newbody;
    *arr.length-=end-start;
    //*arr.length=newlength;
    return 4;
}
//arrayInsert(array* arr,int pos, array* data)
int arrayInsert(ref Machine machine,real[] p){
    real[] params=handleRegisters(machine,p,3);
    UserArray arr=getArray(machine,params[0]);
    UserArray data=getArray(machine,params[2]);
    growArray(machine,arr,*data.length+*arr.length);
    *arr.length=*data.length+*arr.length;
    real[] newbody=arr.body.replaceSlice(arr.body[cast(ulong)params[1]..$],data.body~arr.body[cast(ulong)params[1]..cast(ulong)*arr.length]);
    newbody.length=arr.body.length;
    arr.body[0..$]=newbody;
    return 3;
}
//printArray(array* arr)
int printArray(ref Machine machine,real[] p){
    real[] params=handleRegisters(machine,p,1);
    UserArray arr=getArray(machine,params[0]);
    writeln(arr.body[0..cast(ulong)(*arr.length)]);
    return 1;
}
//arrayGet(array* arr,int i,reg res)
int arrayGet(ref Machine machine,real[] p){
    real[] params=handleRegisters(machine,p,2);
    UserArray arr=getArray(machine,params[0]);
    setRegister(machine,p[2],arr.body[cast(ulong)params[1]]);
    return 3;
}
//arraySet(array* arr,int i,int val)
int arraySet(ref Machine machine,real[] p){
    real[] params=handleRegisters(machine,p,3);
    UserArray arr=getArray(machine,params[0]);
    arr.body[cast(ulong)params[1]]=params[2];
    return 3;
}
//arrayConcat(array* orig, array* joined)
int arrayConcat(ref Machine machine,real[] p){
    real[] params=handleRegisters(machine,p,2);
    UserArray arr=getArray(machine,params[0]);
    UserArray arr2=getArray(machine,params[1]);
    growArray(machine,arr,*arr.length+*arr2.length);
    real[] newbody=arr.body[0..cast(ulong)*arr.length]~arr2.body;
    *arr.length+=*arr2.length;
    newbody.length=arr.body.length;
    arr.body[0..$]=newbody;
    return 2;
}
//arrayFreeDynamic(array* arr)
int arrayFreeDynamic(ref Machine machine,real[] p){
    real[] params=handleRegisters(machine,p,1); 
    real bodyaddr=machine.memory[cast(ulong)(params[0]+2)];
    arrayObj[] newObjList;
    foreach(int i,arrayObj obj;machine.objs.arrayObjs){
        if([params[0],bodyaddr].canFind(obj.addr)){
            machine.heap.free(obj.id);
        }else{
            newObjList~=obj;
        }
    }
    machine.objs.arrayObjs=newObjList;
    return 1;
}
//arrayFreeStatic(array* arr)
int arrayFreeStatic(ref Machine machine,real[] p){
    real[] params=handleRegisters(machine,p,1); 
    arrayObj[] newObjList;
    foreach(int i,arrayObj obj;machine.objs.arrayObjs){
        if(params[0]==obj.addr){
            machine.heap.free(obj.id);
        }else{
            newObjList~=obj;
        }
    }
    machine.objs.arrayObjs=newObjList;
    return 1;
}