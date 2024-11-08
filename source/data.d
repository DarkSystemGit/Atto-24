import std;
import mem;
import time;
import random;
struct Machine {
    real memory_size = 0;
    real[] memory = new real[0];
    Registers registers;
    Flags flags;
    int ip;
    int[] raddr;
    int sp;
    int p;
    bool _debug;
    bool err;
    bool running;
    int errAddr;
    real bp;
    Objects objs;
    machineHeap heap;
    real[] stack = new real[0];
    void print() {
        Machine machine = this;
        writeln("Machine:");
        writeln("   Registers:");
        writeln("   A: ", machine.registers.a);
        writeln("   B: ", machine.registers.b);
        writeln("   C: ", machine.registers.c);
        writeln("   D: ", machine.registers.d);
        writeln("   E: ", machine.registers.e);
        writeln("   F: ", machine.registers.f);
        writeln("   G: ", machine.registers.g);
        writeln("   H: ", machine.registers.h);
        writeln("   I: ", machine.registers.i);
        writeln("   J: ", machine.registers.j);
        writeln("   Stack:");
        writeln("       ", machine.stack);
        writeln("   Heap:");
       foreach(heap; machine.heap.objs) {heap.print();writeln("");}
        writeln("   Memory:");
        writeln("       ", machine.memory);
        writeln("   Instruction Pointer: ", machine.ip);
        writeln("   Flags:");
        writeln("   Zero: ", machine.flags.zero);
        writeln("   Overflow: ", machine.flags.overflow);
        writeln("   Negative: ", machine.flags.negative);
        writeln("   Carry: ", machine.flags.carry);
    }
}

struct Registers {
    int a;
    int b;
    int c;
    int d;
    int e;
    float f;
    float g;
    real h;
    real i;
    real j;
}

struct Flags {
    bool zero;
    bool negative;
    bool overflow;
    bool carry;
}
struct Objects{
    Time[] times=new Time[0];
    Distrubution[] dists;
    int addDist(){
        Distrubution dist=  Distrubution(dists.length);
        dists ~= dist;
        return dist.id;
    }
    int addTime(){
        Time t=new Time(cast(int)times.length);
        times ~= t;
        return t.id;
    }
}
enum TokenType
{
    REG_A,
    REG_B,
    REG_C,
    REG_D,
    REG_E,
    REG_F,
    REG_G,
    REG_H,
    REG_I,
    REG_J,
    NOP,
    ADD,
    ADDF,
    SUB,
    SUBF,
    MUL,
    AND,
    NOT,
    OR,
    XOR,
    CP,
    JMP,
    JNZ,
    JZ,
    CMP,
    SYS,
    READ,
    WRITE,
    PUSH,
    POP,
    MOV,
    CALL,
    RET,
    INC,
    DEC,
    INCF,
    DECF,
    MULF,
    SETERRADDR,
    EXIT,
    TRUE,
    FALSE,
    STRING,
    DEFINE,
    NUMBER,
    NULL,
    IDENTIFIER,
    EOF,
    SEMICOLON,
    COLON,
    COMMA,
    EQUALS,
    LPAREN,
    RPAREN,
    LABEL,
    PTR,
    NONE
}
enum StmtType{
    COMMAND,
    LABEL_DEF,
    DEFINE,
    NUM,
    STRING
}
struct Statement{
    StmtType type;
    Token[] tokens;
    StmtData props;
}
Statement makeCmdStmt(TokenType cmd,Token[] oprands){
    Statement s;
    s.type=StmtType.COMMAND;
    s.props.cd.cmd=cmd;
    s.props.cd.oprands=oprands;
    return s;
}
Statement makeLabelDefStmt(string name,int addr){
    Statement s;
    s.type=StmtType.LABEL_DEF;
    s.props.ld.name=name;
    s.props.ld.addr=addr;
    return s;
}
Statement makeDefineStmt(string name,Token value){
    Statement s;
    s.type=StmtType.DEFINE;
    s.props.dd.name=name;
    s.props.dd.value=value;
    return s;
}
Statement makeNumStmt(real[] values){
    Statement s;
    s.type=StmtType.NUM;
    s.props.nd.values=values;
    return s;
}
Statement makeStringStmt(string value){
    Statement s;
    s.type=StmtType.STRING;
    s.props.sd.value=value;
    return s;
}
union StmtData{
    CommandData cd;
    LabelData ld;
    DefineData dd;
    NumData nd;
    StringData sd;
}
struct CommandData{
    TokenType cmd;
    Token[] oprands;
}
struct LabelData{
    string name;
    int addr;
}
struct DefineData{
    string name;
    Token value;
}
struct NumData{
    real[] values;
}
struct Token
{
    TokenType type;
    string literal;
    int line;
    int col;
}
struct StringData{
    string value;
}    