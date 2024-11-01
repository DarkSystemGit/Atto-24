import std;
import interpreter;
import data;
import compiler;
void main(string[] argv) { 
        writeln("UASM Interpreter v1.0.0");
    string[string] args;
    args["--src"]="";
    args["--debug"]="false";
    args["--compiler-debug"]="false";
    for(int i=1;i<argv.length-1;i+=2) {
        args[argv[i]]=argv[i+1];
    }
    if(args["--src"]=="") {writefln("Usage: ./uasm --src <source file> [--debug <true/false>] [--compiler-debug <true/false>]");return;}
        writeln("Compiling...");
    Compiler c=new Compiler();
    string src=readText(args["--src"]);
    c.comp(src,args["--src"],args["--compiler-debug"].to!bool);
    if(args["--compiler-debug"].to!bool){
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
        }else if(stmt.type==StmtType.STRING){
            writeln(stmt.props.sd);
            }}
        writeln(c.bytecode);
    }else{
        Machine machine = execBytecode(c.bytecode, args["--debug"].to!bool);
    }

}
