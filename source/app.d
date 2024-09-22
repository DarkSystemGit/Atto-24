import std;
import interpreter;

void main(string[] args) { 
    bool _debug=false;
    bool bytecode=false;
    if(args.length>2){
        _debug=args[2].to!bool;
    }
    if(args.length>3){
        bytecode=args[3].to!bool;
    }    
    runPrgm("prgm",readText(args[1]),_debug,bytecode);
}
