import std;
import data;
import registers;
import utils;

struct heapObj
{
    int size;
    int start;
    int end;
    bool free = true;
    int id;
    void print()
    {
        writefln("  size: %d", size);
        writefln("  start: %d", start);
        writefln("  end: %d", end);
        writefln("  free: %d", free);
        writefln("  id: %d", id);
    }
}

class Heap
{
    int[][] sizes = new int[1][2];
    int ptr;
    heapObj[] hobjs = new heapObj[1];
    Thread curr;
    this(Thread t)
    {
        this.ptr = cast(int) t.mem.length;
        this.curr = t;
        heapObj startobj;
        int[] objSize = [0, 0];
        startobj.size = 0;
        startobj.start = ptr;
        startobj.end = ptr + 1;
        startobj.free = false;
        startobj.id = 0;
        this.hobjs[0] = startobj;
        this.sizes.length = 1;
        this.sizes[0] = objSize;
    }

    heapObj getObj(int size)
    {
        //writeln(size);
        heapObj obj;
        bool f;
        sizes.sort!((a, b) => a[0] < b[0]);
        foreach (int[] i; sizes)
        {

            if (i[0] > size - 1)
            {
                //hobjs[i[1]].print();
                if (hobjs[i[1]].free)
                {
                    f = true;
                    obj = hobjs[i[1]];
                    break;

                }
            }
        }
        if (!f)
        {
            addObj(size);
            return getObj(size);
        }
        else
        {
            this.hobjs[obj.id].free = false;
            //if(true){writeln("[DEBUG] heap getObj;");obj.print();}
            return this.hobjs[obj.id];
        }
    }

    int getDataPtr(heapObj obj)
    {
        return obj.start;
    }

    void addObj(int size)
    {
        size = cast(int) ceil((cast(float) size) / 8) * 8;
        //writeln(size);
        heapObj obj;
        obj.size = size;
        obj.free = true;
        obj.start = hobjs[hobjs.length - 1].end + 1;
        obj.end = obj.start + size;
        obj.id = cast(int) hobjs.length;
        for (int i = obj.start; i < obj.end; i++)
        {
            if (curr.mem.length <= i)
            {
                curr.mem.length = i + 1;
            }
            curr.mem[i] = 0;
        }
        hobjs ~= obj;
        sizes ~= [cast(int) size, cast(int) hobjs.length - 1];
        curr.mem.length = ptr + obj.end + 1;
    }

    void free(int id)
    {
        hobjs[id].free = true;
        for (int i = hobjs[id].start; i < hobjs[id].end; i++)
        {
            curr.mem[i] = 0;
        }
    }
}
//syscall 23;memdump()
int memdump(ref Machine machine, double[] p)
{
    machine.print();
    return 0;
}
//syscall 24; malloc(int size,register addr,register id)
int malloc(ref Machine machine, double[] p)
{
    double[] params = handleRegisters(machine, p, 1);
    heapObj obj = machine.currThread.heap.getObj(cast(int) params[0]);
    setRegister(machine, p[1], machine.currThread.heap.getDataPtr(obj));
    setRegister(machine, p[2], obj.id);
    return 3;
}
//syscall 25; free(int id)
int free(ref Machine machine, double[] p)
{
    double[] params = handleRegisters(machine, p, 1);
    machine.currThread.heap.free(cast(int) params[0]);
    return 1;
}
//syscall 26; memcpy(int src,int dest,int size)
int memcopy(ref Machine machine, double[] p)
{
    double[] params = handleRegisters(machine, p, 3);
    int src = cast(int) params[0];
    int dest = cast(int) params[1];
    int size = cast(int) params[2];
    for (int i = 0; i < size; i++)
    {
        if (dest + i > machine.currThread.mem.length - 1)
            machine.currThread.mem.length = dest + i + 1;
        machine.currThread.mem[dest + i] = machine.currThread.mem[src + i];
    }
    return 3;
}
//syscall 27; memfill(int addr,int len,int value)
int memfill(ref Machine machine, double[] p)
{
    double[] params = handleRegisters(machine, p, 3);
    int addr = cast(int) params[0];
    int len = cast(int) params[1];
    int value = cast(int) params[2];
    for (int i = 0; i < len; i++)
    {
        if (addr + i > machine.currThread.mem.length - 1)
            machine.currThread.mem.length = addr + i + 1;
        machine.currThread.mem[addr + i] = value;
    }
    return 3;
}
//syscall 28; cast(value,type)
int castval(ref Machine machine, double[] p)
{
    double[] params = handleRegisters(machine, p, 2);
    double value = params[0];
    int type = cast(int) params[1];
    switch (type)
    {
    case 0:
        machine.currThread.registers.a = cast(int) cast(bool) value;
        break;
    case 1:
        machine.currThread.registers.a = cast(int) cast(char) value;
        break;
    case 2:
        machine.currThread.registers.a = cast(int) cast(short) value;
        break;
    case 3:
        machine.currThread.registers.a = cast(int) value;
        break;
    case 4:
        machine.currThread.registers.a = cast(int) cast(long) value;
        break;
    case 5:
        machine.currThread.registers.f = cast(float) value;
        break;
    case 6:
        machine.currThread.registers.a = cast(int) cast(byte) value;
        break;
    default:
        break;
    }
    return 2;
}
