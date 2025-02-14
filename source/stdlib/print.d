import data;
import registers;
import std;
import utils;

//syscall 0;print(int a)
int print(ref Machine machine, double[] p)
{
    double[] params = handleRegisters(machine, p, 1);
    write(params[0]);
    return 1;
}
//syscall 1;print(char a)
int printASCII(ref Machine machine, double[] p)
{
    double[] params = handleRegisters(machine, p, 1);

    write(params[0].to!char);
    return 1;
}
//syscall 2;print(string* str)
int printStr(ref Machine machine, double[] p)
{
    double[] params = handleRegisters(machine, p, 1);
    int mempos = cast(int) params[0];
    bool eol;
    for (int i = 0; !eol; i++)
    {

        if ((machine.currThread.mem.length > mempos + i) && (
                cast(int) machine.currThread.mem[mempos + i] != 0))
        {
            write(cast(char) cast(int) machine.currThread.mem[mempos + i]);
        }
        else
        {
            eol = true;
        }
    }
    return 1;
}
