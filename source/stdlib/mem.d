import std;
struct heapObj{
    int size;
    int start;
    int end;
    bool free=true;
}
struct heap{
    int[][] sizes=new int[0][2];
    int ptr;
    heapObj[] objs=new heapObj[1];
    real[] memory;
    this(int ptr,real[] memory){
        this.ptr=ptr;
        this.memory=memory;
        heapObj startobj;
        startobj.size=0;
        startobj.start=0;
        startobj.end=1;
        startobj.free=false;
        objs~=startobj;
    }
    heapObj getObj(int size){
        heapObj obj;
        sizes.sort!((a,b)=>a[0]<b[0]);
    foreach(int[] i;sizes){
        if(i[0]>=size){
            if(objs[i[1]].free)obj=objs[i[1]];
        }
    }
    if(obj.free){
        addObj(size);
        return getObj(size);
    }else{
        return obj;
    }
    }
    int getDataPtr(heapObj obj){return obj.start+ptr;}
    void addObj(int size){
        heapObj obj;
        obj.size=size;
        obj.free=false;
        obj.start=objs[objs.length-1].end+1;
        obj.end=obj.start+size;
        objs~=obj;
        sizes~=[cast(int)size,cast(int)objs.length-1];
        memory.length=obj.end+1;
    }
    void free(int id){
        objs[id].free=true;
        for(int i=objs[id].start;i<objs[id].end;i++){memory[i]=0;}
    }
}