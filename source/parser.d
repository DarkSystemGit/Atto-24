enum TokenType{
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
    SETERRADDR,
    EXIT,
    TRUE,
    FALSE,
    STRING,
    LABEL,
    DEFINE,
    NUMBER,
    NULL,
    IDENTIFIER
}
struct Token
{
    TokenType token;
    string literal;
}
class Parser{
    Token[] tokens;
    int pos;
    bool err;
    void consume(TokenType t,string err){
        if(check(t))return advance;
        throw new Exception(err);
    }
    
    voidd error(string msg);
}