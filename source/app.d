import std;
import interpreter;
import parser;
void main(string[] argv) { 
    string[string] args;
    args["--src"]="";
    args["--debug"]="false";
    args["--compiler-debug"]="false";
    for(int i=1;i<argv.length-1;i+=2) {
        args[argv[i]]=argv[i+1];
    }
    if(args["--src"]=="") {writefln("Usage: ./uasm --src <source file> [--debug <true/false>] [--compiler-debug <true/false>]");return;}
     Tokenizer tk=new Tokenizer();
    tk.scanTokens(readText(args["--src"]));
    writeln(tk.tokens);
    Parser p=new Parser(tk.tokens);
    //runPrgm(readText(args["--src"]),args["--debug"].to!bool,args["--compiler-debug"].to!bool);
}
