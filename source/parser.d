import std;
import colorize;
import data;

class Tokenizer
{
    string source;
    int pos;
    int start;
    int line;
    int col;
    bool err;
    Token[] tokens;
    TokenType[string] keywords;
    TokenType[string] registers;
    this(){
        registers["A"] = TokenType.REG_A;
        registers["B"] = TokenType.REG_B;
        registers["C"] = TokenType.REG_C;
        registers["D"] = TokenType.REG_D;
        registers["E"] = TokenType.REG_E;
        registers["F"] = TokenType.REG_F;
        registers["G"]=TokenType.REG_G;
        registers["H"]=TokenType.REG_H;
        registers["I"]=TokenType.REG_I;
        registers["J"]=TokenType.REG_J;
        keywords["nop"]=TokenType.NOP;
        keywords["add"]=TokenType.ADD;
        keywords["addf"]=TokenType.ADDF;
        keywords["sub"]=TokenType.SUB;
        keywords["subf"]=TokenType.SUBF;
        keywords["mul"]=TokenType.MUL;
        keywords["and"]=TokenType.AND;
        keywords["not"]=TokenType.NOT;
        keywords["or"]=TokenType.OR;
        keywords["xor"]=TokenType.XOR;
        keywords["cp"]=TokenType.CP;
        keywords["jmp"]=TokenType.JMP;
        keywords["jnz"]=TokenType.JNZ;
        keywords["jz"]=TokenType.JZ;
        keywords["cmp"]=TokenType.CMP;
        keywords["sys"]=TokenType.SYS;
        keywords["read"]=TokenType.READ;
        keywords["write"]=TokenType.WRITE;
        keywords["push"]=TokenType.PUSH;
        keywords["pop"]=TokenType.POP;
        keywords["mov"]=TokenType.MOV;
        keywords["call"]=TokenType.CALL;
        keywords["ret"]=TokenType.RET;
        keywords["inc"]=TokenType.INC;
        keywords["dec"]=TokenType.DEC;
        keywords["incf"]=TokenType.INCF;
        keywords["decf"]=TokenType.DECF;
        keywords["seterraddr"]=TokenType.SETERRADDR;
        keywords["exit"]=TokenType.EXIT;
        keywords["true"]=TokenType.TRUE;
        keywords["false"]=TokenType.FALSE;
        keywords["null"]=TokenType.NULL;

    }
    void scanToken(string src)
    {
        char c = advance();
        switch (c)
        {
        case '\n':
            line++;
            return;
        case ' ':return;    
        case '\t':return;
        case '(':
        addToken(TokenType.LPAREN, "(");
        return;
        case ')':
        addToken(TokenType.RPAREN, ")");
        return;
        case '=':
        addToken(TokenType.EQUALS, "=");
        return;
        case '"':
            string s;
            while (peek() != '"')
            {
                s ~= advance();
            }
            advance();
            addToken(TokenType.STRING, s);
            return;
        case '/':
            string s;
            if (peek() != '*'){
            consume(c, "Expected slash");
            comment();
            }else{
                consume('*', "Expected star");
                cComment();
            }
            return;
        case ';':
            addToken(TokenType.SEMICOLON, ";");
            return;
        case ':':
            addToken(TokenType.COLON, ":");
            return;
        case ',':
            addToken(TokenType.COMMA, ",");
            return;
        case '#':
            string n;
            n~=c;

            while (isAlphanum(cast(char)peek())&&(!isAtEnd()))
            {
                n ~= advance();
            }
            if(n=="#define"){
                addToken(TokenType.DEFINE, n);
            }else{
                error("Unexpected string, "~n~" is not a valid token");
            }
            return;
        case '%':
            if(cast(string)[peek()] in registers){
                addToken(registers[cast(string)[peek()]],cast(string)[c,advance()]);
            }else{
                error("Unexpected character, "~c~" is not a valid register");
            }
            return;    
        default:
            if ((std.ascii.isDigit(cast(char)c)||(cast(char)c =='-'))&&std.ascii.isDigit(cast(char)peek()))
            {
                string n;
                n~=c;
                while ((std.ascii.isDigit(cast(char)peek()) || (peek() == '.' && isDigit(cast(char)peekNext())))&&(!isAtEnd()))
                {
                    n ~= advance();
                }
                addToken(TokenType.NUMBER, n);
                
            }else if (isAlphanum(cast(char)c)){
                string n;
                n~=c;
                while ((isAlphanum(cast(char)peek()))&&(!isAtEnd()))
                {
                    n ~= advance();
                }

                if(!(n in keywords))addToken(TokenType.IDENTIFIER,n);
                else addToken(keywords[n],n);
            }else{
                error("Unexpected character, "~c);
            }
            
            return;
        }
    }
    bool isAlphanum(char c){
        return std.ascii.isAlpha(c) || std.ascii.isDigit(c)||c=='_';
    }
        void comment(){
            while ((peek() != '\n')&&(!isAtEnd()))
            {
                advance();
            }
            return;
        }
        void cComment(){
            while ((peek() != '*')&&(!isAtEnd())){
                advance();
            }
            consume('*', "Expected star");
            consume('/', "Expected slash");
            return;
        }    
        void scanTokens(string src)
        {
            this.source = src;
            this.pos = 0;
            this.col=0;
            this.line=1;
            while (!isAtEnd())
            { 
                start = pos;
                scanToken(this.source);
            }
            TokenType eof = TokenType.EOF;
            addToken(eof);
        }

