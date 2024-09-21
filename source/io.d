import std;
import data;

class printHandler : sysHandler{
    int paramCount = 1;
    override void syscall(Machine machine, real[] params) {
        writeln(params[0]);
    }
}
