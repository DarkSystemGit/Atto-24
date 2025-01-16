import std;
import mem;
import time;
import random;
import dgfx;
struct Machine {
    Registers registers;
    Flags flags;
    int[] raddr;
    int p;
    bool _debug;
    bool running;
    int errAddr;
    Objects objs;
    machineHeap heap;
    bool dprompt;
    double[] stack = new double[0];
    string basepath;
    bool unhandledErr;
    Thread currThread;
    ThreadList threads;
    void print() {
        Machine machine = this;
        writeln("Machine:");
        writeln("   Registers:");
        writeln("   A: ", machine.currThread.registers.a);
        writeln("   B: ", machine.currThread.registers.b);
        writeln("   C: ", machine.currThread.registers.c);
        writeln("   D: ", machine.currThread.registers.d);
        writeln("   E: ", machine.currThread.registers.e);
        writeln("   F: ", machine.currThread.registers.f);
        writeln("   G: ", machine.currThread.registers.g);
        writeln("   H: ", machine.currThread.registers.h);
        writeln("   I: ", machine.currThread.registers.i);
        writeln("   J: ", machine.currThread.registers.j);
        writeln("   Stack Base Pointer: ",machine.currThread.registers.sbp);
        writeln("   Stack Pointer: ",machine.currThread.registers.sp);
        writeln("   Stack:");
        writeln("       ", machine.stack);
        writeln("   Heap:");
       foreach(heap; machine.heap.objs) {heap.print();writeln("");}
        writeln("   Memory:");
        writeln("       ", machine.currThread.mem);
        writeln("   Instruction Pointer: ", machine.currThread.ip);
        writeln("   Flags:");
        writeln("   Zero: ", machine.flags.zero);
        writeln("   Overflow: ", machine.flags.overflow);
        writeln("   Negative: ", machine.flags.negative);
        writeln("   Carry: ", machine.flags.carry);
    }
}
class Thread{
    Registers registers;
    Flags flags;
    int errAddr;
    double[] mem;
    int id;
    int ip;
    Thread next;
}
class ThreadList{
    Thread head;
    Thread tail;
    Thread curr;
    this(){
        Thread t=new Thread;
        t.id=0;
        t.next=t;
        this.head=t;
        this.tail=t;
        this.curr=t;
    }
    void addThread(Thread t){
        t.id=tail.id+1;
        t.next=head;
        this.tail.next=t;
        this.tail=t;
    }
    void removeThread(int id){
        if(id==0)return;
        Thread t=head;
        Thread prev;
        while(t.id!=id){
            prev=t;
            t=t.next;
        }
        prev.next=t.next;
    }
    void switchThread(int id){
        Thread t=head;
        while(t.id!=id){
            t=t.next;
        }
        this.curr=t;
    }
    void switchThread(){
        this.curr=this.curr.next;
    }
    void print(){
        Thread t=head;
        writeln("Thread List:");
        bool f=true;
        while(t.id!=0||f){
            f=false;
            writeln("Thread ",t.id);
            writeln("   Registers:");
            writeln("       A: ", t.registers.a);
            writeln("       B: ", t.registers.b);
            writeln("       C: ", t.registers.c);
            writeln("       D: ", t.registers.d);
            writeln("       E: ", t.registers.e);
            writeln("       F: ", t.registers.f);
            writeln("       G: ", t.registers.g);
            writeln("       H: ", t.registers.h);
            writeln("       I: ", t.registers.i);
            writeln("       J: ", t.registers.j);
            writeln("       Stack Base Pointer: ",t.registers.sbp);
            writeln("       Stack Pointer: ",t.registers.sp);
            writeln("   Flags:");
            writeln("       Zero: ", t.flags.zero);
            writeln("       Overflow: ", t.flags.overflow);
            writeln("       Negative: ", t.flags.negative);
            t=t.next;
        }

    }
}
struct Registers {
    int a;
    int b;
    int c;
    int d;
    int e;
    float f=0;
    float g=0;
    double h=0;
    double i=0;
    double j=0;
    double sp=0;//top of stack frame
    double sbp=0;//top of stack
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
    random.Random[] rands;
    tmInfo[] tilemaps;
    GFX gfx;
    int vramAddr;
    int gfxInputAddr;
    heapObj inputs;
    Sprite[] sprites;
    TileMap[] maps;
    arrayObj[] arrayObjs;
    int addSprite(){
        Sprite sprite;
        sprites~=sprite;
        return cast(int)(sprites.length-1);
    }
    int addMap(){
        TileMap map;
        maps~=map;
        return cast(int)(maps.length-1);
    }
    int addDist(){
        Distrubution dist=new Distrubution(cast(int)dists.length);
        dists ~= dist;
        return dist.id;
    }
    int addRandom(){
        random.Random rand=random.Random(cast(int)rands.length);
        rands~=rand;
        return rand.id;
    }
    int addTime(){
        Time t=new Time(cast(int)times.length);
        times ~= t;
        return t.id;
    }
}
struct arrayObj{
    int id;
    double addr;
}
struct UserSprite{
    int x;
    int y;
    float angle;
    ubyte[] pixels;
    float[] scaledDims;
}
struct UserArray{
    bool dynamic;
    double* capacity;
    double* length;
    double* ptr;
    double[] body;
}
struct UserTilemap{
    int x;
    int y;
    ubyte[] tilelist;
    ubyte[64][512] tileset;
    int id;
    int width;
    int height;
}
struct tmInfo{
    int addr;
    int heapId;
    bool rerender;
    TileMap tm;
}
enum Key{
    UP,
    DOWN,
    LEFT,
    RIGHT,
    Z,
    X
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
    REG_SBP,
    REG_SP,
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
    DIV,
    MOD,
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
    JG,
    JNG,
    BREAKPOINT,
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
    ARRAY,
    LABEL,
    PTR,
    NONE
}
enum StmtType{
    COMMAND,
    LABEL_DEF,
    DEFINE,
    NUM,
    STRING,
    EXP
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
Statement makeDefineStmt(string name,Token[] value){
    Statement s;
    s.type=StmtType.DEFINE;
    s.props.dd.name=name;
    s.props.dd.value=value;
    return s;
}
Statement makeNumStmt(double[] values){
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
Statement makeExpStmt(Token[] data){
    Statement s;
    s.type=StmtType.EXP;
    s.props.exp=data;
    return s;
}
union StmtData{
    CommandData cd;
    LabelData ld;
    DefineData dd;
    NumData nd;
    Token[] exp;
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
    Token[] value;
}
struct NumData{
    double[] values;
}
struct Token
{
    TokenType type;
    string literal;
    Token[] subtokens;
    int line;
    int col;
}
struct StringData{
    string value;
}    