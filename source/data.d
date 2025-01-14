import std;
import mem;
import time;
import random;
import dgfx;
struct Machine {
    double vmem_size = 0;
    double[] vmem;
    Registers registers;
    Flags flags;
    int ip=0;
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
    Thread* currThread;
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
        writeln("   Stack Base Pointer: ",machine.registers.sbp);
        writeln("   Stack Pointer: ",machine.registers.sp);
        writeln("   Stack:");
        writeln("       ", machine.stack);
        writeln("   Heap:");
       foreach(heap; machine.heap.objs) {heap.print();writeln("");}
        writeln("   Memory:");
        writeln("       ", machine.vmem);
        writeln("   Instruction Pointer: ", machine.ip);
        writeln("   Flags:");
        writeln("   Zero: ", machine.flags.zero);
        writeln("   Overflow: ", machine.flags.overflow);
        writeln("   Negative: ", machine.flags.negative);
        writeln("   Carry: ", machine.flags.carry);
    }
}
struct Thread{
    Registers registers;
    Flags flags;
    int errAddr;
    double[] mem;
    int id;
    Thread *next;
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