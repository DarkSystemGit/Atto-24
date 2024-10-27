import std;
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
    IDENTIFIER,
    EOF,
    SEMICOLON
}
struct Token
{
    TokenType type;
    string literal;
}
class Tokenizer{
    string source;
    int pos;
    int start;
    Token[] tokens;
    Token scanToken(string src){
        string c=advance();
        switch(c){
            case "\"":
                string s;
                while(peek()!="\""){
                    s~=advance();
                }   
                advance();
                addToken(TokenType.STRING,s); 
                return;
            case "/":
                string s; 
                advance();
                while(peek()!=";"){
                    s~=advance();
                }
                return;
            default:
                if(std.ascii.isDigit(c)){
                    string n=c;
                    while(std.ascii.isDigit(peek())||(peek()=="."&&isDigit(peekNext()))){
                        n~=advance();
                    }
                    addToken(TokenType.NUMBER,n);
                }
                return;
        }
    }
    bool isDigit(string c){
    void scanTokens(string src){
        this.source=src;
        this.pos=0;
        while(!isAtEnd()){
            start=pos;
            scanToken(this.source);
        }
        TokenType eof=TokenType.EOF;
        addToken(eof);
    }
    void addToken(Token t){
        tokens.length++;
        tokens[tokens.length-1]=t;
    }   
    void addToken(TokenType t){
        Token t;
        t.type=t;
        addToken(t);
    }
    void addToken(TokenType t,string l){
        Token t;
        t.type=t;
        t.literal=l;
        addToken(t);
    }
    bool isAtEnd(){
        return pos>=source.length;
    }
    string advance(){
        return source[pos++];
    }    
    string peek(){
        if(isAtEnd())return "";
        return source[pos];
    }    
    string peekNext(){
        if(pos+1>=source.length)return "";
        return source[pos+1];
    }    
    bool match(string c){
        if(isAtEnd())return false;
        if(source[pos]!=c)return false;
        pos++;
        return true;
    }
}
class Parser{
    Token[] tokens;
    int pos;
    bool err;
    void consume(TokenType t,string err){
        if(check(t))return advance();
        throw new Exception(err);
    }
    bool check(TokenType t){
        if(isAtEnd())return false;
        return peek().type==t;
    }
    Token advance(){
        if(!isAtEnd())pos++;
        return previous();
    }
    bool isAtEnd(){
        return peek().type==TokenType.EOF;
    }
    Token peek(){
        return tokens[pos];
    }
    Token previous(){
        return tokens[pos-1];
    } 
    void error(string msg){
        err=true;
        throw new Exception("Error at Token ",pos,":",msg);
    };
}