        void addToken(Token t)
        {
            t.line=line;
            t.col=col;
            tokens.length++;
            tokens[tokens.length - 1] = t;
        }

        void addToken(TokenType type)
        {
            Token t;
            t.type = type;
            addToken(t);
        }

        void addToken(TokenType type, string l)
        {
            Token t;
            t.type = type;
            t.literal = l;
            addToken(t);
        }

        bool isAtEnd()
        {
            return pos >= source.length;
        }

        char advance()
        {   
            if(!isAtEnd()){
            col++;
            return source[pos++];}else{return cast(char)0;}
        }
    char consume(char c, string err)
        {
            if (check(c))
                return advance();
           error(err);
            return cast(char)0;
        }
        bool check(char c)
        {
            if (isAtEnd())
                return false;
            return peek() == c;
        }
        char peek()
        {
            if (isAtEnd())
                return cast(char)0;
            return source[pos];
        }

        char peekNext()
        {
            if (pos + 1 >= source.length)
                return cast(char)0;
            return source[pos + 1];
        }

        bool match(char c)
        {
            if (isAtEnd())
                return false;
            if (source[pos] != c)
                return false;
            col++;
            pos++;
            return true;
        }
        void error(string msg){
            err=true;
            cwrite(("Error at ("~line.to!string()~","~col.to!string()~"): ").color(fg.red).color(mode.bold));
            cwriteln(msg.color(mode.bold));

        }
    }

    class Parser
    {
        Token[] tokens;
        int pos;
        bool err;
        Statement[] stmts;
        void parse(Token[] tokens){
             this.tokens = tokens;
             while(!isAtEnd()){
                parseTokens();
             }
        }
        void addStmt(Statement stmt){
            stmts.length++;
            stmts[stmts.length-1]=stmt;
        }
        void parseTokens(){
            bool cmd=matchTTs([TokenType.ADD,TokenType.ADDF,TokenType.SUB,TokenType.SUBF,TokenType.NOP,TokenType.MUL,TokenType.AND,TokenType.NOT,TokenType.OR,TokenType.XOR,TokenType.CP,TokenType.JMP,TokenType.JNZ,TokenType.JZ,TokenType.CMP,TokenType.SYS,TokenType.PUSH,TokenType.POP,TokenType.READ,TokenType.WRITE,TokenType.CALL,TokenType.RET,TokenType.INC,TokenType.INCF,TokenType.DEC,TokenType.DECF,TokenType.EXIT,TokenType.SETERRADDR],tokens[pos])
            bool define=check();
        }
        Token consume(TokenType t, string err)
        {
            if (check(t))
                return advance();
            error(err);
            return Token(); 
        }
        TokenType matchTTs(TokenType[] tlist,Token t){
            for(int i=0; i<tlist.length;i++){
                if(t.type=tlist[i])return tlist[i];
            }
            return TokenType.NONE;
        }
        bool check(TokenType t)
        {
            if (isAtEnd())
                return false;
            return peek().type == t;
        }

        Token advance()
        {
            if (!isAtEnd())
                pos++;
            return previous();
        }

        bool isAtEnd()
        {
            return peek().type == TokenType.EOF;
        }

        Token peek()
        {
            return tokens[pos];
        }

        Token previous()
        {
            return tokens[pos - 1];
        }

        void error(string msg){
            err=true;
            cwrite(("Error at ("~peek().line.to!string()~","~peek().col.to!string()~"): ").color(fg.red).color(mode.bold));
            cwriteln(msg.color(mode.bold));

        }
    }