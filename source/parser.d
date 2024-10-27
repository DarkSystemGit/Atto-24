import std;

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

class Tokenizer
{
    string source;
    int pos;
    int start;
    Token[] tokens;
    void scanToken(string src)
    {
        char c = advance();
        switch (c)
        {
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
            advance();
            while (peek() != ';')
            {
                s ~= advance();
            }
            return;
        default:
            if (std.ascii.isDigit(cast(char)c))
            {
                string n;
                n~=c;
                while (std.ascii.isDigit(cast(char)peek()) || (peek() == '.' && isDigit(cast(char)peekNext())))
                {
                    n ~= advance();
                }
                addToken(TokenType.NUMBER, n);
            }
            return;
        }
    }

    
        void scanTokens(string src)
        {
            this.source = src;
            this.pos = 0;
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
            return source[pos++];
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
            pos++;
            return true;
        }
    }

    class Parser
    {
        Token[] tokens;
        int pos;
        bool err;
        Token consume(TokenType t, string err)
        {
            if (check(t))
                return advance();
            throw new Exception(err);
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

        void error(string msg)
        {
            err = true;
            throw new Exception("Error at Token "~ pos.to!string~":"~msg);
        };
    }
void main(){
    Tokenizer tk=new Tokenizer();
    
}