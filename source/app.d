import std;
import interpreter;
import parser;
import data;
import compiler;
void main(string[] argv) { 
    string[string] args;
    args["--src"]="";
    args["--debug"]="false";
    args["--compiler-debug"]="false";
    for(int i=1;i<argv.length-1;i+=2) {
        args[argv[i]]=argv[i+1];
    }
    if(args["--src"]=="") {writefln("Usage: ./uasm --src <source file> [--debug <true/false>] [--compiler-debug <true/false>]");return;}
    Compiler c=new Compiler();
    string src=readText(args["--src"]);
    writeln("New Compiler");
    c.comp(src,args["--src"]);
    foreach(stmt; c.stmts){
        write(stmt.type," ");
        if(stmt.type==StmtType.COMMAND){
            writeln(stmt.props.cd);

        }else if(stmt.type==StmtType.LABEL_DEF){
            writeln(stmt.props.ld);
        }else if(stmt.type==StmtType.NUM){
            writeln(stmt.props.nd);
        }else if(stmt.type==StmtType.DEFINE){
            writeln(stmt.props.dd);
        }

    }
    /*
    writeln(c.labels);
    writeln(c.defines);
   
    writeln("Old compiler");
    writeln(compile(src,true));
    writeln("New bytecode");*/
     writeln(c.bytecode);
      Machine machine = execBytecode(c.bytecode, false);
    //runPrgm(readText(args["--src"]),args["--debug"].to!bool,args["--compiler-debug"].to!bool);
}
